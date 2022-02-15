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

// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// The signature of a method that provides a [BuildContext] and
/// [ScrollController] for building a widget that may overflow the draggable
/// [Axis] of the containing FlexibleDraggableScrollSheet.
///
/// Users should apply the [scrollController] to a [ScrollView] subclass, such
/// as a [SingleChildScrollView], [ListView] or [GridView], to have the whole
/// sheet be draggable.
///
/// [bottomSheetOffset] - fractional value of offset.
typedef FlexibleDraggableScrollableWidgetBuilder = Widget Function(
  BuildContext context,
  ScrollController scrollController,
  double bottomSheetOffset,
);

/// The signature of the method that provides [BuildContext]
/// and [bottomSheetOffset] for determining the position of the BottomSheet
/// relative to the upper border of the screen.
/// [bottomSheetOffset] - fractional value of offset.
typedef FlexibleDraggableScrollableHeaderWidgetBuilder = Widget Function(
  BuildContext context,
  double bottomSheetOffset,
);

/// The signature of a method that provides a [BuildContext]
/// and [bottomSheetOffset] for determining the position of the BottomSheet
/// relative to the upper border of the screen.
/// [bottomSheetOffset] - fractional value of offset.
typedef FlexibleDraggableScrollableWidgetBodyBuilder = SliverChildDelegate Function(
  BuildContext context,
  double bottomSheetOffset,
);
