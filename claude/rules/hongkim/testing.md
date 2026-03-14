# Testing Requirements

## 최소 테스트 커버리지: 80%

테스트 타입 (전부 필수):
1. **Unit Tests** — 개별 함수, 유틸리티, 컴포넌트
2. **Integration Tests** — API 엔드포인트, DB 연산
3. **E2E Tests** — 핵심 사용자 플로우 (언어별 프레임워크 선택)

## Test-Driven Development (MANDATORY)

1. 테스트 먼저 작성 (RED)
2. 테스트 실행 — 실패해야 함
3. 최소 구현 작성 (GREEN)
4. 테스트 실행 — 통과해야 함
5. 리팩토링 (IMPROVE)
6. 커버리지 80%+ 확인

## 테스트 실패 트러블슈팅

1. **tdd-guide** 에이전트 사용
2. 테스트 격리 확인
3. mock 정확성 검증
4. 구현 수정 (테스트가 잘못된 경우가 아니라면 테스트 수정 금지)

## 에이전트 지원

- **tdd-guide** — 새 기능 개발 시 선제적 사용, 테스트 선행 작성 강제
