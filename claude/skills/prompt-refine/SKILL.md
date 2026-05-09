---
name: prompt-refine
description: 기존 prompt/rule/skill 파일을 분석하여 개선안 제시. "프롬프트 개선", "rule 다듬어줘", "skill 손봐줘", "prompt 손봐줘", "prompt-refine", "이 rule 개선해줘", "이 skill 개선해줘" 등 트리거.
---

# Prompt Refine

## 발동 조건 (MANDATORY)

이 스킬은 아래 조건 중 하나에서 발동:

허용:
- 사용자가 `/prompt-refine`을 직접 입력한 경우
- 사용자가 파일 경로와 함께 "개선", "다듬어줘", "손봐줘" 등을 요청한 경우
- 사용자가 rule 또는 skill 파일의 품질 개선을 명시적으로 요청한 경우

**금지:**
- 파일 자동 수정 금지 — 개선안 제시 후 반드시 사용자 승인 대기
- 승인 없이 `Write` 또는 `Edit` 도구로 원본 파일 변경 금지
- 여러 파일을 동시에 수정하는 것 금지 — 1회 1파일

---

## Workflow

### 1. 대상 파일 확인

```
Read {파일 경로}
```

파일이 없거나 경로 미제공 시 사용자에게 경로 요청.

### 2. 4축 분석

파일 내용을 아래 4축으로 분석. 각 축에서 개선 가능한 지점을 식별:

#### 구조화 축
**근거 논문**: SSL(Scheduling/Structural/Logical 3계층), ObjectGraph(타입화된 노드), Agent Skills Survey(skill 생애주기), EvolveR(재사용 원칙 추출)

점검 항목:
- 발동 조건(Scheduling) / 내용 구조(Structural) / 인과·제약(Logical) 가 뒤섞여 있는지
- 각 섹션이 독립적으로 발췌해도 의미 통하는지 (자기완결성)
- 재사용 가능한 서브 유닛으로 분리 가능한 부분 있는지
- 불필요하게 장황한 자연어 설명 → 타입화된 표현으로 압축 가능한 곳

#### 반성 축
**근거 논문**: GEPA(reflective evolution), ReflectivePrompt(실패 원인 진단), MAR(cross-reflection), CoolPrompt(ReflectivePrompt 통합)

점검 항목:
- 모호하거나 다중 해석 가능한 지점 — LLM이 "실패"할 수 있는 곳
- negative constraint 누락 — 명시된 금지 조건이 충분한지
- 실패 사례/예외가 명시되지 않은 규칙
- 트리거 조건과 금지 조건이 비대칭인 경우 (허용은 구체적, 금지는 모호)

#### 자동화 축
**근거 논문**: CoolPrompt(zero-config 최적화), System Prompt Meta-Learning(system/task 분리), CALM(verbal+numerical 지침)

점검 항목:
- Signature 추출 가능 여부 — 입력·출력·사전조건·사후조건이 명시적인지
- System-level 지침(페르소나·톤·일반 원칙)과 Task-level 지침(구체적 동작)이 혼재하는지
- 수치나 구조적 제약(줄 수 제한, 형식 규칙)이 자연어로만 표현된 경우 → 명시적 표 또는 조건으로 전환 가능한지

#### 워크플로우 축
**근거 논문**: SAGE(단계별 role 분리), Dynamic Runtime Graphs(정적 템플릿 → ACG), Self-Evolving Memory(메모리 누적 지점)

점검 항목:
- 단계가 묵시적으로 섞여 있는지 → 명시적 Step 분리 가능 여부
- 정적으로 하드코딩된 흐름 → 조건 분기(X 상태일 때 → Y 실행) 로 동적화 가능한지
- 이전 실행 결과를 다음에 활용하는 누적 패턴이 있는지 (메모리 지점)

### 3. 개선안 출력

분석 결과를 아래 형식으로 출력:

```
## 분석 결과: {파일명}

### 개선 우선순위

| 우선순위 | 지점 | 축 | 근거 논문 | 제안 요약 |
|---|---|---|---|---|
| 1 | ... | 구조화 | SSL | ... |
| 2 | ... | 반성 | GEPA | ... |
...

### 개선안 (diff 형식)

**[변경 1] {제목}**
```
- (원본)
+ (개선안)
```
근거: {논문명} — {인사이트 한 줄}

**[변경 2] ...**
...

### 토큰 절감 추정
ObjectGraph 관점: 구조화 전환 시 {추정 절감 방향}

### 다음 검토 권장 파일
EvolveR 관점: {재사용 시너지 관점에서 함께 다듬을 후보 파일}
```

### 4. 승인 대기

개선안 출력 후 **반드시 사용자 승인을 대기**할 것.

"어떤 변경을 적용할까?" 또는 "전체 적용 / 일부 선택?" 으로 확인.

사용자가 "전체 적용" 또는 특정 변경 번호를 선택하면 해당 변경만 `Edit` 도구로 반영.

---

## 사용 예시

```
# 단일 파일 개선
prompt-refine ~/.dotfiles/claude/rules/hongkim/plan-style.md

# 한국어 트리거
이 rule 개선해줘: ~/.dotfiles/claude/rules/hongkim/principles.md

# skill 손보기
~/.dotfiles/claude/skills/git-commit-push/SKILL.md 다듬어줘
```

---

## 주의사항

- 개선안은 제안일 뿐 — 원본 파일은 사용자 승인 전까지 변경 금지
- 기존 컨벤션(한국어 본문, 명사형 어미, MANDATORY 패턴) 준수
- 논문 인사이트를 억지로 적용하지 말 것 — 개선이 명확한 지점에만 적용
- 개선 후 "다른 파일도 검토할까?"로 자연스럽게 연결 가능

<!-- 참고 논문 풀 (13편)
SSL (2604.24026) / GEPA (2507.19457) / CoolPrompt (ICLR 2026) / ReflectivePrompt (2508.18870)
System Prompt Meta-Learning (2505.09666) / SAGE (2026-03) / MAR (2512.20845) / CALM (ICLR 2026)
EvolveR (OpenReview:sooLoD9VSf) / Agent Skills Survey (2602.12430) / ObjectGraph (2604.27820)
Self-Evolving Memory (2604.11610) / Dynamic Runtime Graphs (2603.22386)
-->
