# 화면 및 AC 증거표

아래 PNG는 `flutter test test/main2_test.dart --update-goldens`로 생성한 Flutter 위젯 테스트 렌더러의 골든 이미지다. 실제 기기 캡처가 아니다. 현재 테스트 렌더러에는 한글 글리프가 없어 PNG의 한글이 네모로 보인다. 화면 상태의 시각적 배치와 AC 연결은 기록하지만, 텍스트는 위젯 테스트의 문자열 단언으로 별도 확인했다. 이 골든을 실기기에서 한글이 정상 표시된 증거라고 표현하지 않는다.

| 스크린샷 | AC | 관측 내용 | 관측 방식 |
|---|---|---|---|
| `test/goldens/ac1-loading.png` | AC1 | 첫 응답 대기 중 진행 표시 및 요청 횟수 1 | 위젯 테스트 골든 |
| `test/goldens/ac2-success.png` | AC2 | 정상 응답의 공지 목록 및 요청 횟수 1 | 위젯 테스트 골든 |
| `test/goldens/ac3-failure.png` | AC3 | 실패 안내, 오류 내용, 다시 시도 버튼 및 요청 횟수 2 | 실패 예약 후 위젯 테스트 골든 |
| `test/goldens/ac4-retry-loading.png` | AC4 | 복구 요청이 진행 중이고 요청 횟수 3 | 재시도 후 위젯 테스트 골든 |
| `test/goldens/ac4-recovered.png` | AC4 | 재시도 성공으로 공지 목록 복구 및 요청 횟수 3 | 위젯 테스트 골든 |
| `test/goldens/ac5-duplicate-taps.png` | AC5 | 진행 중 새로고침을 다시 눌러도 요청 횟수 2 유지 | 위젯 테스트 골든 및 서비스 카운터 단언 |

골든 파일 생성·갱신 명령:

```powershell
flutter test test/main2_test.dart --update-goldens
```

실기기 캡처를 추가할 경우 파일명, AC, OS/기기, 캡처 시점, 실행한 코드 commit을 함께 기록한다. 아직 실기기 캡처와 기기 실행은 하지 않았다.
