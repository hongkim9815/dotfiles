# Agent Teams Rule

## 팀 생성 판단 기준

아래 조건 **모두** 충족 시 `TeamCreate` 사용:
- 독립적인 태스크 2개 이상 존재
- 태스크 간 공유 상태 또는 순차 의존성 없음
- 병렬 처리 시 컨텍스트 절약 또는 속도 이점이 명확함

단일 태스크는 팀 미사용. 에이전트 오버헤드가 이득보다 큼.

---

## 팀 워크플로우 (MANDATORY 순서)

1. `TeamCreate` — 팀 이름·목적 설정
2. `TaskCreate` — 각 태스크를 개별 생성 (subject, description 명확히)
3. `Agent` 스폰 — `team_name`, `name` 파라미터 필수 지정
4. `TaskUpdate` — 태스크 owner 에이전트명으로 할당
5. 에이전트 작업 완료 대기 — 자동 메시지 수신
6. `SendMessage(type: "shutdown_request")` — 각 에이전트에 종료 요청
7. `TeamDelete` — 팀 리소스 정리

---

## 에이전트 타입 선택

| 작업 유형 | 사용할 타입 |
|---|---|
| 파일 읽기, 탐색, 검색만 | `Explore` |
| 파일 쓰기/수정, Bash 실행 | `general-purpose` |
| 계획 수립 (수정 없음) | `Plan` |

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

## 적합/부적합 케이스

**적합**: README 작성 + 보안 검토 → 독립적, 병렬 가능
**부적합**: 테스트 작성 → 구현 → 리뷰 → 순차 의존성 있음, 단일 에이전트로 처리
