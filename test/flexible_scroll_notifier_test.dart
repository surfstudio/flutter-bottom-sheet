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

import 'test_utils.dart';

void main() {
  group('FlexibleScrollNotifier', () {
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
