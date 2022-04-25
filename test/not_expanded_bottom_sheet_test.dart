import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_lint_rules/surf_lint_rules.dart';

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

  Future<void> showBottomSheet({
    required List<Widget> listWidgets,
    bool? isExpand,
    double? minHeight,
    double? initHeight,
    double? maxHeight,
    List<double>? anchors,
  }) {
    return showFlexibleBottomSheet<void>(
      isExpand: isExpand ?? true,
      minHeight: minHeight ?? 0,
      initHeight: initHeight ?? 0.5,
      maxHeight: maxHeight ?? 0.8,
      context: savedContext,
      builder: (context, controller, offset) {
        return ListView(
          key: listViewKey,
          shrinkWrap: true,
          controller: controller,
          children: listWidgets,
        );
      },
      anchors: anchors,
    );
  }

  double getFractionalHeight(WidgetTester tester) {
    final screenHeight = tester.getSize(find.byType(MaterialApp)).height;
    final headOffset = tester.getTopLeft(find.byKey(listViewKey));

    return (screenHeight - headOffset.dy) / screenHeight;
  }

  group(
    'If isExpand false bottom sheet must should have height based on content',
    () {
      testWidgets(
        'If content height more than initHeight bottomSheet when opened must have initHeight height',
        (tester) async {
          const initHeight = 0.5;
          const maxHeight = 0.5;

          await tester.pumpWidget(app);

          unawaited(showBottomSheet(
            listWidgets: _listWidgets,
            initHeight: initHeight,
            isExpand: false,
            maxHeight: maxHeight,
          ));
          await tester.pumpAndSettle();

          expect(find.byType(FlexibleBottomSheet), findsOneWidget);

          final fractionalHeight = getFractionalHeight(tester);
          expect(fractionalHeight == initHeight, true);
        },
      );

      testWidgets(
        'if content height is less than initHeight bottom sheet must have content height',
        (tester) async {
          const initHeight = 0.5;
          const maxHeight = 0.5;
          final listWidgets = [_listWidgets.first];

          await tester.pumpWidget(app);

          unawaited(showBottomSheet(
            listWidgets: listWidgets,
            initHeight: initHeight,
            isExpand: false,
            maxHeight: maxHeight,
          ));
          await tester.pumpAndSettle();

          expect(find.byType(FlexibleBottomSheet), findsOneWidget);

          final fractionalHeight = getFractionalHeight(tester);
          expect(fractionalHeight < initHeight, true);
        },
      );

      testWidgets(
        'If pass different values to the widget initHeight and maxHeight there should be AssertionError',
        (tester) async {
          const initHeight = 0.5;
          const maxHeight = 1.0;

          await tester.pumpWidget(app);

          unawaited(
            showBottomSheet(
              listWidgets: _listWidgets,
              isExpand: false,
              initHeight: initHeight,
              maxHeight: maxHeight,
            ),
          );

          await tester.pumpAndSettle();

          expect(tester.takeException(), isInstanceOf<AssertionError>());
        },
      );

      testWidgets(
        'If pass list anchors there should be AssertionError',
        (tester) async {
          const initHeight = 0.5;
          const maxHeight = 1.0;
          const listAnchors = <double>[0, 0.5, 1.0];

          await tester.pumpWidget(app);

          unawaited(
            showBottomSheet(
              listWidgets: _listWidgets,
              isExpand: false,
              initHeight: initHeight,
              maxHeight: maxHeight,
              anchors: listAnchors,
            ),
          );

          await tester.pumpAndSettle();

          expect(tester.takeException(), isInstanceOf<AssertionError>());
        },
      );
    },
  );

  testWidgets(
    'if content height is less than initHeight and isExpand = true, bottom sheet must have initHeight height',
    (tester) async {
      const initHeight = 0.5;
      const maxHeight = 0.5;
      final listWidgets = [_listWidgets.first];

      await tester.pumpWidget(app);

      unawaited(showBottomSheet(
        listWidgets: listWidgets,
        initHeight: initHeight,
        isExpand: true,
        maxHeight: maxHeight,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(FlexibleBottomSheet), findsOneWidget);

      final fractionalHeight = getFractionalHeight(tester);
      expect(fractionalHeight == initHeight, true);
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
];
