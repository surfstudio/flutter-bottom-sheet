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

/// A widget that can notify a descendent [InteractiveContainer]
/// that it should reset its position to the initial state.
///
/// The [Scaffold] uses this widget to notify a persistent bottom sheet that
/// the user has tapped back if the sheet has started to cover more of the body
/// than when at its initial position. This is important for users of assistive
/// technology, where dragging may be difficult to communicate.
class InteractiveContainerActuator extends StatelessWidget {
  /// This child's [InteractiveContainer] descendant will be reset
  /// when the [reset] method is applied to a context that includes it.
  ///
  /// Must not be null.
  final Widget child;

  final ResetNotifier _notifier = ResetNotifier();

  /// Creates a widget that can notify descendent
  /// [InteractiveContainer]s to reset to their initial position.
  ///
  /// The [child] parameter is required.
  InteractiveContainerActuator({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InheritedResetNotifier(
      notifier: _notifier,
      child: child,
    );
  }

  /// Notifies any descendant [InteractiveContainer] that it should
  /// reset to its initial position.
  ///
  /// Returns `true` if a [InteractiveContainerActuator] is available and
  /// some [InteractiveContainer] is listening for updates, `false`
  /// otherwise.
  static bool reset(BuildContext context) {
    final notifier =
        context.dependOnInheritedWidgetOfExactType<InheritedResetNotifier>();
    if (notifier == null) {
      return false;
    }
    return notifier.sendReset();
  }
}
