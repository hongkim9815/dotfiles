#!/usr/bin/env bash
# install_claude.sh
# Claude Code 사용자 설정을 ~/.claude/ 에 심볼릭 링크로 설치한다.
#
# dotfiles 구조:
#   dotfiles/
#     claude/
#       skills/       → ~/.claude/skills/{name} 각각 symlink
#       rules/        → ~/.claude/rules/{name}  각각 symlink
#       agents/       → ~/.claude/agents/{name} 각각 symlink
#       settings.json → ~/.claude/settings.json symlink
#       CLAUDE.md     → ~/.claude/CLAUDE.md     symlink
#     install_claude.sh

set -euo pipefail

# ─── 색상 ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

log_info()    { echo -e "${CYAN}  →${RESET} $*"; }
log_ok()      { echo -e "${GREEN}  ✓${RESET} $*"; }
log_skip()    { echo -e "${YELLOW}  -${RESET} $* (skipped)"; }
log_section() { echo -e "\n${CYAN}[$*]${RESET}"; }

# ─── 경로 설정 ────────────────────────────────────────────────────────────────
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_SRC="${DOTFILES_DIR}/claude"
CLAUDE_DIR="${HOME}/.claude"

if [[ ! -d "${CLAUDE_SRC}" ]]; then
  echo -e "${RED}오류:${RESET} ${CLAUDE_SRC} 디렉토리가 없음."
  exit 1
fi

mkdir -p "${CLAUDE_DIR}"

# ─── 파일 심볼릭 링크 헬퍼 ───────────────────────────────────────────────────
# 단일 파일을 symlink로 설치. 기존 파일이 있으면 .bak으로 백업.
link_file() {
  local src="$1" dst="$2" label="$3"

  if [[ ! -f "${src}" ]]; then
    log_skip "${label}"
    return
  fi

  mkdir -p "$(dirname "${dst}")"
  if [[ -L "${dst}" ]]; then
    rm "${dst}"
  elif [[ -f "${dst}" ]]; then
    mv "${dst}" "${dst}.bak"
    log_info "${label}: 기존 파일 백업 → ${dst}.bak"
  fi
  ln -s "${src}" "${dst}"
  log_ok "${label} → ${src}"
}

# ─── 디렉토리 항목 심볼릭 링크 헬퍼 ─────────────────────────────────────────
# src_dir 하위의 각 서브디렉토리를 dst_dir/{name} 으로 symlink.
# 로컬에만 있는 항목은 그대로 유지됨.
link_dir_entries() {
  local src_dir="$1" dst_dir="$2" label="$3"

  if [[ ! -d "${src_dir}" ]]; then
    log_skip "${label}"
    return
  fi

  local count=0
  mkdir -p "${dst_dir}"

  for entry in "${src_dir}"/*/; do
    [[ -d "${entry}" ]] || continue
    local name dst_entry
    name="$(basename "${entry}")"
    dst_entry="${dst_dir}/${name}"

    if [[ -L "${dst_entry}" ]]; then
      rm "${dst_entry}"
    elif [[ -d "${dst_entry}" ]]; then
      mv "${dst_entry}" "${dst_entry}.bak"
      log_info "${label}/${name}: 기존 디렉토리 백업 → ${dst_entry}.bak"
    fi
    ln -s "${entry%/}" "${dst_entry}"
    log_info "${label}/${name}"
    ((count++)) || true
  done

  if [[ ${count} -eq 0 ]]; then
    log_skip "${label} (항목 없음)"
  else
    log_ok "${label}: ${count}개 링크"
  fi
}

# ─── 설치 ────────────────────────────────────────────────────────────────────
echo -e "${CYAN}Claude Code dotfiles 설치 시작${RESET}"
echo "  소스: ${CLAUDE_SRC}"
echo "  대상: ${CLAUDE_DIR}"

log_section "skills"
link_dir_entries \
  "${CLAUDE_SRC}/skills" \
  "${CLAUDE_DIR}/skills" \
  "skills"

log_section "rules"
link_dir_entries \
  "${CLAUDE_SRC}/rules" \
  "${CLAUDE_DIR}/rules" \
  "rules"

log_section "agents"
link_dir_entries \
  "${CLAUDE_SRC}/agents" \
  "${CLAUDE_DIR}/agents" \
  "agents"

log_section "설정 파일"
link_file \
  "${CLAUDE_SRC}/settings.json" \
  "${CLAUDE_DIR}/settings.json" \
  "settings.json"

link_file \
  "${CLAUDE_SRC}/CLAUDE.md" \
  "${CLAUDE_DIR}/CLAUDE.md" \
  "CLAUDE.md (전역 지침)"

link_file \
  "${CLAUDE_SRC}/notification-hook.sh" \
  "${CLAUDE_DIR}/notification-hook.sh" \
  "notification-hook.sh (알림 훅)"

echo -e "\n${GREEN}완료.${RESET} ${CLAUDE_DIR} 에 설치됐습니다."
