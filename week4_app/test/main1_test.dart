import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week4_app/main1.dart';

void main() {
  testWidgets('confirmation toggles on and can be undone', (tester) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProfileConfirmationApp());

    expect(find.text('확인 전'), findsOneWidget);
    expect(find.text('프로필 확인'), findsOneWidget);
    await expectLater(
      find.byKey(const ValueKey('profile-confirmation-screen')),
      matchesGoldenFile('goldens/confirmation-initial.png'),
    );

    await tester.tap(find.byKey(const ValueKey('confirmation-toggle')));
    await tester.pump();

    expect(find.text('확인 완료'), findsOneWidget);
    expect(find.text('확인 취소'), findsOneWidget);
    await expectLater(
      find.byKey(const ValueKey('profile-confirmation-screen')),
      matchesGoldenFile('goldens/confirmation-completed.png'),
    );

    await tester.tap(find.byKey(const ValueKey('confirmation-toggle')));
    await tester.pump();

    expect(find.text('확인 전'), findsOneWidget);
    expect(find.text('프로필 확인'), findsOneWidget);
    await expectLater(
      find.byKey(const ValueKey('profile-confirmation-screen')),
      matchesGoldenFile('goldens/confirmation-restored.png'),
    );
  });
}
