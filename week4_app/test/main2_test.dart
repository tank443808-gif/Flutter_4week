import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week4_app/main2.dart';

void setTestView(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> finishRequest(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump();
}

void main() {
  testWidgets('AC1: shows loading before the first mock response', (
    tester,
  ) async {
    setTestView(tester);
    final service = MockNoticeService();

    await tester.pumpWidget(NoticeApp(service: service));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('공지를 불러오는 중입니다.'), findsOneWidget);
    expect(find.text('요청 횟수: 1'), findsOneWidget);
    await expectLater(
      find.byKey(const ValueKey('notice-screen')),
      matchesGoldenFile('goldens/ac1-loading.png'),
    );

    await finishRequest(tester);
    expect(find.text('4주차 과제 제출 안내'), findsOneWidget);
  });

  testWidgets('AC2: renders validated notices after a successful request', (
    tester,
  ) async {
    setTestView(tester);
    final service = MockNoticeService();

    await tester.pumpWidget(NoticeApp(service: service));
    await finishRequest(tester);

    expect(find.text('최근 공지'), findsOneWidget);
    expect(find.text('4주차 과제 제출 안내'), findsOneWidget);
    expect(find.text('실습실 이용 안내'), findsOneWidget);
    expect(find.text('요청 횟수: 1'), findsOneWidget);
    await expectLater(
      find.byKey(const ValueKey('notice-screen')),
      matchesGoldenFile('goldens/ac2-success.png'),
    );
  });

  testWidgets('AC3-AC4: shows failure, retries, and recovers successfully', (
    tester,
  ) async {
    setTestView(tester);
    final service = MockNoticeService();

    await tester.pumpWidget(NoticeApp(service: service));
    await finishRequest(tester);
    await tester.tap(find.byKey(const ValueKey('schedule-failure')));
    await tester.pump();
    expect(find.text('다음 요청 실패 예약됨'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('refresh-notices')));
    await tester.pump();
    expect(find.text('공지를 불러오는 중입니다.'), findsOneWidget);
    expect(find.text('요청 횟수: 2'), findsOneWidget);
    await finishRequest(tester);

    expect(find.text('공지를 불러오지 못했습니다.'), findsOneWidget);
    expect(find.text('모의 요청이 실패했습니다.'), findsOneWidget);
    await expectLater(
      find.byKey(const ValueKey('notice-screen')),
      matchesGoldenFile('goldens/ac3-failure.png'),
    );

    await tester.tap(find.byKey(const ValueKey('retry-notices')));
    await tester.pump();
    expect(find.text('공지를 불러오는 중입니다.'), findsOneWidget);
    expect(find.text('요청 횟수: 3'), findsOneWidget);
    await expectLater(
      find.byKey(const ValueKey('notice-screen')),
      matchesGoldenFile('goldens/ac4-retry-loading.png'),
    );
    await finishRequest(tester);

    expect(find.text('4주차 과제 제출 안내'), findsOneWidget);
    expect(find.text('요청 횟수: 3'), findsOneWidget);
    await expectLater(
      find.byKey(const ValueKey('notice-screen')),
      matchesGoldenFile('goldens/ac4-recovered.png'),
    );
  });

  testWidgets('AC5: repeated refresh taps during loading make one request', (
    tester,
  ) async {
    setTestView(tester);
    final service = MockNoticeService();

    await tester.pumpWidget(NoticeApp(service: service));
    await finishRequest(tester);
    expect(service.requestCount, 1);

    await tester.tap(find.byKey(const ValueKey('refresh-notices')));
    await tester.pump();
    expect(service.requestCount, 2);

    await tester.tap(
      find.byKey(const ValueKey('refresh-notices')),
      warnIfMissed: false,
    );
    await tester.pump();
    expect(service.requestCount, 2);
    expect(find.text('요청 횟수: 2'), findsOneWidget);
    await expectLater(
      find.byKey(const ValueKey('notice-screen')),
      matchesGoldenFile('goldens/ac5-duplicate-taps.png'),
    );

    await finishRequest(tester);
    expect(service.requestCount, 2);
  });
}
