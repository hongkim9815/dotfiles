# Plan Writing Rule

## 목적

Claude가 읽고 실행하기 좋은 plan 파일 작성 원칙을 정의함.
plan은 AI 독자용 문서임 — Human 독자용 원칙 적용 금지.

---

## Plan 모드 워크플로우 (MANDATORY)

**1단계 — 탐색·수집**:
- 코드베이스 탐색, 질문, 맥락 수집 자유롭게 진행
- 추가 확인 필요 사항은 `AskUserQuestion` 으로 질의
- plan 파일 작성 금지 (이 단계에서)

**2단계 — 초안 저장** (맥락 수집 완료 판단 시):
1. plan 파일을 `./.claude/plan/` 에 저장 (`Write` 도구 사용, 저장 위치 섹션 참조)
2. 저장된 plan 전체 내용을 사용자에게 텍스트로 표시
3. 사용자의 트리거 신호 대기 (`ExitPlanMode` 호출 금지)

**3단계 — 승인** (트리거 수신 시):
- `ExitPlanMode` 호출

트리거 신호 예시:
- "report ㄱㄱ?", "report 만들어줘", "report 줘"
- "plan 완성해줘", "이제 plan 써줘", "정리해줘"
- "ㄱㄱ", "가자", "go"

**예외**: 사용자가 "plan 짜줘", "계획 세워줘" 등으로 처음부터 명시적 plan 작성을 요청한 경우
→ 2단계(파일 저장 + 표시) 수행 후 트리거 대기 없이 바로 `ExitPlanMode` 호출

---

## 저장 위치 (MANDATORY)

plan 파일은 반드시 **현재 작업 중인 repository의 `.claude/plan/`** 에 저장.

- 저장 경로 패턴: `./.claude/plan/**`
- 파일명 형식: `./.claude/plan/{ISSUE-ID}-{kebab-case-title}.md`
- ISSUE-ID 없는 경우: `./.claude/plan/{kebab-case-title}.md`
- 예시: `./.claude/plan/PROJ-123-test-db-migration.md`
- `.`은 현재 작업 디렉토리 기준 — 절대경로·전역경로 사용 금지
- `~/.claude/plans/` 또는 다른 전역 경로에 저장 금지

---

## 필수 섹션 구조

```
# Plan: [작업 제목]

## Context
## Tasks
## Critical Files
## Verification
```

각 섹션은 단독 발췌해도 의미가 통해야 함.

---

## Context 섹션

- 이 변경이 왜 필요한지 — 문제·요구사항 기술
- 무엇을 해결하는지 — 의도된 결과 명시
- 배경 정보 — 관련 파일, 기존 패턴, 제약 조건

## Tasks 섹션

- 실행 단계를 번호 순서로 나열
- 각 단계: 동사 시작 (`생성`, `수정`, `삭제`, `실행`)
- 조건 선행 명시: `X 상태일 때 → Y 실행`
- 병렬 실행 가능 단계는 명시: `(병렬 가능)`

## Critical Files 섹션

수정·생성·삭제 파일을 표로 정리:

| 파일 경로 | 작업 | 재사용할 기존 함수/패턴 |
|---|---|---|
| `path/to/file.ts` | 수정 | `existingUtil()` at line 42 |

## Verification 섹션

- 변경 후 검증 방법 (실행 명령, MCP 도구, 테스트)
- 성공 기준 명시 (기대 출력, 상태 코드, 커버리지)

---

## 작성 원칙

`writing-style.md` AI 독자용 원칙을 따름.

## 금지 사항

- 대안 여러 개 나열 금지 — 권장 접근법 하나만 작성
- 불필요한 배경 설명 금지 — 실행에 필요한 정보만 포함
- 추측성 내용 금지 — 확인된 정보만 기술
- 높임말 어미 금지 (`~합니다`, `~주세요`)
