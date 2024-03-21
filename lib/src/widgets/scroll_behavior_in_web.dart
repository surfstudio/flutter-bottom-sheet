import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// For websites to work on the web and desktop
class ScrollBehaviorInWeb extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}
