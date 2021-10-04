import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
