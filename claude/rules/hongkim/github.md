# GitHub Workflow Rules

모든 섹션은 `Trigger → Workflow → 금지 → 재실행 조건` 4단 구조를 따름.

---

## Commit & Push

**Trigger**: 사용자가 `/git-commit-push` 호출 또는 "커밋해줘"·"push해줘" 명시적 요청.

**Workflow**:
1. `/git-commit-push` 스킬 1회 실행
2. 결과 보고 → 대기

**금지**:
- 사용자 요청 없는 자발적 실행
- Bash로 `git commit`·`git push` 직접 실행
- `git commit`·`git push`를 `&&`로 다른 명령과 체이닝
- 1회 실행 후 자동 재시도 (테스트 실패·에러·hook 실패 어떤 이유든)

**재실행 조건**: 사용자가 명시적으로 재요청한 경우만.

---

## Main 브랜치 참조

**Trigger**: "rebase on main", "branch from main", "merge main" 등 `main` 참조 요청.

**Workflow**:
1. `git fetch origin` 실행 (사전조건)
2. `origin/main` 기준으로 명령 실행

**금지**: 로컬 `main` 직접 참조.

**재실행 조건**: 사용자 요청 시.

---

## PR 생성

**Trigger**: 사용자가 "PR 생성", "PR 올려줘", "draft PR 만들어줘" 등 명시적 요청.

**Workflow**:
1. `git status` + `git rev-parse @{u}` → push 상태 확인
2. 분기:
   - 미푸시 → "아직 push 안 됨. push 먼저 할까?" → 응답 대기 → push 후 3단계
   - 푸시 완료 → 3단계
3. `gh pr create --draft` 호출 (Draft 필수)
4. PR body는 아래 템플릿 (10줄 이내) 사용
5. PR URL 출력

**PR body 템플릿**:

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

**금지**:
- `--draft` 생략
- 템플릿 10줄 초과
- 사용자 미확인 상태에서 force push

**재실행 조건**: 사용자가 PR 재생성 또는 수정 요청 시.

---

## PR Review

**Trigger**: "PR 확인해봐", "PR 리뷰해줘", "PR <번호> 봐줘" 등 요청.

**Workflow**:
1. `gh pr list` — 열린 PR 목록 조회
2. `gh pr view <number>` — 상세 내용 확인
3. `gh pr diff <number>` — diff 확인
4. `gh pr checks <number>` — CI 상태 확인
5. 아래 형식으로 리뷰 요약 출력:
   - 변경 목적 (PR description 기반)
   - 주요 변경사항 (diff 기반, 파일별 핵심 요약)
   - CI 상태 (통과/실패/진행 중)
   - 검토 의견 또는 추가 확인 필요 사항
6. **Self-check**: 위 4개 항목이 모두 채워졌는지 확인. 비어있으면 해당 명령 재실행.

**금지**:
- 4개 항목 중 1개라도 비운 채 보고
- 임의 머지·승인·코멘트 작성

**재실행 조건**: Self-check 실패 시 자동 재실행. 또는 사용자가 다른 PR 요청 시.
