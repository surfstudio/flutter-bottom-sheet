import 'package:bottom_sheet/src/flexible_bottom_sheet_route.dart';
import 'package:flutter/material.dart';
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
    bool? isCollapsible,
    bool? isDismissible,
    double? minHeight,
    double? initHeight,
    double? maxHeight,
    List<double>? anchors,
  }) {
    return showFlexibleBottomSheet<void>(
      minHeight: minHeight ?? 0,
      initHeight: initHeight ?? 0.5,
      maxHeight: maxHeight ?? 0.8,
      context: savedContext,
      isCollapsible: isCollapsible ?? true,
      isDismissible: isDismissible ?? true,
      builder: (context, controller, offset) {
        return ListView(
          key: listViewKey,
          controller: controller,
          children: _listWidgets,
        );
      },
      anchors: anchors ?? [0, 0.5, 0.8],
    );
  }
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