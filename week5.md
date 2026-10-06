
<img width="1119" height="563" alt="image" src="https://github.com/user-attachments/assets/88c79da3-3b0c-41c5-8010-5ae011714065" />
실행

<img width="1111" height="555" alt="image" src="https://github.com/user-attachments/assets/9eefe87f-6f74-44b2-96df-4e8463b02b15" />
상태표시 확인

# Context Packet: 프로필 확인 상태

## 목표

`lib/main1.dart`에서 프로필 확인과 확인 취소 입력에 반응하는 Flutter 상태 기능을 구현한다. 별도 진입점 `flutter run -t lib/main1.dart`로 실행하며 기존 `lib/main.dart` 화면과 동작은 변경하지 않는다.

## 현재 코드와 근거

- 화면 및 상태 소유자: [`lib/main1.dart`](lib/main1.dart)의 `_ProfileConfirmationPageState`
- 원본 상태: `_isConfirmed` (`bool`, 초기값 `false`)
- 입력: `프로필 확인` / `확인 취소` 버튼, 같은 버튼 키 `confirmation-toggle`
- 계산 표시: 상태에서 매 빌드 시 계산되는 `statusLabel`, 버튼 텍스트 및 아이콘
- 회귀 검증: [`test/main1_test.dart`](test/main1_test.dart)는 첫 화면, 확인 입력, 취소 입력 후 원복을 검증한다.
- 기존 앱: `lib/main.dart`은 정적 프로필 화면이며 이번 구현에서 수정하지 않았다.
- 의존성: Flutter SDK와 `flutter_test`만 사용한다. 외부 상태관리 패키지, 서버, 비동기 처리 없음.

## 상태 계약

| 구분 | 계약 |
|---|---|
| 원본 상태 | `_isConfirmed: bool`, 페이지의 `State`만 소유 |
| 초기값 | `false` |
| 이벤트 | 확인 버튼 탭 |
| 전이 | `false → true`, 다시 탭하면 `true → false` |
| 계산값 | `확인 전`/`확인 완료`, 버튼 문구, 상태 아이콘 |
| UI 반영 | `setState`가 재빌드를 요청하고 계산값을 화면에 렌더링 |
| 중복 저장 금지 | 계산 가능한 문구나 아이콘 상태를 별도 필드로 저장하지 않음 |

## 이벤트 → 상태 → UI 흐름

```text
초기 진입
  → _isConfirmed = false
  → 상태 "확인 전" + 버튼 "프로필 확인" + 미확인 아이콘

"프로필 확인" 탭
  → setState: _isConfirmed = true
  → 상태 "확인 완료" + 버튼 "확인 취소" + 완료 아이콘

"확인 취소" 탭
  → setState: _isConfirmed = false
  → 상태 "확인 전" + 버튼 "프로필 확인" + 미확인 아이콘
```

## 프로젝트 컨텍스트 지도

```text
week4_app/
├── lib/
│   ├── main.dart                 기존 정적 프로필 앱 진입점 (변경 없음)
│   └── main1.dart                과제 앱 진입점, 화면, 상태 및 프로필 표시 데이터
├── test/
│   ├── main1_test.dart           버튼 입력 및 초기/확인/취소 원복 골든 테스트
│   └── goldens/
│       ├── confirmation-initial.png      초기 UI 캡처
│       ├── confirmation-completed.png    확인 완료 UI 캡처
│       └── confirmation-restored.png     취소 원복 UI 캡처
├── evidence/
│   └── initial.png               실행 앱의 초기 화면 캡처
├── pubspec.yaml                 Flutter 및 flutter_test 의존성
├── CONTEXT_PACKET.md            목표, 근거, 제약, AC, 상태 흐름
└── PROMPT_COMPARISON.md         요청 A/B의 관찰 기록과 미검증 범위
```

## 제약

- 명령은 Windows 일반 명령 프롬프트에서 실행 가능해야 한다.
- 구현은 `main1.dart` 진입점에 한정하고 기존 `main.dart`을 보존한다.
- 상태 기능은 동기식 로컬 UI 상태로 유지한다.
- 위젯 골든은 Flutter 테스트 렌더러의 한글 글꼴 부재로 한글 글리프가 네모로 보일 수 있다. 실행 앱의 초기 화면은 `evidence/initial.png`로 보완하고, 버튼 입력 및 세 상태 전이는 위젯 테스트로 검증한다.
- A/B 요청 결과는 실제로 두 요청을 실행해 관찰한 경우에만 비교한다.

## 인수 조건 및 검증 연결

| AC | 인수 조건 | 검증 근거 |
|---|---|---|
| AC1 | 초기값과 첫 화면이 일치한다. | `_isConfirmed = false`; 테스트의 `확인 전`/`프로필 확인` 기대값 |
| AC2 | 한 번 입력하면 상태와 화면이 함께 바뀐다. | `setState`; 테스트의 `확인 완료`/`확인 취소` 기대값 |
| AC3 | 역동작으로 값과 화면이 함께 원복된다. | 동일 버튼 재탭; 테스트가 초기 표시를 다시 확인 |
| AC4 | 계산 표시값을 별도 원본으로 중복 저장하지 않는다. | 문구/아이콘은 `_isConfirmed`에서 빌드 시 계산 |
| AC5 | 문서의 파일·제약·AC가 실제 프로젝트와 일치한다. | 저장소 파일 및 아래 검증 결과 대조 |
| AC6 | 요청 A/B를 같은 기준으로 비교하고 미확인을 구분한다. | `PROMPT_COMPARISON.md`는 미검증을 구분하지만 두 요청의 실제 비교는 미수행이므로 미충족 |
| AC7 | 기능, 문서, 화면 증거, 분석 결과가 같은 기능을 가리킨다. | 실행 앱 초기 캡처와 세 상태 골든, 분석 및 위젯 테스트 기록 |

## 검증 기록

- 실행 명령: `flutter analyze`, `flutter test test/main1_test.dart --update-goldens`, `flutter test test/main1_test.dart`
- 분석 결과: `flutter analyze` — No issues found.
- 위젯 테스트 결과: `flutter test test/main1_test.dart --update-goldens` 및 일반 `flutter test test/main1_test.dart` 모두 통과.
- 화면 증거: `evidence/initial.png`는 실행 앱 캡처이며 `test/goldens/`의 세 PNG는 동일 위젯 테스트에서 초기·완료·원복 시점에 생성된다. 골든의 한글 글리프 렌더링 제약은 위에 명시했다.
- 제출 설명: 상태는 `_ProfileConfirmationPageState`가 소유한다. AI에 과제 요구, 기존 앱 구조, 실행 진입점 및 인수 조건을 제공해 범위와 검증 기준을 정했다. 초기/변경/원복은 AC1~AC3, 상태 파생 및 테스트는 AC4를 확인한다. 다음 수정 전 `main1.dart`, `main1_test.dart`, 이 문서, `PROMPT_COMPARISON.md`를 다시 읽는다.

# Prompt Comparison: 프로필 확인 상태

## 비교 대상과 기준

같은 기능(프로필 확인 버튼의 완료/취소 토글)을 요청 A와 요청 B로 각각 실행하고, 다음을 같은 기준으로 관찰한다.

1. 상태 소유자와 초기값이 명시되는가
2. 완료 입력과 취소 원복이 둘 다 구현되는가
3. 계산 가능한 UI 값을 중복 저장하지 않는가
4. 테스트와 문서/화면 증거를 제시하는가

## 실제 관찰 기록

| 항목 | 요청 A | 요청 B |
|---|---|---|
| 프롬프트 | 미실행 | 미실행 |
| 실행 여부 | 이 작업에서 별도 요청 실행 및 응답 관찰 안 함 | 이 작업에서 별도 요청 실행 및 응답 관찰 안 함 |
| 위 기준의 응답 결과 | 미검증 | 미검증 |

이번 구현에는 AI 코딩 도구를 사용했지만, 독립적인 두 프롬프트와 두 응답을 수집하는 비교 실험은 실행하지 않았다. 따라서 A/B 간 우열이나 성공률을 관찰 결과처럼 만들어내지 않는다. AC6의 “두 요청의 실제 응답 비교”는 미완료다.

## 재현을 위한 동일 기준 요청

- **요청 A (기본형):** `lib/main1.dart`에 프로필 확인 버튼을 추가해 탭하면 확인 완료가 표시되고, 다시 탭하면 확인 전으로 취소되게 해줘. 상태 소유자와 초기값을 밝히고 계산 가능한 표시값은 중복 저장하지 마.
- **요청 B (인수 조건형):** `lib/main1.dart`에 동기식 확인/취소 토글을 구현해줘. 초기에는 확인 전, 한 번 탭하면 완료, 다시 탭하면 원복되어야 해. 원본 상태와 파생 UI를 분리하고 초기·변경·원복 위젯 테스트 및 상태 흐름 문서를 작성해. 기존 `main.dart`은 수정하지 마.

각 요청을 별도 대화에서 실행한 다음 위 네 기준으로 실제 응답과 실행 결과를 기록해야 비교를 완료할 수 있다.



