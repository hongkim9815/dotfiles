# GitHub Workflow Rules

## Commit & Push

커밋/푸시는 반드시 `/git-commit-push` 스킬을 통해 진행.

- 사용자가 명시적으로 요청하기 전까지 절대 실행 금지
- Bash로 `git commit`, `git push`를 직접 실행하는 것도 금지
- `git commit`, `git push`는 어떤 상황에서도 `&&`로 체이닝 금지 — 반드시 단독 실행
- `/git-commit-push` 스킬 또는 "push해줘" 등의 명시적 요청은 **단 한 번만 실행**
  - 테스트 실패 후 재시도, 에러 수정 후 재실행 등 어떤 이유로도 자동 재실행 금지
  - 실행 후 결과(성공/실패)만 보고하고 대기

---

## Main 브랜치

"main" 사용 요청 시 (예: rebase on main, create branch on main 등):

1. 항상 `git fetch origin` 먼저 실행
2. `origin/main` 기준으로 rebase — 로컬 `main` 사용 금지

---

## PR 생성 규칙

PR 생성 요청 시:
- 현재 브랜치가 origin에 push되지 않은 경우 → "아직 push 안 됨. push 먼저 할까?" 확인 후 진행
- push 완료 상태 확인 후:

1. **반드시 Draft PR로 생성** — `gh pr create --draft` 사용
2. **PR body에 커밋 요약 보고서 포함** — 10줄 이내, 아래 형식 준수:

```
## 변경 요약

- [변경 유형] 핵심 변경 내용 1
- [변경 유형] 핵심 변경 내용 2
...

## 영향 범위
- 영향받는 파일/모듈 목록

## 검증
- 수행한 테스트/검증 항목
```

변경 유형: `feat` / `fix` / `refactor` / `chore` / `docs` / `test`

---

## PR Review Workflow

"PR 확인해봐", "PR 리뷰해줘" 등의 요청 시:

1. `gh pr list` — 열린 PR 목록 조회
2. `gh pr view <number>` — 상세 내용 확인
3. `gh pr diff <number>` — diff 확인
4. `gh pr checks <number>` — CI 상태 확인
5. 아래 형식으로 리뷰 요약 출력:
   - 변경 목적 (PR description 기반)
   - 주요 변경사항 (diff 기반, 파일별 핵심 요약)
   - CI 상태 (통과/실패/진행 중)
   - 검토 의견 또는 추가 확인 필요 사항
