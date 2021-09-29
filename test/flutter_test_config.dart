import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

const _devicesWithTolerance = {
  Device.phone: 5.1,
  Device.iphone11: 3.4,
  Device.tabletPortrait: 1.0,
  Device.tabletLandscape: 1.0,
};

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
        () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      defaultDevices: _devicesWithTolerance.keys.toList(),
      enableRealShadows: true,
    ),
  );
}