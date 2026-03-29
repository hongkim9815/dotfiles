---
name: git-diff
description: 현재 브랜치의 main 대비 변경사항을 요약. "변경점", "diff", "PR 내용", "이 브랜치 뭐 바꿨어", "브랜치 변경사항", "컨텍스트로 올려줘" 등의 요청 시 발동.
---

# Git Diff — 브랜치 변경사항 요약

## 발동 조건

- "변경점", "diff", "PR 내용", "이 브랜치 뭐 바꿨어", "브랜치 변경사항", "컨텍스트로 올려줘"
- 현재 브랜치가 main이 아닌 경우에만 의미 있음

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

변경 파일 통계를 보고 핵심 디렉토리를 판단하여 diff 조회.
테스트 파일, 자동 생성 파일(schema.rb 등)은 제외하거나 후순위로.

```bash
git diff ${BASE}..HEAD -- app/ lib/ config/ db/migrate/
```

파일이 너무 많으면 `--stat` 기준으로 변경량 큰 파일 위주로 선별.

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

- `origin/main`이 최신이 아닐 수 있음 → 필요 시 `git fetch origin main` 선행
- diff가 너무 크면 핵심 파일 위주로 선별하여 보여주고, 나머지는 `--stat`으로 대체
