---
name: git-diff
description: 현재 브랜치의 main 대비 변경사항을 요약. "변경점", "diff", "PR 내용", "이 브랜치 뭐 바꿨어", "브랜치 변경사항", "컨텍스트로 올려줘" 등의 요청 시 발동.
---

# Git Diff — 브랜치 변경사항 요약

## 발동 조건

- "변경점", "diff", "PR 내용", "이 브랜치 뭐 바꿨어", "브랜치 변경사항", "컨텍스트로 올려줘"

**사전조건:**
- git repo 존재
- 현재 브랜치가 main이 아닌 경우에만 실행
  - main 브랜치에서 요청 시 → "현재 main 브랜치임. 비교 대상 브랜치를 지정해줘" 보고 후 종료
- `origin/main` 존재 확인 — 없으면 `git fetch origin main` 후 재시도

## Workflow

### 1. base commit 산출

```bash
git merge-base origin/main HEAD
```

결과를 `BASE`로 저장.

### 2. 커밋 목록 조회

```bash
git log ${BASE}..HEAD --oneline
```

### 3. 변경 파일 통계

```bash
git diff ${BASE}..HEAD --stat
```

### 4. 실제 diff 조회

변경 파일 통계 기준으로 아래 우선순위로 diff 조회:

| 우선순위 | 대상 | 이유 |
|---|---|---|
| 1순위 | 비즈니스 로직 (`app/`, `lib/`, `src/`) | 핵심 변경 |
| 2순위 | 설정·마이그레이션 (`config/`, `db/migrate/`) | 구조 변경 |
| 제외 | 테스트 파일, 자동 생성 파일 (`schema.rb`, `*.lock`) | 노이즈 |

```bash
git diff ${BASE}..HEAD -- app/ lib/ config/ db/migrate/
```

### 5. 요약 제공

아래 형식으로 출력:

```
## 브랜치 요약: <branch_name> (main 대비)

### 커밋 목록
- <hash> <message>
- ...

### 변경 파일 통계
<--stat 결과>

### 주요 변경사항
- <기능/모듈별 변경 요약>
- ...
```

## 주의사항

- `origin/main` 최신화: 마지막 fetch가 세션 내에서 없었던 경우 → `git fetch origin main` 선행
- diff가 변경 파일 20개 초과 시 → `--stat` 결과만 제공 후 "특정 파일/디렉토리 상세 조회 원하면 말해줘" 안내
