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

/// A container for a [Scrollable] that responds to drag gestures by resizing
/// the scrollable until a limit is reached, and then scrolling.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=Hgw819mL_78}
///
/// This widget can be dragged along the vertical axis between its
/// [minChildSize], which defaults to `0.25` and [maxChildSize], which defaults
/// to `1.0`. These sizes are percentages of the height of the parent container.
///
/// The widget coordinates resizing and scrolling of the widget returned by
/// builder as the user drags along the horizontal axis.
///
/// The widget will initially be displayed at its initialChildSize which
/// defaults to `0.5`, meaning half the height of its parent. Dragging will work
/// between the range of minChildSize and maxChildSize (as percentages of the
/// parent container's height) as long as the builder creates a widget which
/// uses the provided [ScrollController]. If the widget created by the
/// [ScrollableWidgetBuilder] does not use the provided [ScrollController], the
/// sheet will remain at the initialChildSize.
///
/// By default, the widget will expand its non-occupied area to fill available
/// space in the parent. If this is not desired, e.g. because the parent wants
/// to position sheet based on the space it is taking, the [expand] property
/// may be set to false.
///
/// {@tool sample}
///
/// This is a sample widget which shows a [ListView] that has 25 [ListTile]s.
/// It starts out as taking up half the body of the [Scaffold], and can be
/// dragged up to the full height of the scaffold or down to 25% of the height
/// of the scaffold. Upon reaching full height, the list contents will be
/// scrolled up or down, until they reach the top of the list again and the user
/// drags the sheet back down.
///
/// ```dart
/// class HomePage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: const Text('FlexibleDraggableScrollableSheet'),
///       ),
///       body: SizedBox.expand(
///         child: FlexibleDraggableScrollableSheet(
///         builder: (BuildContext context, ScrollController scrollController){
///             return Container(
///               color: Colors.blue[100],
///               child: ListView.builder(
///                 controller: scrollController,
///                 itemCount: 25,
///                 itemBuilder: (BuildContext context, int index) {
///                   return ListTile(title: Text('Item $index'));
///                 },
///               ),
///             );
///           },
///         ),
///       ),
///     );
///   }
/// }
/// ```
/// {@end-tool}
class FlexibleDraggableScrollableSheet extends StatefulWidget {
  /// The initial fractional value of the parent container's height to use when
  /// displaying the widget.
  ///
  /// The default value is `0.5`.
  final double initialChildSize;

  /// The minimum fractional value of the parent container's height to use when
  /// displaying the widget.
  ///
  /// The default value is `0.25`.
  final double minChildSize;

  /// The maximum fractional value of the parent container's height to use when
  /// displaying the widget.
  ///
  /// The default value is `1.0`.
  final double maxChildSize;

  /// Whether the widget should expand to fill the available space in its parent
  /// or not.
  ///
  /// In most cases, this should be true. However, in the case of a parent
  /// widget that will position this one based on its desired size (such as a
  /// [Center]), this should be set to false.
  ///
  /// The default value is true.
  final bool expand;

  /// The builder that creates a child to display in this widget, which will
  /// use the provided [ScrollController] to enable dragging and scrolling
  /// of the contents.
  final ScrollableWidgetBuilder builder;

  /// Creates a widget that can be dragged and scrolled in a single gesture.
  ///
  /// The [builder], [initialChildSize], [minChildSize], [maxChildSize] and
  /// [expand] parameters must not be null.
  const FlexibleDraggableScrollableSheet({
    required this.builder,
    Key? key,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 1.0,
    this.expand = true,
  })  : assert(minChildSize >= 0.0),
        assert(maxChildSize <= 1.0),
        assert(minChildSize <= initialChildSize),
        assert(initialChildSize <= maxChildSize),
        super(key: key);

  @override
  FlexibleDraggableScrollableSheetState createState() =>
      FlexibleDraggableScrollableSheetState();
}

class FlexibleDraggableScrollableSheetState
    extends State<FlexibleDraggableScrollableSheet> {
  late FlexibleDraggableScrollableSheetScrollController _scrollController;
  late FlexibleDraggableSheetExtent _extent;

  @override
  void initState() {
    super.initState();
    _extent = FlexibleDraggableSheetExtent(
      minExtent: widget.minChildSize,
      maxExtent: widget.maxChildSize,
      initialExtent: widget.initialChildSize,
      listener: _setExtent,
    );
    _scrollController =
        FlexibleDraggableScrollableSheetScrollController(extent: _extent);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (InheritedResetNotifier.shouldReset(context)) {
      // jumpTo can result in trying to replace semantics during build.
      // Just animate really fast.
      // Avoid doing it at all if the offset is already 0.0.
      if (_scrollController.offset != 0.0) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 1),
          curve: Curves.linear,
        );
      }
      _extent.resetExtent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _extent.availablePixels =
            widget.maxChildSize * constraints.biggest.height;
        final Widget sheet = FractionallySizedBox(
          heightFactor: _extent.currentExtent,
          alignment: Alignment.bottomCenter,
          child: widget.builder(context, _scrollController),
        );
        return widget.expand ? SizedBox.expand(child: sheet) : sheet;
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setExtent() {
    setState(() {
      // _extent has been updated when this is called.
    });
  }
}
