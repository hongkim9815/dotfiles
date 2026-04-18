# GitHub Workflow Rules

## Commit & Push

커밋/푸시는 반드시 `/git-commit-push` 스킬을 통해 진행.

- 사용자가 명시적으로 요청하기 전까지 절대 실행 금지
- Bash로 `git commit`, `git push`를 직접 실행하는 것도 금지
- `/git-commit-push` 스킬 또는 "push해줘" 등의 명시적 요청은 **단 한 번만 실행**
  - 테스트 실패 후 재시도, 에러 수정 후 재실행 등 어떤 이유로도 자동 재실행 금지
  - 실행 후 결과(성공/실패)만 보고하고 대기

## && 체이닝 절대 금지

아래 명령은 어떤 상황에서도 `&&`로 체이닝 금지:

- `git commit`
- `git push`

**금지 예시:**
```bash
# 금지
git add . && git commit -m "..." && git push
git commit -m "..." && git push

# 허용 (사용자 승인 후 단독 실행)
git commit -m "..."
git push
```

사용자의 명시적 action(승인) 없이 commit/push를 자동 체이닝하는 것은 어떤 이유로도 금지.

---

## Main 브랜치

"main" 사용 요청 시 (예: rebase on main, create branch on main 등):

1. 항상 `git fetch origin` 먼저 실행
2. `origin/main` 기준으로 rebase — 로컬 `main` 사용 금지

---

## PR Review Workflow

"PR 확인해봐", "PR 리뷰해줘" 등의 요청 시:

1. `gh pr list` — 열린 PR 목록 조회
2. `gh pr view <number>` — 상세 내용 확인
3. `gh pr diff <number>` — diff 확인
4. `gh pr checks <number>` — CI 상태 확인
5. PR description + diff 기반으로 작업 수행
