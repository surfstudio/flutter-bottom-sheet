import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:bottom_sheet/src/widgets/flexible_bottom_sheet_scroll_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main(){
  group
    ('FlexibleScrollNotifier', () {
    testWidgets('FlexibleScrollNotifier builds normally', (tester) async {
      final widget = FlexibleScrollNotifier(
        scrollStartCallback: (_) {
          return true;
        },
        scrollCallback: (_) {
          return true;
        },
        scrollEndCallback: (_) {
          return true;
        },
        child: const SingleChildScrollView(),
      );

      await tester.pumpWidget(makeTestableWidget(widget));

      expect(tester.takeException(), isNull);
    });

    testWidgets('Scroll callbacks', (tester) async {
      final result = <_Scroll>[];

      final widget = FlexibleScrollNotifier(
        scrollStartCallback: (_) {
          result.add(_Scroll.start);
          return true;
        },
        scrollCallback: (_) {
          result.add(_Scroll.scrolling);
          return true;
        },
        scrollEndCallback: (_) {
          result.add(_Scroll.end);
          return true;
        },
        child: FlexibleBottomSheet(),
      );

      await tester.pumpWidget(makeTestableWidget(widget));

      final gesture = await tester.startGesture(const Offset(250, 300));

      expect(result, [_Scroll.start]);

      await gesture.moveBy(const Offset(0, 50));

      expect(result, contains(_Scroll.scrolling));

      await gesture.up();

      expect(result.last, equals(_Scroll.end));
    });
  });
}

enum _Scroll {
  start,
  scrolling,
  end,
}
