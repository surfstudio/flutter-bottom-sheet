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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'test_utils.dart';

void main() {
  testWidgets(
    'FlexibleDraggableScrollableSheet builds normally',
    (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          FlexibleDraggableScrollableSheet(
            builder: (context, scrollController) {
              return ListView.builder(
                controller: scrollController,
                itemCount: 25,
                itemBuilder: (context, index) {
                  return ListTile(title: Text('Item $index'));
                },
              );
            },
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    },
  );

  test('FlexibleDraggableScrollableNotification toString', () {
    const extent = 0.5;
    const initialExtent = 0.4;
    const maxExtent = 1.0;
    const minExtent = 0.3;

    const expectedResult =
        'FlexibleDraggableScrollableNotification(depth: 0 (local), '
        'minExtent: 0.3, extent: 0.5, maxExtent: 1.0, initialExtent: 0.4)';

    final widget = FlexibleDraggableScrollableNotification(
      extent: extent,
      initialExtent: initialExtent,
      maxExtent: maxExtent,
      minExtent: minExtent,
    );

    final result = widget.toString();

    expect(
      result,
      equals(
        expectedResult,
      ),
    );
  });

  test('FlexibleDraggableScrollableSheetScrollController toString', () {
    final extent = FakeFlexibleDraggableSheetExtent();

    final controller = FlexibleDraggableScrollableSheetScrollController(
      extent: extent,
    );

    final expectedResult =
        'FlexibleDraggableScrollableSheetScrollController#${shortHash(controller)}(no clients, extent: FakeFlexibleDraggableSheetExtent)';

    final result = controller.toString();

    expect(
      result,
      equals(
        expectedResult,
      ),
    );
  });
}

class FakeFlexibleDraggableSheetExtent extends Mock
    implements FlexibleDraggableSheetExtent {}
