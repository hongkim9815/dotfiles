#!/bin/bash
# Custom Claude Code statusline

input=$(cat)

# ---- color helpers ----
use_color=1
[ -n "$NO_COLOR" ] && use_color=0

clr() { [ "$use_color" -eq 1 ] && printf '\033[%sm' "$1" || true; }
rst() { [ "$use_color" -eq 1 ] && printf '\033[0m' || true; }

dir_color()      { clr '97'; }
git_main_color() { clr '31'; }
git_color()      { clr '32'; }
haiku_color()    { clr '38;5;228'; }
sonnet_color()   { clr '38;5;118'; }
opus_color()     { clr '38;5;177'; }
dim_color()      { clr '2'; }

ctx_color() {
  local p="${1:-0}"
  if   (( p >= 80 )); then clr '38;5;196'
  elif (( p >= 70 )); then clr '38;5;202'
  elif (( p >= 50 )); then clr '38;5;226'
  else                     clr '97'
  fi
}

budget_color() {
  local p="${1:-0}"
  if   (( p >= 90 )); then clr '38;5;196'
  elif (( p >= 80 )); then clr '38;5;202'
  elif (( p >= 60 )); then clr '38;5;226'
  else                     clr '38;5;255'
  fi
}

model_color() {
  case "$1" in
    haiku)  haiku_color ;;
    sonnet) sonnet_color ;;
    opus)   opus_color ;;
    *)      clr '97' ;;
  esac
}

# ---- time helpers ----
to_epoch() {
  local ts="$1"
  if command -v gdate >/dev/null 2>&1; then gdate -d "$ts" +%s 2>/dev/null && return; fi
  date -u -j -f "%Y-%m-%dT%H:%M:%S%z" "${ts/Z/+0000}" +%s 2>/dev/null && return
  python3 - "$ts" <<'PY' 2>/dev/null
import sys, datetime
s = sys.argv[1].replace('Z', '+00:00')
print(int(datetime.datetime.fromisoformat(s).timestamp()))
PY
}

fmt_time_hm() {
  local epoch="$1"
  if date -r 0 +%s >/dev/null 2>&1; then date -r "$epoch" +"%H:%M"; else date -d "@$epoch" +"%H:%M"; fi
}

# ---- simple progress bar ----
progress_bar() {
  local pct="${1:-0}" width="${2:-20}"
  [[ "$pct" =~ ^[0-9]+$ ]] || pct=0
  (( pct <   0 )) && pct=0
  (( pct > 100 )) && pct=100
  local filled=$(( pct * width / 100 )) i bar=""
  for (( i=0; i<filled;          i++ )); do bar+="█"; done
  for (( i=filled; i<width;      i++ )); do bar+="░"; done
  printf '%s' "$bar"
}

# ---- multi-color model bar (always 100% full, 40-char width) ----
model_bar() {
  local h_pct=$1 s_pct=$2 o_pct=$3
  local width=40
  local hb=$(( h_pct * width / 100 ))
  local sb=$(( s_pct * width / 100 ))
  local ob=$(( o_pct * width / 100 ))
  local used=$(( hb + sb + ob ))

  # If no data, fill entirely with current model color
  if (( used == 0 )); then
    case "$model_tier" in
      haiku)  hb=$width ;;
      opus)   ob=$width ;;
      *)      sb=$width ;;
    esac
    used=$width
  fi

  # Distribute rounding gap to the largest segment
  local gap=$(( width - used ))
  if (( gap > 0 )); then
    if   (( ob >= sb && ob >= hb )); then ob=$(( ob + gap ))
    elif (( sb >= hb ));             then sb=$(( sb + gap ))
    else                                  hb=$(( hb + gap ))
    fi
  fi

  local HC SC OC RST i bar=""
  HC=$(haiku_color); SC=$(sonnet_color); OC=$(opus_color); RST=$(rst)
  for (( i=0; i<hb; i++ )); do bar+="${HC}█"; done
  for (( i=0; i<sb; i++ )); do bar+="${SC}█"; done
  for (( i=0; i<ob; i++ )); do bar+="${OC}█"; done
  bar+="${RST}"
  printf '%s' "$bar"
}

# ---- model bar masked by utilization pct (filled=colored, rest=dim ░) ----
model_bar_masked() {
  local h_pct=$1 s_pct=$2 o_pct=$3 util_pct=$4
  local width=40
  [[ "$util_pct" =~ ^[0-9]+$ ]] || util_pct=0
  local filled=$(( util_pct * width / 100 ))
  local empty=$(( width - filled ))

  # Compute per-model char counts within filled region
  local hb=$(( h_pct * filled / 100 ))
  local sb=$(( s_pct * filled / 100 ))
  local ob=$(( o_pct * filled / 100 ))
  local used=$(( hb + sb + ob ))

  if (( used == 0 && filled > 0 )); then
    case "$model_tier" in
      haiku) hb=$filled ;;
      opus)  ob=$filled ;;
      *)     sb=$filled ;;
    esac
    used=$filled
  fi

  local gap=$(( filled - used ))
  if (( gap > 0 )); then
    if   (( ob >= sb && ob >= hb )); then ob=$(( ob + gap ))
    elif (( sb >= hb ));             then sb=$(( sb + gap ))
    else                                  hb=$(( hb + gap ))
    fi
  fi

  local HC SC OC DIM RST i bar=""
  HC=$(haiku_color); SC=$(sonnet_color); OC=$(opus_color)
  DIM=$(dim_color); RST=$(rst)
  for (( i=0; i<hb; i++ )); do bar+="${HC}█"; done
  for (( i=0; i<sb; i++ )); do bar+="${SC}█"; done
  for (( i=0; i<ob; i++ )); do bar+="${OC}█"; done
  for (( i=0; i<empty; i++ )); do bar+="${DIM}░"; done
  bar+="${RST}"
  printf '%s' "$bar"
}

# ---- parse stdin ----
current_dir="unknown"; model_id=""; model_name="Claude"
cc_version=""; context_used_pct=""; transcript_path=""

if command -v jq >/dev/null 2>&1; then
  current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "unknown"' 2>/dev/null | sed "s|^$HOME|~|")
  model_id=$(echo "$input" | jq -r '.model.id // ""' 2>/dev/null)
  model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"' 2>/dev/null)
  cc_version=$(echo "$input" | jq -r '.version // ""' 2>/dev/null)
  context_used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)
  transcript_path=$(echo "$input" | jq -r '.transcript_path // empty' 2>/dev/null)
fi

# ---- git ----
git_branch=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  git_branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
fi

# ---- model tier ----
model_tier="sonnet"
case "$model_id" in
  *haiku*) model_tier="haiku" ;;
  *opus*)  model_tier="opus"  ;;
esac

# ---- Claude Max 5h usage (cached, TTL=60s) ----
max_utilization=""; max_reset_hm=""
MAX_CACHE="$HOME/.claude/cache/max_usage.cache"
MAX_CACHE_TTL=60

_max_cache_fresh() {
  [ -f "$MAX_CACHE" ] || return 1
  local cached_ts now
  cached_ts=$(head -1 "$MAX_CACHE" 2>/dev/null)
  [[ "$cached_ts" =~ ^[0-9]+$ ]] || return 1
  now=$(date +%s)
  (( now - cached_ts < MAX_CACHE_TTL ))
}

if command -v python3 >/dev/null 2>&1; then
  if _max_cache_fresh; then
    max_utilization=$(sed -n '2p' "$MAX_CACHE" 2>/dev/null)
    max_resets_at=$(sed -n '3p' "$MAX_CACHE" 2>/dev/null)
  else
    creds_json=""
    if [[ "$(uname)" == "Darwin" ]] && command -v security >/dev/null 2>&1; then
      creds_json=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
    fi
    if [ -z "$creds_json" ] && [ -f "$HOME/.claude/.credentials.json" ]; then
      creds_json=$(cat "$HOME/.claude/.credentials.json" 2>/dev/null)
    fi
    max_json=""
    if [ -n "$creds_json" ]; then
      max_json=$(printf '%s' "$creds_json" | python3 -c "
import urllib.request, json, sys
try:
    tok = json.load(sys.stdin)['claudeAiOauth']['accessToken']
    req = urllib.request.Request(
        'https://claude.ai/api/oauth/usage',
        headers={'x-api-key': tok, 'User-Agent': 'claude-code/2.1.71'}
    )
    with urllib.request.urlopen(req, timeout=5) as r:
        print(r.read().decode())
except: sys.exit(1)
" 2>/dev/null)
    fi

    if [ -n "$max_json" ]; then
      max_utilization=$(echo "$max_json" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(int(round(d['five_hour']['utilization'])))" 2>/dev/null)
      max_resets_at=$(echo "$max_json" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d['five_hour']['resets_at'])" 2>/dev/null)
      if [ -n "$max_utilization" ]; then
        mkdir -p "$(dirname "$MAX_CACHE")"
        printf '%s\n%s\n%s\n' "$(date +%s)" "$max_utilization" "$max_resets_at" > "$MAX_CACHE"
      fi
    fi
  fi

  if [ -n "$max_resets_at" ]; then
    max_reset_hm=$(fmt_time_hm "$(to_epoch "$max_resets_at")")
  fi
fi

# ---- per-model session cost estimate (main + sub-agent transcripts) ----
# Outputs: haiku_cost sonnet_cost opus_cost (in USD, 4 decimal places)
haiku_cost="0.0000"; sonnet_cost="0.0000"; opus_cost="0.0000"
haiku_pct=0; sonnet_pct=0; opus_pct=0
TRANSCRIPT_CACHE="$HOME/.claude/cache/transcript_model.cache"

if [ -n "$transcript_path" ] && [ -f "$transcript_path" ] && command -v python3 >/dev/null 2>&1; then
  t_mtime=$(stat -f '%m' "$transcript_path" 2>/dev/null || stat -c '%Y' "$transcript_path" 2>/dev/null)
  t_size=$(stat -f '%z' "$transcript_path" 2>/dev/null || stat -c '%s' "$transcript_path" 2>/dev/null)
  t_cache_key="${t_mtime}:${t_size}"

  model_data=""
  if [ -f "$TRANSCRIPT_CACHE" ]; then
    cached_key=$(head -1 "$TRANSCRIPT_CACHE" 2>/dev/null)
    if [ "$cached_key" = "$t_cache_key" ]; then
      model_data=$(sed -n '2p' "$TRANSCRIPT_CACHE" 2>/dev/null)
    fi
  fi

  if [ -z "$model_data" ]; then
  export CLAUDE_TRANSCRIPT="$transcript_path"
  model_data=$(python3 << 'PY' 2>/dev/null
import json, sys, os, glob

# Pricing per 1M tokens (USD): input, output, cache_write, cache_read
PRICING = {
    'haiku':  (0.80,  4.00,  1.00,  0.08),
    'sonnet': (3.00,  15.00, 3.75,  0.30),
    'opus':   (15.00, 75.00, 18.75, 1.50),
}

def calc_cost(tier, usage):
    p = PRICING[tier]
    return (
        usage.get('input_tokens', 0)                * p[0] / 1e6 +
        usage.get('output_tokens', 0)               * p[1] / 1e6 +
        usage.get('cache_creation_input_tokens', 0) * p[2] / 1e6 +
        usage.get('cache_read_input_tokens', 0)     * p[3] / 1e6
    )

def tally(path, costs, t_min, t_max):
    with open(path) as f:
        for line in f:
            try:
                d = json.loads(line)
                ts = d.get('timestamp', '')
                if ts and t_min is not None:
                    if ts < t_min or ts > t_max:
                        continue
                msg = d.get('message', {})
                model = msg.get('model', '')
                usage = msg.get('usage', {})
                if not model or not usage:
                    continue
                if 'haiku' in model:  tier = 'haiku'
                elif 'opus' in model: tier = 'opus'
                else:                 tier = 'sonnet'
                costs[tier] += calc_cost(tier, usage)
            except:
                pass

path = os.environ.get('CLAUDE_TRANSCRIPT', '')
if not path or not os.path.exists(path):
    print('0.0000 0.0000 0.0000'); sys.exit(0)

t_min = t_max = None
with open(path) as f:
    for line in f:
        try:
            ts = json.loads(line).get('timestamp', '')
            if ts:
                if t_min is None or ts < t_min: t_min = ts
                if t_max is None or ts > t_max: t_max = ts
        except:
            pass

costs = {'haiku': 0.0, 'sonnet': 0.0, 'opus': 0.0}
tally(path, costs, None, None)

proj_dir = os.path.dirname(path)
main_name = os.path.basename(path)
for other in glob.glob(os.path.join(proj_dir, '*.jsonl')):
    if os.path.basename(other) == main_name:
        continue
    in_range = False
    with open(other) as f:
        for line in f:
            try:
                ts = json.loads(line).get('timestamp', '')
                if ts and t_min <= ts <= t_max:
                    in_range = True; break
            except:
                pass
    if in_range:
        tally(other, costs, t_min, t_max)

print(f"{costs['haiku']:.4f} {costs['sonnet']:.4f} {costs['opus']:.4f}")
PY
)
    if [ -n "$model_data" ]; then
      mkdir -p "$(dirname "$TRANSCRIPT_CACHE")"
      printf '%s\n%s\n' "$t_cache_key" "$model_data" > "$TRANSCRIPT_CACHE"
    fi
  fi

  if [ -n "$model_data" ]; then
    haiku_cost=$(echo "$model_data"  | awk '{print $1}')
    sonnet_cost=$(echo "$model_data" | awk '{print $2}')
    opus_cost=$(echo "$model_data"   | awk '{print $3}')
    # Compute integer percentages for bar
    read haiku_pct sonnet_pct opus_pct < <(python3 -c "
h,s,o = $haiku_cost,$sonnet_cost,$opus_cost
t = h+s+o
if t==0: print('0 0 0')
else: print(int(round(h/t*100)), int(round(s/t*100)), max(0,100-int(round(h/t*100))-int(round(s/t*100))))
" 2>/dev/null)
  fi
fi

# ========== RENDER ==========

# ── Line 1: [{Model}] [Context: {pct}%] {dir} ⎇ {branch} ──
printf '%s[%s]%s' "$(model_color "$model_tier")" "$model_name" "$(rst)"
if [ -n "$context_used_pct" ] && [[ "$context_used_pct" =~ ^[0-9]+$ ]]; then
  printf ' %s[Context: %d%%]%s' "$(ctx_color "$context_used_pct")" "$context_used_pct" "$(rst)"
else
  printf ' [Context: TBD]'
fi
printf ' %s%s%s' "$(dir_color)" "$current_dir" "$(rst)"
if [ -n "$git_branch" ]; then
  case "$git_branch" in
    main|master) printf ' %s⎇ %s%s' "$(git_main_color)" "$git_branch" "$(rst)" ;;
    *)           printf ' %s⎇ %s%s' "$(git_color)"      "$git_branch" "$(rst)" ;;
  esac
fi

# ── Line 2: | Max:      {40-char bar} {pct}%  [Resets at {time}] ──
if [ -n "$max_utilization" ] && [[ "$max_utilization" =~ ^[0-9]+$ ]]; then
  max_bar=$(progress_bar "$max_utilization" 40)
  printf '\n| Max:      %s%s%s  %s%d%%%s' \
    "$(budget_color "$max_utilization")" "$max_bar" "$(rst)" \
    "$(budget_color "$max_utilization")" "$max_utilization" "$(rst)"
  [ -n "$max_reset_hm" ] && printf '  %s[Resets at %s]%s' "$(dim_color)" "$max_reset_hm" "$(rst)"
fi

# ── Line 3: | Model:    {model proportion bar} ──
mbar=$(model_bar "$haiku_pct" "$sonnet_pct" "$opus_pct")
printf '\n| Model:    %s' "$mbar"

# ── Lines 4+: |           {name}  | $XX.XX | XX.X% | ──
total_cost_f=$(python3 -c "print($haiku_cost+$sonnet_cost+$opus_cost)" 2>/dev/null || echo "0")
mk_pct_f() {
  python3 -c "t=$total_cost_f; c=$1; print(f'{c/t*100:.1f}' if t>0 else '0.0')" 2>/dev/null || echo "0.0"
}
mk_model_row() {
  local tier="$1" label="$2" cost="$3" pct_f="$4"
  printf '\n|           %s%-8s%s | $%6.2f | %5s%% |' \
    "$(model_color "$tier")" "$label" "$(rst)" "$cost" "$pct_f"
}
mk_model_row sonnet "Sonnet" "$sonnet_cost" "$(mk_pct_f "$sonnet_cost")"
mk_model_row haiku  "Haiku"  "$haiku_cost"  "$(mk_pct_f "$haiku_cost")"
mk_model_row opus   "Opus"   "$opus_cost"   "$(mk_pct_f "$opus_cost")"

printf '\n'
