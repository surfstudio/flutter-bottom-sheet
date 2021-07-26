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

import 'package:bottom_sheet/src/core/core.dart';
import 'package:flutter/material.dart';

/// Manages state between [InteractiveContainerState],
/// [InteractiveContainerScrollController], and
/// [InteractiveContainerScrollPosition].
///
/// The State knows the pixels available along the axis the widget wants to
/// scroll, but expects to get a fraction of those pixels to render the sheet.
///
///The ScrollPosition knows the number of pixels a user wants to move the sheet.
///
/// The [currentExtent] will never be null.
/// The [availablePixels] will never be null, but may be `double.infinity`.
class InteractiveContainerExtent {
  final double minExtent;
  final double maxExtent;
  final double initialExtent;
  final ValueNotifier<double> _currentExtent;
  double availablePixels;

  bool get isAtMin => minExtent >= _currentExtent.value;

  bool get isAtMax => maxExtent <= _currentExtent.value;

  set currentExtent(double value) =>
      _currentExtent.value = value.clamp(minExtent, maxExtent);

  double get currentExtent => _currentExtent.value;

  double get additionalMinExtent => isAtMin ? 0.0 : 1.0;

  double get additionalMaxExtent => isAtMax ? 0.0 : 1.0;

  InteractiveContainerExtent({
    required this.minExtent,
    required this.maxExtent,
    required this.initialExtent,
    required VoidCallback listener,
  })  : assert(minExtent >= 0),
        assert(maxExtent <= 1),
        assert(minExtent <= initialExtent),
        assert(initialExtent <= maxExtent),
        _currentExtent = ValueNotifier<double>(initialExtent)
          ..addListener(listener),
        availablePixels = double.infinity;

  /// The scroll position gets inputs in terms of pixels, but the extent is
  /// expected to be expressed as a number between 0..1.
  void addPixelDelta(double delta, BuildContext? context) {
    if (availablePixels == 0) {
      return;
    }
    currentExtent += delta / availablePixels * maxExtent;
    InteractiveContainerNotification(
      minExtent: minExtent,
      maxExtent: maxExtent,
      extent: currentExtent,
      initialExtent: initialExtent,
      context: context,
    ).dispatch(context);
  }

  void resetExtent() {
    _currentExtent.value = initialExtent;
  }
}
