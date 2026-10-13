# 공지 앱 제출 기록

## 구현 범위

- 실행 파일: `lib/main2.dart`
- 실행 명령(프로젝트 폴더에서): `flutter run -t lib/main2.dart`
- 서비스: 외부 연결 없는 `MockNoticeService`; 기본 응답 지연 500ms
- 패키지: 추가 없음
- 이전 과제 진입점인 `lib/main.dart`, `lib/main1.dart`은 유지

모의 서비스는 공지 3개를 반환하고 요청 횟수를 기록한다. 화면의 `모의 실패 예약`은 다음 요청만 실패하도록 설정한다. 실패한 Future는 오류 화면으로 전환되고 재시도 요청은 정상 응답으로 복구된다. 새로고침은 로딩 중 비활성화되며 요청 처리 함수에도 중복 호출 방어가 있다.

## AC1–AC5 실제 관측 및 결과

| AC | 관측 가능한 조건 | 결과 | 재현/증거 |
|---|---|---|---|
| AC1 | 최초 Future가 끝나기 전 진행 표시와 `요청 횟수: 1` 표시 | 통과 | `flutter test test/main2_test.dart`; `test/goldens/ac1-loading.png` |
| AC2 | 정상 응답 후 3개 중 공지 제목과 요청 횟수 1 표시 | 통과 | `flutter test test/main2_test.dart`; `test/goldens/ac2-success.png` |
| AC3 | 실패 주입 요청에서 오류 안내와 재시도 버튼 표시 | 통과 | `flutter test test/main2_test.dart`; `test/goldens/ac3-failure.png` |
| AC4 | 재시도 중 로딩/요청 횟수 증가 후 정상 공지로 복구 | 통과 | `test/goldens/ac4-retry-loading.png`, `test/goldens/ac4-recovered.png` |
| AC5 | 로딩 중 새로고침 연속 입력에도 요청 횟수가 2에서 증가하지 않음 | 통과 | `test/goldens/ac5-duplicate-taps.png`; 테스트에서 서비스 카운터도 확인 |

이 AC는 전달받은 과제 설명의 명시 요구(상태 구분, 복구, 요청 횟수, 중복 입력)를 테스트 가능한 형태로 구체화한 것이다. 별도 AC 원문은 제공되지 않았다.

## 비동기 동작에 대한 학습 설명 초안

이 설명은 코드와 실행 로그를 바탕으로 정리한 초안이며, 제출 전에 학습자가 실제로 이해한 표현으로 확인·수정해야 한다.

`_loadNotices`는 요청 시작 전에 로딩 상태를 설정한다. `await fetchNotices()`에 도달하면 Future 완료를 기다리는 동안 현재 호출은 중단되고 Flutter 이벤트 루프는 UI를 그릴 수 있다. Future가 완료되면 다음 문장이 이어서 실행된다. 성공 시 응답을 확인한 뒤 `mounted`를 검사하고 공지와 성공 상태를 한 번에 갱신한다. `Exception`이 발생하면 로그에 오류와 stack trace를 남기고 오류 상태로 표시한다. `finally`에서는 진행 중 잠금을 해제한다.

Future는 한 번 완료되는 비동기 결과를 나타내므로 한 번의 공지 요청에 적합하다. Stream은 여러 시점에 걸친 연속 이벤트(예: 실시간 공지 갱신)에 적합하다. 동시성은 기다리는 동안 다른 작업이 진행되도록 실행을 조율하는 것이고 병렬성은 여러 계산을 실제로 동시에 수행하는 것이다. `async`/`await`는 CPU 계산을 다른 isolate로 옮기지 않는다. 이 앱의 짧은 모의 지연도 CPU 계산 성능 측정이 아니다.

응답 검증은 목록이 비어 있지 않고 각 공지의 제목·본문·날짜가 공백이 아닌지만 확인한다. 정적 모의 응답만 사용하므로 네트워크 가용성, 서버 스키마/신뢰성, 최신성, 실제 요청 지연, 실기기 성능은 검증하지 않는다. Stream 연속 갱신과 isolate 예제는 실행하지 않았다.

## 도구 계약 및 실행 기록

| 도구 | 목적·입력 | 출력·오류 처리 | 권한 및 실제 사용 |
|---|---|---|---|
| `MockNoticeService.fetchNotices()` | 입력 없음; 한 번의 비동기 모의 공지 요청 | `Future<List<Notice>>`; 요청 수 증가, 예약된 실패는 `NoticeServiceException`으로 거절, 정상 시 불변 공지 목록 반환 | 앱 내부 모의 서비스; 외부 네트워크/파일 권한 없음. 위젯 테스트에서 호출 수와 성공·실패를 확인 |
| `MockNoticeService.failNextRequest()` | 입력 없음 | 다음 fetch 한 번만 실패하도록 설정 | 앱의 명시적 시뮬레이션 버튼과 위젯 테스트에서 실행 |
| `flutter test test/main2_test.dart` | 지정한 위젯 테스트 파일 | AC1–AC5 단언 및 골든 비교; 실패 시 테스트 실패와 종료 코드 비영(0 아님) | 로컬 Flutter 테스트 실행. 최종 실행 원문/종료 코드는 아래 검증 결과에 기록 |
| `flutter analyze` | Flutter 프로젝트 소스 분석 | 분석 메시지와 종료 코드; 오류/경고 시 비영 종료 코드 | 로컬 정적 분석. 최종 실행 원문/종료 코드는 아래 검증 결과에 기록 |
| `flutter run -t lib/main2.dart` | 앱 진입점 지정 | 연결한 장치/에뮬레이터에서 앱 실행; 실행 오류는 CLI에 표시 | 이 기록 작성 중 실기기/에뮬레이터 실행은 하지 않음 |

### 검증 결과

정상 테스트 4개가 통과했다. AC3에서 의도적으로 주입한 모의 요청 실패는 오류 화면 전환을 위한 시나리오이며, 테스트 실패가 아니다. 골든 생성 명령과 일반 테스트 명령이 각각 실제 실행됐다.

#### `flutter analyze`

```text
Analyzing week4_app...
No issues found! (ran in 4.0s)
```

종료 코드: `0`

#### `flutter test test/main2_test.dart`

```text
00:00 +0: loading C:/Flutter_4week/week4_app/test/main2_test.dart
00:00 +0: AC1: shows loading before the first mock response
00:01 +1: AC2: renders validated notices after a successful request
00:01 +2: AC3-AC4: shows failure, retries, and recovers successfully
공지 요청 실패: 모의 요청이 실패했습니다.
#0      MockNoticeService.fetchNotices (package:week4_app/main2.dart:66:7)
<asynchronous suspension>
#1      _NoticePageState._loadNotices (package:week4_app/main2.dart:140:23)
<asynchronous suspension>

00:01 +3: AC5: repeated refresh taps during loading make one request
00:02 +4: All tests passed!
```

종료 코드: `0`

#### 골든 이미지 생성

실행 명령: `flutter test test/main2_test.dart --update-goldens`

결과 원문: `All tests passed!` (4 tests)

종료 코드: `0`; AC별 PNG 파일이 `test/goldens/`에 생성됨.

## 재현 및 기록 상태

- [x] 요청 A/B를 실행하지 않은 사실을 [PROMPT_COMPARISON.md](PROMPT_COMPARISON.md)에 표시
- [x] 테스트 골든과 AC 연결을 [EVIDENCE_TABLE.md](EVIDENCE_TABLE.md)에 표시
- [ ] 실기기 화면 캡처, 기기/플랫폼 기록
- [ ] 요청 A/B 실제 실행·응답·모델명·응답 차이 및 선택 이유 기록
- [ ] 개인 저장소 여부 확인 후 제출 commit 및 GitHub 링크 기록
