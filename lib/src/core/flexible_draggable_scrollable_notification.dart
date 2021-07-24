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

/// A [Notification] related to the extent, which is the size, and scroll
/// offset, which is the position of the child list, of the
/// [FlexibleDraggableScrollableSheet].
///
/// [FlexibleDraggableScrollableSheet] widgets notify their ancestors when the
/// size of
/// the sheet changes. When the extent of the sheet changes via a drag,
/// this notification bubbles up through the tree, which means a given
/// [NotificationListener] will receive notifications for all descendant
/// [FlexibleDraggableScrollableSheet] widgets. To focus on notifications
/// from the
/// nearest FlexibleDraggableScrollableSheet descendant, check that the
/// [depth]
/// property of the notification is zero.
///
/// When an extent notification is received by a [NotificationListener], the
/// listener will already have completed build and layout, and it is therefore
/// too late for that widget to call [State.setState]. Any attempt to adjust the
/// build or layout based on an extent notification would result in a layout
/// that lagged one frame behind, which is a poor user experience. Extent
/// notifications are used primarily to drive animations. The [Scaffold] widget
/// listens for extent notifications and responds by driving animations for the
/// [FloatingActionButton] as the bottom sheet scrolls up.
class FlexibleDraggableScrollableNotification extends Notification
    with ViewportNotificationMixin {
  /// The current value of the extent, between [minExtent] and [maxExtent].
  final double extent;

  /// The minimum value of [extent], which is >= 0.
  final double minExtent;

  /// The maximum value of [extent].
  final double maxExtent;

  /// The initially requested value for [extent].
  final double initialExtent;

  /// The build context of the widget that fired this notification.
  ///
  /// This can be used to find the sheet's render objects to determine the size
  /// of the viewport, for instance. A listener can only assume this context
  /// is live when it first gets the notification.
  final BuildContext? context;

  /// Creates a notification that the extent of a
  /// [FlexibleDraggableScrollableSheet] has
  /// changed.
  ///
  /// All parameters are required. The [minExtent] must be >= 0. The [maxExtent]
  /// must be <= 1.0.  The [extent] must be between [minExtent] and [maxExtent].
  FlexibleDraggableScrollableNotification({
    required this.extent,
    required this.minExtent,
    required this.maxExtent,
    required this.initialExtent,
    this.context,
  })  : assert(0.0 <= minExtent),
        assert(maxExtent <= 1.0),
        assert(minExtent <= extent),
        assert(minExtent <= initialExtent),
        assert(extent <= maxExtent),
        assert(initialExtent <= maxExtent);

  @override
  void debugFillDescription(List<String> description) {
    super.debugFillDescription(description);
    description.add('minExtent: $minExtent, extent: $extent, '
        'maxExtent: $maxExtent, initialExtent: $initialExtent');
  }
}
