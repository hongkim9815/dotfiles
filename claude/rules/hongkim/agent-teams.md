# Agent Teams Rule

## 팀 생성 판단 기준

아래 조건 **모두** 충족 시 `TeamCreate` 사용:

| # | 조건 |
|---|---|
| 1 | 독립적인 태스크 2개 이상 존재 |
| 2 | 태스크 간 공유 상태 또는 순차 의존성 없음 |
| 3 | 아래 정량 기준 중 **2개 이상 충족** |

**정량 기준 (3개 중 2개 이상)**:
- 각 태스크가 서로 겹치지 않는 파일 집합 대상 (read/write 충돌 없음)
- 태스크당 예상 tool call 5회 이상
- 컨텍스트 예상 소비 >20K 토큰

위 기준 미충족 시 단일 에이전트로 처리.

단일 태스크는 팀 미사용. 에이전트 오버헤드가 이득보다 큼.

**예시**:
- 적합: README 작성 + 보안 검토 (독립, 병렬 가능)
- 부적합: 테스트 작성 → 구현 → 리뷰 (순차 의존성)

---

## 팀 워크플로우 (MANDATORY 순서)

1. `TeamCreate` — 팀 이름·목적 설정
2. `TaskCreate` — 각 태스크를 개별 생성 (subject, description 명확히)
3. `Agent` 스폰 — `team_name`, `name` 파라미터 필수 지정
4. `TaskUpdate` — 태스크 owner 에이전트명으로 할당
5. 에이전트 작업 완료 대기 — 자동 메시지 수신
   - **Gate**: 모든 owner 에이전트로부터 완료 메시지 수신
   - 미응답 5분 경과 시: `TaskList` 상태 확인 → 블록된 에이전트에 `SendMessage` 상태 질의
   - 재질의 후 응답 없으면 → 사용자 보고 후 결정 대기
6. 결과 검증 — 각 에이전트 결과가 태스크 description 기준 충족하는지 확인
   - **Gate**: 모든 태스크 description의 acceptance 조건 충족
   - 미충족 시: 재작업 횟수 카운트 (최대 2회) → 5단계로 복귀
   - 2회 초과 시: 사용자 보고
7. `SendMessage(type: "shutdown_request")` — 각 에이전트에 종료 요청
   - **Gate**: 모든 에이전트 approve 수신
   - approve 거부 시: `TaskList` 확인 후 미완료 태스크 처리 후 재요청 (최대 2회)
8. `TeamDelete` — 팀 리소스 정리

---

## 에이전트 타입 선택

| 작업 유형 | 사용할 타입 |
|---|---|
| 파일 읽기, 탐색, 검색만 | `Explore` |
| 파일 쓰기/수정, Bash 실행 | `general-purpose` |
| 계획 수립 (수정 없음) | `Plan` |
| 읽기+쓰기 혼재 (쓰기 1회 이상 예상) | `general-purpose` |
| 불확실한 경우 | `general-purpose` |

---

## 커뮤니케이션 규칙

- 팀원 → 팀 리더: `SendMessage(type: "message")` 사용
- 텍스트 출력만으로 팀 리더에게 전달되지 않음 — 반드시 SendMessage 사용
- 구조화된 JSON 상태 메시지 금지 (`{"type":"idle"}` 등) — 평문 메시지 사용
- 팀원 참조 시 name 사용 — agentId 사용 금지

---

## 태스크 관리

- 태스크 완료 시 `TaskUpdate(status: "completed")` 호출 후 `TaskList` 조회
- 태스크는 ID 순서로 처리 (낮은 ID 우선)

---

## 종료 프로토콜

```
SendMessage(type: "shutdown_request", recipient: "에이전트명")
→ 에이전트 approve 시 자동 종료
→ 모든 에이전트 종료 확인 후 TeamDelete 호출
```

---

## 실패 처리

| 실패 유형 | 대응 |
|---|---|
| 에이전트 무응답 (5분+) | `TaskList` 확인 → `SendMessage` 질의 → 2회 후 사용자 보고 |
| 결과가 태스크 기준 미충족 | 재작업 요청 (최대 2회) → 초과 시 사용자 보고 |
| shutdown approve 거부 | 미완료 태스크 처리 후 재요청 (최대 2회) |
| `TeamDelete` 실패 | 에러 로그 출력 후 사용자 보고 |
