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

import 'dart:async';
import 'dart:ui';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const textFieldKey = Key('Text field key');

void main() {
  late BuildContext savedContext;

  final app = MaterialApp(
    home: Builder(
      builder: (context) {
        savedContext = context;
        return const Scaffold();
      },
    ),
  );

  Future<void> showStickyBottomSheet({
    double? headerHeight,
    double? maxHeaderHeight,
    double? minHeaderHeight,
    Color? barrierColor,
    bool? isModal,
  }) {
    return showStickyFlexibleBottomSheet(
      isModal: isModal ?? true,
      barrierColor: barrierColor,
      context: savedContext,
      minHeaderHeight: minHeaderHeight,
      maxHeaderHeight: maxHeaderHeight,
      headerHeight: headerHeight,
      headerBuilder: (context, offset) {
        return const SizedBox(
          height: 200,
          child: Center(child: Text('Header')),
        );
      },
      bodyBuilder: (context, offset) {
        return SliverChildListDelegate(
          _listWidgets,
        );
      },
    );
  }

  testWidgets(
    'StickyBottomSheet, when drug header must remain visible',
    (tester) async {
      await tester.pumpWidget(app);

      unawaited(showStickyBottomSheet(headerHeight: 200.0));

      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(
          FlexibleBottomSheet,
          skipOffstage: false,
        ),
        const Offset(0, -800),
      );

      expect(find.text('Header'), findsOneWidget);
    },
  );

  testWidgets(
    'Parameters in StickyBottomSheet must be specified correctly '
    '(maxHeaderHeight or headerHeight should not be equal null)',
    (tester) async {
      await tester.pumpWidget(app);
      expect(
        () async {
          unawaited(
            showStickyBottomSheet(
              headerHeight:
                  _headerHeightTestVariants.currentValue!.headerHeight,
              maxHeaderHeight:
                  _headerHeightTestVariants.currentValue!.maxHeaderHeight,
            ),
          );

          await tester.pumpAndSettle();
        },
        _headerHeightTestVariants.currentValue!.matcher,
      );
    },
    variant: _headerHeightTestVariants,
  );

  testWidgets(
    'If the text field is at the bottom of the bottom sheet, after focusing'
    ' on it and the keyboard appears, the text field widget should rise above '
    'the keyboard.',
    (tester) async {
      await tester.pumpWidget(app);
      unawaited(showStickyBottomSheet(headerHeight: 100));
      await tester.pumpAndSettle();

      expect(find.byKey(textFieldKey), findsNothing);

      await tester.fling(
        find.byType(
          CustomScrollView,
          skipOffstage: false,
        ),
        const Offset(0, -1000),
        800,
      );
      await tester.pumpAndSettle();

      expect(find.byKey(textFieldKey), findsOneWidget);

      final testBinding = tester.binding;
      testBinding.window.viewInsetsTestValue = const FakeWindowPadding();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byKey(textFieldKey), findsOneWidget);
    },
  );

  testWidgets(
    'if pass  barrierColor and isModal false should be an AssertionError',
    (tester) async {
      await tester.pumpWidget(app);

      expect(
        () => showStickyBottomSheet(
          barrierColor: Colors.red,
          isModal: false,
        ),
        throwsA(isA<AssertionError>()),
      );
    },
  );
}

final _listWidgets = [
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
  Container(
    height: 200,
    width: double.infinity,
    color: Colors.red,
  ),
  const TextField(key: textFieldKey),
];

class _HeaderHeightTestScenario {
  final double? headerHeight;
  final double? maxHeaderHeight;
  final Matcher matcher;

  _HeaderHeightTestScenario({
    required this.matcher,
    this.headerHeight,
    this.maxHeaderHeight,
  });
}

final ValueVariant<_HeaderHeightTestScenario> _headerHeightTestVariants =
    ValueVariant<_HeaderHeightTestScenario>({
  _HeaderHeightTestScenario(headerHeight: 200.0, matcher: returnsNormally),
  _HeaderHeightTestScenario(maxHeaderHeight: 200.0, matcher: returnsNormally),
  _HeaderHeightTestScenario(
    matcher: throwsAssertionError,
  ),
});

class FakeWindowPadding implements WindowPadding {
  @override
  final double left;

  @override
  final double top;

  @override
  final double right;

  @override
  final double bottom;

  const FakeWindowPadding({
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 330.0,
  });
}
