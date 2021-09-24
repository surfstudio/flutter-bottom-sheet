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

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:bottom_sheet/src/widgets/flexible_bottom_sheet_scroll_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'scroll.dart';
import 'test_utils.dart';

final _flexibleDraggableScrollableSheet = FlexibleDraggableScrollableSheet(
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

void main() {
  group('Smoke tests', () {
    testWidgets('FlexibleDraggableScrollableSheet builds', (tester) async {
      await tester
          .pumpWidget(makeTestableWidget(_flexibleDraggableScrollableSheet));

      expect(() => _flexibleDraggableScrollableSheet, returnsNormally);
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
        child: _flexibleDraggableScrollableSheet,
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

  group('FlexibleBottomSheet', () {
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

    testWidgets('Size', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const FlexibleBottomSheet(
            maxHeight: 0.8,
            minHeight: 0.2,
          ),
        ),
      );
      tester.binding.window.physicalSizeTestValue = const Size(42, 42);

      final BuildContext context = tester.element(
        find.byType(FlexibleBottomSheet),
      );

      //final screenHeight = MediaQuery.of(context).size.height;
      final sizeWidget = tester.getSize(find.byType(Scaffold)).height;
      //final heightWidget = sizeWidget / screenHeight;
      expect(sizeWidget, equals(0.8));
    });
  });
}
