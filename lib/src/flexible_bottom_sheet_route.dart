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

// ignore_for_file: format-comment
import 'package:bottom_sheet/src/flexible_bottom_sheet.dart';
import 'package:flutter/material.dart';

const Duration _bottomSheetDuration = Duration(milliseconds: 500);

/// Shows a flexible bottom sheet.
///
/// [builder] - must return a scrollable widget and
/// you must to pass the scrollController provided by the builder to your scrollable widget.
/// [draggableScrollableController] that allow programmatically control bottom sheet.
/// [minHeight] - min height in fractional value for bottom sheet. e.g. 0.1.
/// [initHeight] - init height in fractional value for bottom sheet. e.g. 0.5.
/// [maxHeight] - init height in fractional value for bottom sheet. e.g. 0.5.
/// [isCollapsible] - will the bottom sheet collapse.
/// [isDismissible] - the bottom sheet will be dismissed when user taps on the scrim.
/// [isExpand] - should your bottom sheet expand. By default, [isExpand] is true,
/// which means that the bottom sheet will have the height you specify
/// ([initHeight] and [maxHeight]) regardless of the height of the content in it.
/// If [isExpand] is false, [maxHeight] and [initHeight] must be equal,
/// in which case the bottom sheet will calculate its height based on the content,
/// but no more than [maxHeight] and [initHeight].
/// [isModal] - if true, overlay background with dark color.
/// [anchors] - list of sizes in fractional value that the bottom sheet can accept.
/// [keyboardBarrierColor] - keyboard color.
/// [bottomSheetBorderRadius] - bottom sheet border radius.
/// [bottomSheetColor] - bottom sheet color.
/// [barrierColor] - barrier color.
/// [duration] - animation speed when opening bottom sheet.
/// [isSafeArea] - should the bottom sheet provide a SafeArea, false by default.
/// [decoration] - content decoration bottom sheet.
/// [useRootScaffold] - if true, add Scaffold widget on widget tree. Default true.
Future<T?> showFlexibleBottomSheet<T>({
  required BuildContext context,
  required FlexibleDraggableScrollableWidgetBuilder builder,
  DraggableScrollableController? draggableScrollableController,
  double? minHeight,
  double? initHeight,
  double? maxHeight,
  bool isCollapsible = true,
  bool isDismissible = true,
  bool isExpand = true,
  bool useRootNavigator = false,
  bool isModal = true,
  List<double>? anchors,
  Color? keyboardBarrierColor,
  Color? bottomSheetColor,
  BorderRadiusGeometry? bottomSheetBorderRadius,
  Color? barrierColor,
  Duration? duration,
  bool isSafeArea = false,
  BoxDecoration? decoration,
  bool useRootScaffold = true,
}) {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));
  assert(barrierColor == null || isModal);

  return Navigator.of(context, rootNavigator: useRootNavigator).push(
    _FlexibleBottomSheetRoute<T>(
      theme: Theme.of(context),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      draggableScrollableController: draggableScrollableController,
      minHeight: minHeight ?? 0,
      initHeight: initHeight ?? 0.5,
      maxHeight: maxHeight ?? 1,
      isCollapsible: isCollapsible,
      isDismissible: isDismissible,
      isExpand: isExpand,
      builder: builder,
      isModal: isModal,
      anchors: anchors,
      keyboardBarrierColor: keyboardBarrierColor,
      bottomSheetColor: bottomSheetColor,
      bottomSheetBorderRadius: bottomSheetBorderRadius,
      barrierBottomSheetColor: barrierColor,
      duration: duration,
      isSafeArea: isSafeArea,
      decoration: decoration,
      useRootScaffold: useRootScaffold,
    ),
  );
}

/// Shows a flexible bottom sheet with the ability to scroll content
/// even without a list.
///
/// [bodyBuilder] - content's builder.
/// [draggableScrollableController] that allow programmatically control bottom sheet.
/// [minHeight] - min height in fractional value for bottom sheet. e.g. 0.1.
/// [initHeight] - init height in fractional value for bottom sheet. e.g. 0.5.
/// [maxHeight] - init height in fractional value for bottom sheet. e.g. 0.5.
/// [isModal] - if true, overlay background with dark color.
/// [isCollapsible] - will the bottom sheet collapse.
/// [isDismissible] - the bottom sheet will be dismissed when user taps on the scrim.
/// [isExpand] - should your bottom sheet expand. By default, [isExpand] is true,
/// which means that the bottom sheet will have the height you specify
/// ([initHeight] and [maxHeight]) regardless of the height of the content in it.
/// If [isExpand] is false, [maxHeight] and [initHeight] must be equal,
/// in which case the bottom sheet will calculate its height based on the content,
/// but no more than [maxHeight] and [initHeight].
/// [anchors] - list of sizes in fractional value that the bottom sheet can accept.
/// [decoration] - content decoration bottom sheet.
/// [minHeaderHeight] - minimum head size.
/// [maxHeaderHeight] - maximum head size.
/// [headerHeight] - head size.
/// Set both [minHeaderHeight] and [maxHeaderHeight].
/// Set one ([maxHeaderHeight] or [headerHeight]).
/// [keyboardBarrierColor] - keyboard color.
/// [bottomSheetBorderRadius] - bottom sheet border radius.
/// [bottomSheetColor] - bottom sheet color.
/// [barrierColor] - barrier color, if you pass [barrierColor] - [isModal] must be true.
/// [duration] - animation speed when opening bottom sheet.
/// [isSafeArea] - should the bottom sheet provide a SafeArea, false by default.
/// [useRootScaffold] - if true, add Scaffold widget on widget tree. Default true.
Future<T?> showStickyFlexibleBottomSheet<T>({
  required BuildContext context,
  required FlexibleDraggableScrollableHeaderWidgetBuilder headerBuilder,
  required FlexibleDraggableScrollableWidgetBodyBuilder bodyBuilder,
  DraggableScrollableController? draggableScrollableController,
  double? minHeight,
  double? initHeight,
  double? maxHeight,
  bool isCollapsible = true,
  bool isDismissible = true,
  bool isExpand = true,
  bool useRootNavigator = false,
  bool isModal = true,
  List<double>? anchors,
  double? minHeaderHeight,
  double? maxHeaderHeight,
  double? headerHeight,
  Decoration? decoration,
  Color? keyboardBarrierColor,
  Color? bottomSheetColor,
  BorderRadiusGeometry? bottomSheetBorderRadius,
  Color? barrierColor,
  Duration? duration,
  bool isSafeArea = false,
  bool useRootScaffold = true,
}) {
  assert(maxHeaderHeight != null || headerHeight != null);
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));
  assert(barrierColor == null || isModal);

  return Navigator.of(context, rootNavigator: useRootNavigator).push(
    _FlexibleBottomSheetRoute<T>(
      theme: Theme.of(context),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      minHeight: minHeight ?? 0,
      initHeight: initHeight ?? 0.5,
      maxHeight: maxHeight ?? 1,
      isCollapsible: isCollapsible,
      isDismissible: isDismissible,
      draggableScrollableController: draggableScrollableController,
      isExpand: isExpand,
      bodyBuilder: bodyBuilder,
      headerBuilder: headerBuilder,
      isModal: isModal,
      anchors: anchors,
      minHeaderHeight: minHeaderHeight ?? headerHeight ?? maxHeaderHeight! / 2,
      maxHeaderHeight: maxHeaderHeight ?? headerHeight!,
      decoration: decoration,
      keyboardBarrierColor: keyboardBarrierColor,
      bottomSheetColor: bottomSheetColor,
      bottomSheetBorderRadius: bottomSheetBorderRadius,
      barrierBottomSheetColor: barrierColor,
      duration: duration,
      isSafeArea: isSafeArea,
      useRootScaffold: useRootScaffold,
    ),
  );
}

/// A modal route with flexible bottom sheet.
class _FlexibleBottomSheetRoute<T> extends PopupRoute<T> {
  final FlexibleDraggableScrollableWidgetBuilder? builder;
  final FlexibleDraggableScrollableHeaderWidgetBuilder? headerBuilder;
  final FlexibleDraggableScrollableWidgetBodyBuilder? bodyBuilder;
  final DraggableScrollableController? draggableScrollableController;
  final double minHeight;
  final double initHeight;
  final double maxHeight;
  final bool isCollapsible;
  final bool isDismissible;
  final bool isExpand;
  final bool isModal;
  final List<double>? anchors;
  final double? minHeaderHeight;
  final double? maxHeaderHeight;
  final Decoration? decoration;
  final ThemeData? theme;
  final Color? keyboardBarrierColor;
  final Color? bottomSheetColor;
  final BorderRadiusGeometry? bottomSheetBorderRadius;
  final Color? barrierBottomSheetColor;
  final Duration? duration;
  final bool isSafeArea;
  final bool useRootScaffold;

  @override
  final String? barrierLabel;

  @override
  Duration get transitionDuration => duration ?? _bottomSheetDuration;

  @override
  bool get barrierDismissible => isDismissible;

  @override
  Color? get barrierColor => isModal
      ? barrierBottomSheetColor ?? Colors.black54
      : const Color(0x00FFFFFF);

  late AnimationController _animationController;

  _FlexibleBottomSheetRoute({
    required this.minHeight,
    required this.initHeight,
    required this.maxHeight,
    required this.isCollapsible,
    required this.isDismissible,
    required this.isExpand,
    required this.isModal,
    required this.isSafeArea,
    required this.useRootScaffold,
    this.draggableScrollableController,
    this.builder,
    this.headerBuilder,
    this.bodyBuilder,
    this.theme,
    this.barrierLabel,
    this.anchors,
    this.minHeaderHeight,
    this.maxHeaderHeight,
    this.decoration,
    this.keyboardBarrierColor,
    this.bottomSheetColor,
    this.bottomSheetBorderRadius,
    this.barrierBottomSheetColor,
    this.duration,
    RouteSettings? settings,
  }) : super(settings: settings);

  @override
  AnimationController createAnimationController() {
    _animationController = AnimationController(
      duration: transitionDuration,
      debugLabel: 'FlexibleBottomSheet',
      vsync: navigator?.overlay as TickerProvider,
    );

    return _animationController;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: isCollapsible
          ? FlexibleBottomSheet.collapsible(
              initHeight: initHeight,
              maxHeight: maxHeight,
              builder: builder,
              headerBuilder: headerBuilder,
              bodyBuilder: bodyBuilder,
              isExpand: isExpand,
              animationController: _animationController,
              anchors: anchors,
              draggableScrollableController: draggableScrollableController,
              minHeaderHeight: minHeaderHeight,
              maxHeaderHeight: maxHeaderHeight,
              decoration: decoration,
              keyboardBarrierColor: keyboardBarrierColor,
              bottomSheetColor: bottomSheetColor,
              useRootScaffold: useRootScaffold,
              bottomSheetBorderRadius: bottomSheetBorderRadius,
            )
          : FlexibleBottomSheet(
              minHeight: minHeight,
              initHeight: initHeight,
              maxHeight: maxHeight,
              builder: builder,
              headerBuilder: headerBuilder,
              bodyBuilder: bodyBuilder,
              isExpand: isExpand,
              animationController: _animationController,
              draggableScrollableController: draggableScrollableController,
              anchors: anchors,
              minHeaderHeight: minHeaderHeight,
              maxHeaderHeight: maxHeaderHeight,
              decoration: decoration,
              keyboardBarrierColor: keyboardBarrierColor,
              bottomSheetColor: bottomSheetColor,
              useRootScaffold: useRootScaffold,
              bottomSheetBorderRadius: bottomSheetBorderRadius,
            ),
    );

    if (theme != null) {
      bottomSheet = Theme(data: theme!, child: bottomSheet);
    }

    return isSafeArea
        ? SafeArea(child: bottomSheet, bottom: false)
        : bottomSheet;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.ease;
    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: super.buildTransitions(
        context,
        animation,
        secondaryAnimation,
        child,
      ),
    );
  }
}
