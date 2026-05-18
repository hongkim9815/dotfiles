---
name: git-commit-push
description: Use ONLY when the user explicitly invokes /git-commit-push or directly asks to commit and push. NEVER run this automatically after completing code changes.
---

# Git Commit & Push

## 발동 조건 (MANDATORY)

이 스킬은 **반드시 사용자가 명시적으로 호출한 경우에만** 실행할 것.

허용되는 발동:
- 사용자가 `/git-commit-push`를 직접 입력한 경우
- 사용자가 "커밋해줘", "푸시해줘", "커밋하자" 등 명시적으로 요청한 경우

모호 트리거 — 사용자에게 의도 확인 후 진행:

| 발화 | 확인 프롬프트 |
|---|---|
| "저장해줘" | "파일 저장만? 또는 git 커밋까지?" |
| "반영해줘" | "로컬 적용만? 또는 원격 푸시까지?" |
| "올려줘" | "git 푸시 진행할까?" |

사용자 응답이 커밋/푸시 의도를 명확히 하기 전까지 git 명령 실행 금지.

**금지되는 발동:**
- 코드 작업 완료 후 자동으로 실행하지 말 것
- Claude의 판단으로 "작업이 끝났으니 커밋도 해야겠다"며 실행하지 말 것
- Bash 도구로 `git commit`, `git push`를 직접 실행하지 말 것

## Workflow

### Step 0 — 사전조건 (static, 1회만 실행)
- git repo 존재 확인
- 변경사항 없음 → "커밋할 변경사항 없음" 보고 후 종료
- 이후 별도 instruction 없이 재실행 금지

Claude Code가 변경한 내역이 아니더라도 사용자가 수정하거나 추가한 모든 변경 사항을 포함하여 진행할 것.

### Step 1 — 스테이징 (static)

```bash
git add .
git status
```

### Step 2 — Security Gate (dynamic)

| 패턴 | 처리 |
|---|---|
| `.env`, `*secret*`, `*credential*`, `*password*` | 사용자 경고 후 unstage 여부 확인 |
| 50MB 초과 단일 파일 | 사용자 경고 후 LFS·exclude 여부 확인 |
| binary blob 신규 (`*.bin`, `*.exe`, `*.so`) | 사용자에게 의도 확인 |

### Step 3 — 승인 대기 (dynamic)

커밋 파일 목록과 메시지 초안을 보여주고 **사용자 승인을 대기할 것**.
- 승인 거부("이 파일 빼줘" 등) 시: 해당 파일 `git restore --staged <file>` 후 목록 재확인

### Step 4 — 커밋 (static)

```bash
git commit -m "<emoji> <message>" -m "<description>"
```

- pre-commit hook 실패 시: 실패 원인 보고 → 수정 후 재커밋 (`--no-verify` 우회 금지)

### Step 5 — 푸시 (dynamic)

```bash
git push
```

- push reject 시: 원인 확인 (upstream 미설정 / 원격 충돌) → 원인별 처리 후 재시도
- 원격 충돌 시: 강제 push 금지 — 사용자에게 상황 보고 후 판단 위임

> **GPG 서명**: 서명 팝업이 뜰 수 있음. 사용자 action을 기다릴 것. `--no-gpg-sign`으로 우회 금지.

### upstream 미설정 시

```bash
git push --set-upstream origin <branch_name>
```

### 푸시 후 PR 링크

`git push` 출력에 아래와 같은 PR 생성 URL이 포함된 경우 사용자에게 공유:

```
remote: Create a pull request for '...' on GitHub by visiting:
remote:      https://github.com/.../pull/new/<branch>
```

출력에서 URL을 추출하여 응답에 포함. 없으면 생략.

## Commit Message 형식

```
<emoji> <message>

<description>
```

- `<emoji>`: 유니코드 emoji (`✨`), shortcode(`:sparkles:`) 금지
- `<message>`: 영어 imperative, **50자 이내**, 한 줄 요약
- `<description>`: 변경 내용 한국어 요약, **불릿 포인트 3줄 이내**. 장황한 설명 금지. 없으면 생략 가능.

### 참조 자료

- 좋은/나쁜 예시 + 위반 진단표: [`examples.md`](./examples.md)
- Emoji 빠른 참조표: [`emoji-reference.md`](./emoji-reference.md)
