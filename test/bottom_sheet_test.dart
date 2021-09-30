// Copyright (c) 2019-present,  SurfStudio LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:ui';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:bottom_sheet/src/widgets/flexible_bottom_sheet_scroll_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_lint_rules/surf_lint_rules.dart';

import 'scroll.dart';
import 'test_utils.dart';

void main() {
  const listViewKey = Key('ListView');

  late BuildContext savedContext;

  final app = MaterialApp(
    home: Builder(
      builder: (context) {
        savedContext = context;
        return const Scaffold();
      },
    ),
  );

  Future<void> showBottomSheet({bool? isCollapsible, bool? isDismissible}) {
    return showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 0.8,
      context: savedContext,
      isCollapsible: isCollapsible ?? true,
      isDismissible: isDismissible ?? true,
      builder: (context, controller, offset) {
        return ListView(
          key: listViewKey,
          controller: controller,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.red,
            ),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.black,
            ),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.green,
            ),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.blue,
            ),
          ],
        );
      },
      anchors: [0, 0.5, 0.8],
    );
  }

  double getFractionalHeight(WidgetTester tester){
    final screenHeight = tester.getSize(find.byType(MaterialApp)).height;
    final headOffset = tester.getTopLeft(find.byKey(listViewKey));

    return (screenHeight - headOffset.dy) / screenHeight;
  }

  group('Smoke tests', () {
    testWidgets('FlexibleDraggableScrollableSheet builds', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(const _FlexibleDraggableScrollableSheet()),
      );

      expect(() => _FlexibleDraggableScrollableSheet, returnsNormally);
    });

    testWidgets('FlexibleScrollNotifyer builds', (tester) async {
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
        child: const _FlexibleDraggableScrollableSheet(),
      );

      await tester.pumpWidget(makeTestableWidget(widget));

      expect(() => widget, returnsNormally);
    });
  });

  group('FlexibleScrollNotifyer', () {
    testWidgets('scroll callbacks', (tester) async {
      final result = <Scroll>[];

      final widget = FlexibleScrollNotifier(
        scrollStartCallback: (_) {
          result.add(Scroll.start);
          return true;
        },
        scrollCallback: (_) {
          result.add(Scroll.scrolling);
          return true;
        },
        scrollEndCallback: (_) {
          result.add(Scroll.end);
          return true;
        },
        child: const FlexibleBottomSheet(),
      );

      await tester.pumpWidget(makeTestableWidget(widget));

      final gesture = await tester.startGesture(const Offset(250, 300));

      expect(result, [Scroll.start]);

      await gesture.moveBy(const Offset(0, 50));

      expect(result, contains(Scroll.scrolling));

      await gesture.up();

      expect(result.last, equals(Scroll.end));
    });
  });

  group(
    'FlexibleBottomSheet',
    () {
      testWidgets('Availability widgets', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            const FlexibleBottomSheet(),
          ),
        );

        final flexibleScrollNotifier = find.byType(FlexibleScrollNotifier);
        expect(flexibleScrollNotifier, findsOneWidget);

        final flexibleDraggableScrollableSheet =
            find.byType(FlexibleDraggableScrollableSheet);
        expect(flexibleDraggableScrollableSheet, findsOneWidget);
      });

      testWidgets('Tap on the BottomSheet', (tester) async {
        await tester.pumpWidget(app);

        unawaited(showBottomSheet());

        await tester.pumpAndSettle();
        expect(find.byType(FlexibleBottomSheet), findsOneWidget);

        // Tap on the bottom sheet does not close it.
        await tester.tap(find.byType(FlexibleBottomSheet));
        await tester.pumpAndSettle();
        expect(find.byType(FlexibleBottomSheet), findsOneWidget);

        //final screenHeight = tester.getSize(find.byType(MaterialApp)).height;
        //final widgetHeight =
        //    tester.getSize(find.byType(FlexibleBottomSheet)).height;
        //final heightWidget = widgetHeight / screenHeight;
        //expect(heightWidget, equals(0.5));
      });

      group('Tap above BottomSheet', () {
        testWidgets(
          'Tap above BottomSheet, isDismissible true',
          (tester) async {
            await tester.pumpWidget(app);

            unawaited(showBottomSheet());

            await tester.pumpAndSettle();
            expect(find.byType(FlexibleBottomSheet), findsOneWidget);

            // Tap above the bottom sheet to dismiss it.
            await tester.tapAt(const Offset(20.0, 20.0));
            await tester.pumpAndSettle();
            expect(find.byType(FlexibleBottomSheet), findsNothing);
          },
        );

        testWidgets(
          'Tap above BottomSheet, isDismissible false',
          (tester) async {
            await tester.pumpWidget(app);

            unawaited(showBottomSheet(isDismissible: false));

            await tester.pumpAndSettle();
            expect(find.byType(FlexibleBottomSheet), findsOneWidget);

            // Tap above the bottom sheet,  it shouldn't close it.
            await tester.tapAt(const Offset(20.0, 20.0));
            await tester.pumpAndSettle();
            expect(find.byType(FlexibleBottomSheet), findsOneWidget);
          },
        );
      });

      testWidgets(
        'Swipe down isCollapsible true',
        (tester) async {
          await tester.pumpWidget(app);

          unawaited(showBottomSheet());
          await tester.pumpAndSettle();

          expect(find.byType(FlexibleBottomSheet), findsOneWidget);

          // Swipe the bottom sheet to dismiss it.
          await tester.drag(
            find.byType(
              FlexibleBottomSheet,
              skipOffstage: false,
            ),
            const Offset(0.0, 300.0),
          );
          await tester.pumpAndSettle();

          expect(find.byType(FlexibleBottomSheet), findsNothing);
        },
      );

      testWidgets(
        'Swipe down isCollapsible false',
        (tester) async {
          await tester.pumpWidget(app);

          unawaited(showBottomSheet(isCollapsible: false));
          await tester.pumpAndSettle();

          expect(find.byType(FlexibleBottomSheet), findsOneWidget);

          // Swipe over the bottom sheet, it shouldn't close it.
          await tester.drag(
            find.byType(
              FlexibleBottomSheet,
              skipOffstage: false,
            ),
            const Offset(0.0, 300.0),
          );
          await tester.pumpAndSettle();

          expect(find.byType(FlexibleBottomSheet), findsOneWidget);
        },
      );
    },
  );

  testWidgets(
    'When scrolling up, the size of the bottom sheet is maxHeight ',
    (tester) async {
      await tester.pumpWidget(app);

      unawaited(showBottomSheet(isCollapsible: false));
      await tester.pumpAndSettle();

      expect(find.byType(FlexibleBottomSheet), findsOneWidget);

      await tester.drag(
        find.byType(FlexibleBottomSheet),
        const Offset(0, -800),
      );

      await tester.pumpAndSettle();

      final fractionalHeight = getFractionalHeight(tester);

      expect(fractionalHeight, moreOrLessEquals(0.8));
    },
  );

group('Anchors', () {
  testWidgets('Anchors', (tester) async {
    await tester.pumpWidget(app);

    unawaited(showBottomSheet());
    await tester.pumpAndSettle();

    expect(find.byKey(listViewKey), findsOneWidget);

    // When scrolling down 200, the bottom sheet should be 0.5 (because the anchor is 0.5).
    await tester.timedDrag(
      find.byType(
        FlexibleBottomSheet,
      ),
      const Offset(0, 20.0),
     const Duration(milliseconds: 50),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FlexibleBottomSheet), findsOneWidget);

    final fractionalHeight = getFractionalHeight(tester);

    expect(fractionalHeight, moreOrLessEquals(0.5));

    // When scrolling down 210, the bottom sheet should be close.
    await tester.timedDrag(
      find.byType(
        FlexibleBottomSheet,
      ),
      const Offset(0, 210.0),
      const Duration(milliseconds: 50),
    );

    await tester.pumpAndSettle();

    expect(find.byType(FlexibleBottomSheet), findsNothing);
  });
});
}

class _FlexibleDraggableScrollableSheet extends StatelessWidget {
  const _FlexibleDraggableScrollableSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlexibleDraggableScrollableSheet(
      builder: (context, scrollController) {
        return ListView.builder(
          controller: scrollController,
          itemCount: 25,
          itemBuilder: (context, index) {
            return ListTile(title: Text('Item $index'));
          },
        );
      },
    );
  }
}
