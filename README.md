# dotfiles

> Personal dev environment for macOS and Linux. One command to set up zsh, vim, git, and Claude Code.

```sh
git clone https://github.com/hongkim9815/dotfiles ~/.dotfiles
~/.dotfiles/install.sh
```

---

## What's Inside

| File | Description |
|---|---|
| `zshrc` | Oh My Zsh, asdf, direnv, aliases (`gst`, `gps`, `gpl`, `c`) |
| `theme.zshrc` | Powerline-style prompt with Git branch/commit info |
| `gitconfig` | Editor, push strategy, LFS, submodule recursion, local include |
| `gitignore` | Global ignore patterns (Python, Vim, Gradle, IDE, etc.) |
| `vimrc` | vim-plug plugins — NERDTree, Syntastic, GitGutter, Google codefmt |
| `ideavimrc` | IdeaVim config for JetBrains IDEs |
| `DefaultKeyBinding.dict` | macOS — remap Home/End to line start/end |
| `xinitrc` | Linux — disable DPMS screen blanking |

---

## Claude Code Integration

`install_claude.sh` symlinks everything under `claude/` into `~/.claude/`.

### Rules (`claude/rules/hongkim/`)

| File | Purpose |
|---|---|
| `speech-style.md` | Response tone — concise, noun-form endings |
| `coding-style.md` | Immutability, file/function size limits |
| `writing-style.md` | AI-reader vs human-reader doc style |
| `github.md` | Commit/push only via skill, PR review flow |
| `security.md` | Pre-commit security checklist |
| `testing.md` | TDD workflow, 80%+ coverage requirement |
| `plan.md` | Plan file structure and writing style |
| `agent-teams.md` | Agent team creation and coordination |

### Skills (`claude/skills/`)

| Skill | Description |
|---|---|
| `git-commit-push` | gitmoji commit + push, explicit invocation only |

---

## Installation

**Prerequisites:** Git, Zsh (macOS includes both; Linux: `apt install git zsh`)

```sh
# Standard
~/.dotfiles/install.sh

# With private settings overlay
~/.dotfiles/install.sh private
```

`install.sh` installs packages, sets up Oh My Zsh + vim-plug, creates symlinks, and switches the default shell to zsh.

### Local Overrides

- **Git**: add machine-specific config to `~/.gitconfig.local` (auto-included)
- **Private vars**: override `PRIVATE_VARIABLE_01~04` in `~/.dotfiles_private/*.zshrc`

<details>
<summary>Linux build dependencies (pyenv, etc.)</summary>

```sh
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
  libreadline-dev libbz2-dev libsqlite3-dev wget curl llvm \
  libncurses5-dev lzma liblzma-dev libbz2-dev
```

</details>
