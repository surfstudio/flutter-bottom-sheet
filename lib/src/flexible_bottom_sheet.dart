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
import 'package:bottom_sheet/src/flexible_bottom_sheet_header_delegate.dart';
import 'package:bottom_sheet/src/widgets/change_insets_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
typedef FlexibleDraggableScrollableWidgetBodyBuilder = SliverChildDelegate
    Function(
  BuildContext context,
  double bottomSheetOffset,
);

/// Flexible and scrollable bottom sheet.
///
/// This bottom sheet resizing between min and max size, and when size become
/// max start scrolling content. Reduction size available when content
/// scrolled to 0 offset.
///
/// [minHeight], [maxHeight] are limits of
/// bounds this widget. For example:
/// - you can set  [maxHeight] to 1;
/// - you can set [minHeight] to 0.5;
///
/// [isCollapsible] make possible collapse widget and remove from the screen,
/// but you must be carefully to use it, set it to true only if you show this
/// widget with like showFlexibleBottomSheet() case, because it will be removed
/// by Navigator.pop(). If you set [isCollapsible] true, [minHeight]
/// must be 0.
///
/// The [animationController] that controls the bottom sheet's entrance and
/// exit animations.
/// The FlexibleBottomSheet widget will manipulate the position of this
/// animation, it is not just a passive observer.
///
/// [initHeight] - relevant height for init bottom sheet
///
/// [keyboardBarrierColor] - color for the space behind the keyboard
///
/// [isExpand] - should your bottom sheet expand. By default, [isExpand] is true,
/// which means that the bottom sheet will have the height you specify
/// ([initHeight] and [maxHeight]) regardless of the height of the content in it.
/// If [isExpand] is false, [maxHeight] and [initHeight] must be equal,
/// in which case the bottom sheet will calculate its height based on the content,
/// but no more than [maxHeight] and [initHeight]. [anchors] in this case must be null.
/// ShrinkWrap content widget must be true.
///
/// [bottomSheetColor] - bottom sheet color. If you want to make rounded edges,
/// pass a [Colors.transparent] here, and set the color and border radius of
/// the bottom sheet in the [decoration].
class FlexibleBottomSheet extends StatefulWidget {
  final double minHeight;
  final double initHeight;
  final double maxHeight;
  final FlexibleDraggableScrollableWidgetBuilder? builder;
  final FlexibleDraggableScrollableHeaderWidgetBuilder? headerBuilder;
  final FlexibleDraggableScrollableWidgetBodyBuilder? bodyBuilder;
  final bool isCollapsible;
  final bool isExpand;
  final AnimationController? animationController;
  final List<double>? anchors;
  final double? minHeaderHeight;
  final double? maxHeaderHeight;
  final Decoration? decoration;
  final VoidCallback? onDismiss;
  final Color? keyboardBarrierColor;
  final Color? bottomSheetColor;

  FlexibleBottomSheet({
    Key? key,
    this.minHeight = 0,
    this.initHeight = 0.5,
    this.maxHeight = 1,
    this.builder,
    this.headerBuilder,
    this.bodyBuilder,
    this.isCollapsible = false,
    this.isExpand = true,
    this.animationController,
    this.anchors,
    this.minHeaderHeight,
    this.maxHeaderHeight,
    this.decoration,
    this.onDismiss,
    this.keyboardBarrierColor,
    this.bottomSheetColor,
  })  : assert(minHeight >= 0 && minHeight <= 1),
        assert(maxHeight > 0 && maxHeight <= 1),
        assert(maxHeight > minHeight),
        assert(!isCollapsible || minHeight == 0),
        assert(anchors == null || !anchors.any((anchor) => anchor > maxHeight)),
        assert(anchors == null || !anchors.any((anchor) => anchor < minHeight)),
        assert(isExpand == true || maxHeight == initHeight && anchors == null),
        super(key: key);

  FlexibleBottomSheet.collapsible({
    Key? key,
    double initHeight = 0.5,
    double maxHeight = 1,
    FlexibleDraggableScrollableWidgetBuilder? builder,
    FlexibleDraggableScrollableHeaderWidgetBuilder? headerBuilder,
    FlexibleDraggableScrollableWidgetBodyBuilder? bodyBuilder,
    bool isExpand = true,
    AnimationController? animationController,
    List<double>? anchors,
    double? minHeaderHeight,
    double? maxHeaderHeight,
    Decoration? decoration,
    Color? keyboardBarrierColor,
    Color? bottomSheetColor,
  }) : this(
          key: key,
          maxHeight: maxHeight,
          builder: builder,
          headerBuilder: headerBuilder,
          bodyBuilder: bodyBuilder,
          minHeight: 0,
          initHeight: initHeight,
          isCollapsible: true,
          isExpand: isExpand,
          animationController: animationController,
          anchors: anchors,
          minHeaderHeight: minHeaderHeight,
          maxHeaderHeight: maxHeaderHeight,
          decoration: decoration,
          keyboardBarrierColor: keyboardBarrierColor,
          bottomSheetColor: bottomSheetColor,
        );

  @override
  _FlexibleBottomSheetState createState() => _FlexibleBottomSheetState();
}

class _FlexibleBottomSheetState extends State<FlexibleBottomSheet> {
  final _controller = DraggableScrollableController();

  late final WidgetsBinding _widgetBinding;
  late double _initialChildSize = widget.initHeight;
  late double _currentMaxChildSize = widget.maxHeight;

  bool _isClosing = false;
  bool _isAnimatingToMaxHeight = false;

  @override
  void initState() {
    super.initState();
    _widgetBinding = WidgetsBinding.instance;
    widget.animationController?.addStatusListener(_animationStatusListener);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: _scrolling,
      child: DraggableScrollableSheet(
        maxChildSize: _currentMaxChildSize,
        minChildSize: widget.minHeight,
        initialChildSize: _initialChildSize,
        snap: widget.anchors != null,
        controller: _controller,
        snapSizes: widget.anchors,
        expand: widget.isExpand,
        builder: (
          context,
          controller,
        ) {
          return ChangeInsetsDetector(
            handler: (change) {
              final inset = change.currentInset;
              final delta = change.delta;

              if (delta > 0 && !_isClosing) {
                _animateToMaxHeight();
                _widgetBinding.addPostFrameCallback(
                  (_) {
                    _animateToFocused(controller);
                  },
                );
              }
              // checking for openness of the keyboard before opening the sheet
              if (delta == 0 && inset > 0) {
                _widgetBinding.addPostFrameCallback(
                  (_) {
                    setState(
                      () {
                        _initialChildSize = widget.maxHeight;
                      },
                    );
                  },
                );
              }
            },
            child: Scaffold(
              backgroundColor: widget.bottomSheetColor ??
                  Theme.of(context).bottomSheetTheme.backgroundColor ??
                  Theme.of(context).backgroundColor,
              body: _Content(
                builder: widget.builder,
                decoration: widget.decoration,
                bodyBuilder: widget.bodyBuilder,
                headerBuilder: widget.headerBuilder,
                minHeaderHeight: widget.minHeaderHeight,
                maxHeaderHeight: widget.maxHeaderHeight,
                currentExtent: _controller.isAttached
                    ? _controller.size
                    : widget.initHeight,
                scrollController: controller,
                cacheExtent: _calculateCacheExtent(
                  MediaQuery.of(context).viewInsets.bottom,
                ),
                getContentHeight:
                    !widget.isExpand ? _changeInitAndMaxHeight : null,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.animationController?.removeStatusListener(_animationStatusListener);
    super.dispose();
  }

  // Method will be called when scrolling.
  bool _scrolling(DraggableScrollableNotification notification) {
    if (_isClosing) return false;

    _initialChildSize = notification.extent;

    _checkNeedCloseBottomSheet(notification.extent);

    return false;
  }

  // Make bottom sheet max height.
  void _animateToMaxHeight() {
    final currPosition = _controller.size;
    if (currPosition != widget.maxHeight && !_isAnimatingToMaxHeight) {
      _isAnimatingToMaxHeight = true;
      _controller
          .animateTo(
            widget.maxHeight,
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
          )
          .whenComplete(
            () => _isAnimatingToMaxHeight = false,
          );
    }
  }

  // Scroll to focused widget.
  void _animateToFocused(ScrollController controller) {
    if (FocusManager.instance.primaryFocus == null || _isClosing) return;

    _widgetBinding.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      final widgetHeight = FocusManager.instance.primaryFocus!.size.height;
      final widgetOffset = FocusManager.instance.primaryFocus!.offset.dy;
      final screenHeight = MediaQuery.of(context).size.height;

      final targetWidgetOffset =
          screenHeight - keyboardHeight - widgetHeight - 20;
      final valueToScroll = widgetOffset - targetWidgetOffset;
      final currentOffset = controller.offset;
      if (valueToScroll > 0) {
        controller.animateTo(
          currentOffset + valueToScroll,
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
    });
  }

  // Checking if the bottom sheet needs to be closed.
  void _checkNeedCloseBottomSheet(double extent) {
    if (widget.isCollapsible && !_isClosing) {
      if (extent - widget.minHeight <= 0.005) {
        _isClosing = true;
        _dismiss();
      }
    }
  }

  // Method that listens for changing AnimationStatus, to track the closing of
  // the bottom sheet by clicking above it.
  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.reverse ||
        status == AnimationStatus.dismissed) {
      _isClosing = true;
    }
  }

  void _dismiss() {
    if (widget.isCollapsible) {
      if (widget.onDismiss != null) widget.onDismiss!();
      Navigator.maybePop(context);
    }
  }

  void _changeInitAndMaxHeight(double height) {
    if (!widget.isExpand) {
      final screenHeight = MediaQuery.of(context).size.height;

      final fractionalValue = height / screenHeight;
      if (fractionalValue < _currentMaxChildSize) {
        setState(
          () {
            _initialChildSize = fractionalValue;
            _currentMaxChildSize = fractionalValue;
          },
        );
      }
    }
  }

  double _calculateCacheExtent(double bottomInset) {
    const defaultExtent = RenderAbstractViewport.defaultCacheExtent;
    if (bottomInset > defaultExtent) {
      return bottomInset;
    } else {
      return defaultExtent;
    }
  }
}

/// Content for [FlexibleBottomSheet].
class _Content extends StatefulWidget {
  final FlexibleDraggableScrollableWidgetBuilder? builder;
  final Decoration? decoration;
  final FlexibleDraggableScrollableHeaderWidgetBuilder? headerBuilder;
  final FlexibleDraggableScrollableWidgetBodyBuilder? bodyBuilder;
  final double? minHeaderHeight;
  final double? maxHeaderHeight;
  final double currentExtent;
  final ScrollController scrollController;
  final Function(double)? getContentHeight;
  final double cacheExtent;

  const _Content({
    required this.currentExtent,
    required this.scrollController,
    required this.cacheExtent,
    this.builder,
    this.decoration,
    this.headerBuilder,
    this.bodyBuilder,
    this.minHeaderHeight,
    this.maxHeaderHeight,
    this.getContentHeight,
    Key? key,
  }) : super(key: key);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final _contentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.getContentHeight != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          final renderContent =
              _contentKey.currentContext!.findRenderObject() as RenderBox;
          widget.getContentHeight!(renderContent.size.height);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return Material(
        type: MaterialType.transparency,
        child: DecoratedBox(
          decoration: widget.decoration ?? const BoxDecoration(),
          child: SizedBox(
            key: _contentKey,
            child: widget.builder!(
              context,
              widget.scrollController,
              widget.currentExtent,
            ),
          ),
        ),
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: DecoratedBox(
        decoration: widget.decoration ?? const BoxDecoration(),
        child: CustomScrollView(
          cacheExtent: widget.cacheExtent,
          key: _contentKey,
          controller: widget.scrollController,
          slivers: <Widget>[
            if (widget.headerBuilder != null)
              SliverPersistentHeader(
                pinned: true,
                delegate: FlexibleBottomSheetHeaderDelegate(
                  minHeight: widget.minHeaderHeight ?? 0.0,
                  maxHeight: widget.maxHeaderHeight ?? 1.0,
                  child: widget.headerBuilder!(context, widget.currentExtent),
                ),
              ),
            if (widget.bodyBuilder != null)
              SliverList(
                delegate: widget.bodyBuilder!(
                  context,
                  widget.currentExtent,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
