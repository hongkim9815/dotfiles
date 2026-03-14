# dotfiles

> **TL;DR** macOS와 Linux(Ubuntu)에서 쓰는 개인 개발 환경 설정 모음. `git clone` 후 `install.sh` 한 번이면 zsh, vim, git, Claude Code까지 세팅 완료.

## Why

새 장비를 세팅하거나 서버에 접속할 때마다 같은 설정을 반복하는 건 시간 낭비다. 이 저장소 하나로:

- **일관된 환경** --- 어디서든 동일한 쉘, 에디터, Git 설정
- **빠른 복구** --- 장비 교체 시 `install.sh` 한 번이면 끝
- **버전 관리** --- 설정 변경 이력을 Git으로 추적

---

## Repository Structure

```
.dotfiles/
├── install.sh              # 메인 설치 스크립트
├── install_claude.sh       # Claude Code 설정 설치 스크립트
│
├── zshrc                   # Zsh 설정 (alias, 함수, 환경변수)
├── theme.zshrc             # Zsh 커스텀 프롬프트 테마 (Powerline 스타일)
├── gitconfig               # Git 전역 설정
├── gitignore               # Git 전역 ignore 패턴
├── vimrc                   # Vim 설정 (플러그인, 키맵, 테마)
├── ideavimrc               # JetBrains IDE의 IdeaVim 설정
├── keymap.sh               # Linux 한/영 키매핑 (xmodmap)
├── xinitrc                 # Linux X11 초기화 설정
├── DefaultKeyBinding.dict  # macOS Home/End 키 동작 재정의
│
└── claude/                 # Claude Code 통합 설정
    ├── settings.json       #   Claude Code 전역 설정
    ├── rules/              #   사용자 규칙 (말투, 코딩 스타일, 보안 등)
    │   └── hongkim/
    └── skills/             #   커스텀 스킬
        └── git-commit-push/
```

---

## Included Configurations

### Shell (Zsh)

| 파일 | 설명 |
|---|---|
| `zshrc` | Oh My Zsh 기반 설정. alias(`gst`, `gps`, `gpl` 등), 자동완성, asdf 버전 매니저, direnv 연동 |
| `theme.zshrc` | Powerline 스타일 커스텀 프롬프트. 시간, 사용자, 디렉토리, Git 브랜치/커밋 표시 |

<details>
<summary>주요 alias 목록</summary>

| Alias | 명령어 |
|---|---|
| `gst` | `git status` |
| `gps` | `git push` |
| `gpl` | `git pull` |
| `gmo` | `gitmoji -c` |
| `g-` | `git checkout -` |
| `src` | `source ~/.zshrc` |
| `c` | `claude` |

</details>

### Git

| 파일 | 설명 |
|---|---|
| `gitconfig` | 기본 에디터(vim), push 전략(simple), LFS, 서브모듈 재귀, `~/.gitconfig.local` include |
| `gitignore` | Python, Vim, VirtualEnv, Gradle 등 전역 ignore 패턴 |

### Vim

| 파일 | 설명 |
|---|---|
| `vimrc` | vim-plug 기반 플러그인 관리. NERDTree, Syntastic, GitGutter, airline. Google 코딩 스타일 자동포맷. hybrid 컬러스킴 |
| `ideavimrc` | JetBrains IDE용 Vim 에뮬레이션. 동일한 키맵(`Tab` 윈도우 이동, 검색 중앙 정렬 등) |

### macOS / Linux

| 파일 | 대상 OS | 설명 |
|---|---|---|
| `DefaultKeyBinding.dict` | macOS | Home/End 키를 줄 시작/끝으로 동작하게 재정의 |
| `keymap.sh` | Linux | xmodmap으로 한/영, 한자 키 매핑 |
| `xinitrc` | Linux | X11 DPMS(화면 절전) 비활성화 |

---

## Claude Code Integration

이 dotfiles는 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 설정도 관리한다. `install_claude.sh`가 `claude/` 디렉토리의 설정을 `~/.claude/`에 심볼릭 링크로 설치한다.

### Rules (`claude/rules/hongkim/`)

| 규칙 파일 | 역할 |
|---|---|
| `speech-style.md` | Claude 말투 설정 (간결체, 토큰 절약) |
| `coding-style.md` | 불변성, 파일 크기 제한, 함수 50줄 이하 등 |
| `writing-style.md` | AI 독자 vs Human 독자 문서 스타일 구분 |
| `github.md` | 커밋/푸시는 반드시 스킬을 통해, PR 리뷰 워크플로우 |
| `security.md` | 보안 체크리스트, 시크릿 관리 규칙 |
| `testing.md` | TDD 워크플로우, 최소 80% 커버리지 |

### Skills (`claude/skills/`)

| 스킬 | 설명 |
|---|---|
| `git-commit-push` | gitmoji 기반 커밋 + 푸시. 사용자 명시 호출 시에만 실행 |

### Settings (`claude/settings.json`)

Claude Code 전역 설정 파일. 권한(allow/deny), 알림 훅, 상태바 등을 관리한다.

---

## Installation

### Prerequisites

| 항목 | macOS | Linux (Ubuntu) |
|---|---|---|
| Git | `brew install git` 또는 Xcode CLT | `apt install git` |
| Homebrew | [brew.sh](https://brew.sh) | 자동 설치됨 |
| Zsh | 기본 포함 | `apt install zsh` |

### Quick Start

```sh
git clone https://github.com/hongkim9815/dotfiles ~/.dotfiles
~/.dotfiles/install.sh
```

### What `install.sh` Does

1. **패키지 설치** --- vim, git, zsh, curl, asdf, gitmoji (OS별 분기)
2. **Oh My Zsh** 설치 (없는 경우)
3. **vim-plug** 설치 (없는 경우)
4. **zsh-autosuggestions** 클론
5. **심볼릭 링크 생성** --- 각 설정 파일을 `~/.<filename>`으로 링크
6. **Claude Code 설정 설치** --- `install_claude.sh` 실행
7. **Vim 플러그인 설치** --- `vim +PlugInstall`
8. **기본 쉘 변경** --- zsh로 전환

### Private Settings

별도의 private 저장소(`dotfiles_private_setting`)를 연동할 수 있다:

```sh
~/.dotfiles/install.sh private
```

이 옵션을 사용하면 `~/.dotfiles_private_setting`을 클론하고, 동일 이름의 설정 파일이 있으면 private 버전이 우선 적용된다.

---

## Customization

- **Git 로컬 설정**: `~/.gitconfig.local`에 머신별 설정 추가 (gitconfig에서 자동 include)
- **Private 변수**: `zshrc`의 `PRIVATE_VARIABLE_01~04`를 private 저장소에서 오버라이드
- **Zsh 확장**: `~/.dotfiles_private_setting/*.zshrc`가 자동 로드됨

---

## More (Linux Build Dependencies)

Ubuntu에서 pyenv 등으로 Python을 빌드할 때 필요한 패키지:

```sh
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
  libreadline-dev libbz2-dev libsqlite3-dev wget curl llvm \
  libncurses5-dev lzma liblzma-dev libbz2-dev
```
