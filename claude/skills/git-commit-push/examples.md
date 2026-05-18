# Commit Message Examples

## Bad Example

```
🔧 Update zshrc configuration and gitconfig settings to deprecate old aliases and add main as default branch

- zshrc에서 더 이상 사용하지 않는 Python 관련 로컬 설정들을 정리하고,
  pyenv 초기화 로직이 중복 실행되던 문제를 수정함. 또한 direnv 관련
  설정도 함께 추가하여 프로젝트별 환경 변수 자동 로드가 가능하도록 함.
- gitconfig에서 기존 master를 default branch로 사용하던 설정을 main으로
  변경하고, 관련 alias들도 함께 업데이트함.
```

## Good Example

```
🎨 Deprecate old configs, set main as default branch

- zshrc: Python 로컬 설정 제거, direnv 추가
- gitconfig: default branch master → main 변경
```

## 위반 진단표

| 항목 | 제한 | 위반 예 | 준수 예 |
|---|---|---|---|
| message 글자수 | 50자 이내 | 91자 | 47자 |
| description 줄수 | 3줄 이내 | 6줄 | 2줄 |
| 구조 | 불릿 우선 | 산문 | 불릿 |
