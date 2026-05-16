# Security Guidelines

## 커밋 전 보안 체크리스트

모든 커밋 전 아래 항목 확인:
- [ ] 하드코딩된 시크릿 없음 (API key, password, token)
- [ ] 모든 사용자 입력 검증됨
- [ ] SQL injection 방지 (parameterized query 사용)
- [ ] XSS 방지 (HTML sanitize 적용) — 웹 앱
- [ ] CSRF protection 활성화됨 — 웹 앱
- [ ] 인증/인가 검증됨
- [ ] 모든 엔드포인트에 rate limiting 적용됨 — 웹 앱
- [ ] 에러 메시지에 민감 정보 노출 없음

## 시크릿 관리

- 소스 코드에 시크릿 하드코딩 금지
- 환경 변수 또는 secret manager 사용
- 앱 시작 시 필수 시크릿 존재 여부 검증
- 노출 가능성 있는 시크릿은 즉시 로테이션

## 보안 이슈 심각도 분류

| 심각도 | 기준 | 대응 |
|---|---|---|
| CRITICAL | 시크릿 노출, 인증 우회, RCE 가능 | 즉시 작업 중단 → 프로토콜 실행 |
| HIGH | SQL injection, XSS, CSRF 취약점 | 현재 작업 완료 후 즉시 수정 |
| LOW | 에러 메시지 노출, 불필요한 권한 | 다음 커밋 전까지 수정 |

## 보안 이슈 대응 프로토콜

보안 이슈 발견 시:
1. 즉시 작업 중단
2. 심각도 분류 (위 표 기준)
3. CRITICAL/HIGH → `security-review` 스킬 사용
4. 노출된 시크릿 즉시 로테이션 (git history 포함 확인)
5. 전체 코드베이스에서 유사 패턴 grep으로 확인
6. 수정 후 커밋 전 체크리스트 재검증
