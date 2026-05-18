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

우선순위 분류 (프로젝트 구조 탐지 후 적용):

| 우선순위 | 패턴 | 적용 조건 |
|---|---|---|
| 1순위 | 비즈니스 로직 | `src/`, `app/`, `lib/`, `pkg/`, `internal/` 중 존재하는 것 |
| 2순위 | 설정·마이그레이션 | `config/`, `db/migrate/`, `migrations/`, `*.config.{ts,js}` |
| 제외 | 자동 생성·테스트 | `*.lock`, `*.generated.*`, `schema.{rb,sql}`, `**/__tests__/**`, `*_test.go`, `*.test.{ts,js}` |

프로젝트 구조 미감지 시 → 전체 diff 제공 (fallback).

```bash
# 존재하는 디렉토리만 선택하여 실행
git diff ${BASE}..HEAD -- {탐지된 1순위 경로} {탐지된 2순위 경로}
```

### 4.5. 출력 모드 결정

| 변경 파일 수 | 모드 | 출력 |
|---|---|---|
| 1~5 | full | 커밋 + stat + diff 전체 |
| 6~20 | summary | 커밋 + stat + 1순위 경로 diff만 |
| 21+ | stat-only | 커밋 + stat + "특정 파일/디렉토리 상세 조회 원하면 말해줘" |

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
아래 항목 우선 추출:
- 신규 public 함수/클래스 (signature 포함)
- 기존 함수 signature 변경 (before → after)
- 삭제된 public 인터페이스
- 의존성 추가/제거
모듈별로 묶어서 3~5줄 요약. 내부 리팩토링은 "내부 정리"로 1줄 처리.
```

## 주의사항

- `origin/main` 최신화 검증:
  1. `git log -1 --format=%cr origin/main` 으로 마지막 fetch 시점 확인
  2. 출력이 "5 minutes ago" 이내 → fetch 생략
  3. 그 외 → `git fetch origin main` 선행 후 재실행
- diff가 변경 파일 20개 초과 시 → `--stat` 결과만 제공 후 "특정 파일/디렉토리 상세 조회 원하면 말해줘" 안내
