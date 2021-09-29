import 'dart:async';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('C1test', (tester) async {
    late final BuildContext ctx;

    const scaffold = Scaffold();

    await tester.pumpWidgetBuilder(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return scaffold;
          },
        ),
      ),
    );

    unawaited(
      showFlexibleBottomSheet<void>(
        minHeight: 0,
        initHeight: 0.5,
        maxHeight: 1,
        context: ctx,
        builder: (context, controller, offset) {
          return ListView(
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
        anchors: [0, 0.5, 1],
      ),
    );

    await tester.pumpAndSettle();

    await tester.drag(
      find.byType(
        FlexibleBottomSheet,
      ),
      const Offset(50, 300.0),
    );

    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'bsh');
  });
}
//
// void main() {
//   // testGoldens(
//   //   'FlexibleBottomSheet',
//   //   (tester) async {
//   //     final builder = GoldenBuilder.column()
//   //       ..addScenario(
//   //         'Swipe down',
//   //         MaterialApp(
//   //           home: Builder(
//   //             builder: (context) {
//   //               savedContext = context;
//   //               return FlexibleBottomSheet(
//   //                 builder: (context, controller, offset) {
//   //                   return ListView(
//   //                     children: [
//   //                       Container(
//   //                         height: 200,
//   //                         width: double.infinity,
//   //                         color: Colors.red,
//   //                       ),
//   //                       Container(
//   //                         height: 200,
//   //                         width: double.infinity,
//   //                         color: Colors.black,
//   //                       ),
//   //                       Container(
//   //                         height: 200,
//   //                         width: double.infinity,
//   //                         color: Colors.red,
//   //                       ),
//   //                       Container(
//   //                         height: 200,
//   //                         width: double.infinity,
//   //                         color: Colors.black,
//   //                       ),
//   //                     ],
//   //                   );
//   //                 },
//   //               );
//   //             },
//   //           ),
//   //         ),
//   //       );
//   //
//   //
//   //     await screenMatchesGolden(tester, 'FlexibleBottomSheet');
//   //   },
//   // );
//
//   testGoldens('C1test', (tester) async {
//     late final BuildContext ctx;
//
//     await tester.pumpWidgetBuilder(
//       MaterialApp(
//         home: Builder(
//             builder: (context) {
//               ctx = context;
//               return const Scaffold();
//             },
//         ),
//       ),
//     );
//
//
//     await showFlexibleBottomSheet<void>(
//       minHeight: 0,
//       initHeight: 0.5,
//       maxHeight: 1,
//       context: ctx,
//       builder: (context, controller, offset) {
//         return ListView(
//           children: [
//             Container(
//               height: 200,
//               width: double.infinity,
//               color: Colors.red,
//             ),
//             Container(
//               height: 200,
//               width: double.infinity,
//               color: Colors.black,
//             ),
//             Container(
//               height: 200,
//               width: double.infinity,
//               color: Colors.red,
//             ),
//             Container(
//               height: 200,
//               width: double.infinity,
//               color: Colors.black,
//             ),
//           ],
//         );
//       },
//       anchors: [0, 0.5, 1],
//     );
//
//     await tester.pump();
//
//     await screenMatchesGolden(tester, 'bsh');
//   });
// }
