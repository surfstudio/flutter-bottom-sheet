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

/// A [ScrollController] suitable for use in a [ScrollableWidgetBuilder] created
/// by a [InteractiveSheet].
///
/// If a [InteractiveSheet] contains content that is exceeds
/// the height
/// of its container, this controller will allow the sheet to both be dragged to
/// fill the container and then scroll the child content.
///
/// See also:
///
///  * [InteractiveSheetScrollPosition], which manages the
/// positioning logic for
///    this controller.
///  * [PrimaryScrollController], which can be used to establish a
///    [FlexibleDraggableScrollableSheetScrollController] as the primary
/// controller for
///    descendants.
class InteractiveSheetScrollController extends ScrollController {
  final InteractiveContainerExtent extent;

  InteractiveSheetScrollController({
    required this.extent,
    double initialScrollOffset = 0.0,
    String? debugLabel,
  }) : super(
          debugLabel: debugLabel,
          initialScrollOffset: initialScrollOffset,
        );

  @override
  InteractiveSheetScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return InteractiveSheetScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      extent: extent,
    );
  }

  @override
  void debugFillDescription(List<String> description) {
    super.debugFillDescription(description);
    description.add('extent: $extent');
  }
}
