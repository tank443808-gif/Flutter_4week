# 결정 근거표

| 선택 항목 | 근거 | 이유 |
|---|---|---|
| 세로 목록 구성에 `ListView`를 사용 | 콘텐츠가 세 개의 정보 카드가 위아래로 자연스럽게 쌓여야 함 | `ListView`는 여러 항목을 세로로 나열하고 스크롤할 수 있어, 프로필 정보가 길어질 때도 안정적으로 화면을 구성할 수 있다. |
| 관련 정보를 `Card`로 묶음 | 관심 분야, 이번 주 목표, 연락 방법은 각각 독립된 의미 단위로 묶여야 함 | `Card`는 제목과 내용을 하나의 그룹으로 시각적으로 구분해 주어, 비슷한 내용을 한 덩어리로 보여주고 읽기 쉽게 만든다. |
| 완료 알림에 `SnackBar`를 사용 | 확인 버튼을 눌렀을 때 짧고 즉각적인 결과 피드백이 필요함 | `SnackBar`는 화면 하단에 짧게 나타나며, 사용자에게 행동 결과를 빠르게 전달하고 화면 이동 없이도 간단한 피드백을 제공한다. |

## 위젯 범주별 설명

- 보여 주기: `Text`, `Icon`, `CircleAvatar`
- 배치·스크롤: `Row`, `Column`, `ListView`, `Card`
- 동작·피드백: `ElevatedButton`, `SnackBar`

## 실행화면
<img width="944" height="518" alt="image" src="https://github.com/user-attachments/assets/46d92cd2-8136-4658-9927-3276be357e28" />

## 버튼 동작
<img width="937" height="521" alt="image" src="https://github.com/user-attachments/assets/fec0d6d6-babb-4cb5-98d0-9f1ba21ae909" />
