# 4주차 공지 앱

`lib/main2.dart`는 로딩·성공·실패와 재시도 동작을 보여주는 모의 공지 앱입니다. 외부 API나 추가 패키지 없이 Flutter 기본 위젯과 `Future`를 사용합니다. 기존 `lib/main.dart`와 `lib/main1.dart`은 별도 과제 진입점이므로 수정하지 않았습니다.

## 실행

프로젝트 폴더(`week4_app`)에서 다음 명령을 실행합니다.

```powershell
flutter pub get
flutter run -t lib/main2.dart
```

`모의 실패 예약`을 누른 뒤 새로고침하면 실패 화면이 나타납니다. `다시 시도`를 누르면 요청 횟수가 증가하고 공지 목록이 복구됩니다. 로딩 중에는 새로고침이 비활성화되어 중복 요청을 막습니다.

## 검증 및 제출 기록

- 인수 조건·검증 결과·도구 계약: [CONTEXT_PACKET.md](CONTEXT_PACKET.md)
- 화면별 증거와 스크린샷/AC 연결: [EVIDENCE_TABLE.md](EVIDENCE_TABLE.md)
- 실제 요청 A/B 비교 기록: [PROMPT_COMPARISON.md](PROMPT_COMPARISON.md)
- 실행: `flutter test test/main2_test.dart`
- 분석: `flutter analyze`

실제 기기에서 캡처하지 않은 화면은 테스트 렌더러 골든 이미지로 구분해 기록합니다. 실제로 실행하지 않은 프롬프트 비교나 GitHub 제출 링크는 미검증/미완료로 남깁니다.
