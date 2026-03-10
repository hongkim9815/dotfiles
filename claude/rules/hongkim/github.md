# GitHub Workflow Rules

## Commit & Push (MANDATORY)

커밋/푸시는 반드시 `/git-commit-push` 스킬을 통해 진행한다.

- 사용자가 명시적으로 요청하기 전까지 절대 실행하지 않음
- Bash로 `git commit`, `git push`를 직접 실행하는 것도 금지
- push는 사용자의 명시적 허용 후에만 실행

---

## PR Review Workflow

"PR 확인해봐", "PR 리뷰해줘" 등의 요청 시:

1. `gh pr list` — 열린 PR 목록 조회
2. `gh pr view <number>` — 상세 내용 확인
3. `gh pr diff <number>` — diff 확인
4. `gh pr checks <number>` — CI 상태 확인
5. PR description + diff 기반으로 작업 수행
