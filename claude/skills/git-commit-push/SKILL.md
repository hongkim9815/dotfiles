---
name: git-commit-push
description: Use ONLY when the user explicitly invokes /git-commit-push or directly asks to commit and push. NEVER run this automatically after completing code changes.
---

# Git Commit & Push

## 발동 조건 (MANDATORY)

이 스킬은 **반드시 사용자가 명시적으로 호출한 경우에만** 실행한다.

허용되는 발동:
- 사용자가 `/git-commit-push`를 직접 입력한 경우
- 사용자가 "커밋해줘", "푸시해줘", "commit & push 해줘" 등 명시적으로 요청한 경우

**금지되는 발동:**
- 코드 작업 완료 후 자동으로 실행하는 것
- 이전 세션에서 이 스킬을 사용했다는 이유로 관례적으로 이어서 실행하는 것
- "작업이 끝났으니 커밋도 해야겠다"는 Claude의 판단으로 실행하는 것

> 사용자가 명시적으로 요청하기 전까지는 코드 변경 + 검증 결과 보고까지만 수행하고 대기한다.

## CRITICAL: Bash 직접 실행도 금지

이 스킬을 통하지 않고 **Bash 도구로 `git commit`, `git push`를 직접 실행하는 것도 동일하게 금지**됨.

코드 작업 후 커밋/푸시는 반드시:
1. 사용자가 명시적으로 요청할 때까지 대기
2. 요청 시 이 스킬의 Workflow를 따라 진행

위반 패턴 예시 (절대 하지 말 것):
```bash
# 코드 수정 직후 자동으로 실행 — 금지
git add . && git commit -m "..." && git push
```

## Overview

`git add` → `git status` 확인 → emoji 커밋 → `git push` 순서의 전체 워크플로.
커밋 메시지는 `"<emoji> <message>"` 형식을 사용한다. emoji는 반드시 유니코드(`✨`)로 작성하고, shortcode(`:sparkles:`)는 사용하지 않는다.

## Workflow

```bash
# 1. 전체 스테이징
git add .

# 2. 커밋 대상 확인 (반드시 확인)
git status

# 3. 커밋
git commit -m "<emoji> <message>" -m "<description>"
# <emoji>      : 유니코드 emoji (아래 Quick Reference 참조)
# <message>    : 한 줄 요약, 영어 imperative
# <description>: 변경 내용 요약 (선택)

# 4. 푸시
git push
```

> **GPG 서명**: GPG가 설정된 저장소에서는 서명 팝업이 뜰 수 있다. 사용자 action을 기다린다. `--no-gpg-sign` 등으로 우회하지 않는다.

### upstream 미설정 에러 처리

```
fatal: The current branch <branch_name> has no upstream branch.
```

```bash
git push --set-upstream origin <branch_name>
```

## Quick Reference: Emoji 선택

| 상황 | Emoji |
|------|-------|
| 새 기능 | ✨ |
| 버그 수정 | 🐛 |
| 긴급 핫픽스 | 🚑️ |
| 리팩토링 | ♻️ |
| 테스트 | ✅ |
| 문서 | 📝 |
| 설정 파일 | 🔧 |
| 빌드/스크립트 | 🔨 |
| 성능 개선 | ⚡️ |
| 보안 수정 | 🔒️ |
| 코드·파일 삭제 | 🔥 |
| 아키텍처 변경 | 🏗️ |
| 의존성 추가/제거 | ➕ / ➖ |
| 의존성 업그레이드 | ⬆️ |
| 타입 추가/변경 | 🏷️ |
| 브랜치 병합 | 🔀 |
| 배포 | 🚀 |
| 프로젝트 시작 | 🎉 |
| WIP | 🚧 |
| 린터/컴파일 경고 수정 | 🚨 |
| 코드 구조/포맷 개선 | 🎨 |
| 로그 추가 | 🔊 |
| 로그 제거 | 🔇 |
| 데드코드 제거 | ⚰️ |
| 비즈니스 로직 | 👔 |

적절한 것이 없다면 `gitmoji --list` 실행하여 참조. 그래도 없으면 `✨`로 통일.
