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
import 'package:flutter/material.dart' hide BottomSheet;

class InheritedResetNotifier extends InheritedNotifier<ResetNotifier> {
  /// Creates an [InheritedNotifier] that the
  /// [InteractiveSheet] will
  /// listen to for an indication that it should change its extent.
  ///
  /// The [child] and [notifier] properties must not be null.
  const InheritedResetNotifier({
    required Widget child,
    required ResetNotifier notifier,
    Key? key,
  }) : super(key: key, child: child, notifier: notifier);

  /// Specifies whether the [InteractiveSheet] should reset to
  /// its initial position.
  ///
  /// Returns true if the notifier requested a reset, false otherwise.
  static bool shouldReset(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<InheritedResetNotifier>();
    if (widget == null) {
      return false;
    }
    assert(widget is InheritedResetNotifier);
    final inheritedNotifier = widget;
    if (inheritedNotifier.notifier != null) {
      final wasCalled = inheritedNotifier.notifier!.wasCalled;
      inheritedNotifier.notifier!.wasCalled = false;
      return wasCalled;
    } else {
      return false;
    }
  }

  // use "!" because notifier is required in overload constructor
  bool sendReset() => notifier!.sendReset();
}
