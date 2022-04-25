# Bottom Sheet

[![Build Status](https://shields.io/github/workflow/status/surfstudio/flutter-bottom-sheet/Analysis?logo=github&logoColor=white)](https://github.com/surfstudio/flutter-bottom-sheet)
[![Coverage Status](https://img.shields.io/codecov/c/github/surfstudio/flutter-bottom-sheet?logo=codecov&logoColor=white)](https://codecov.io/gh/surfstudio/flutter-bottom-sheet)
[![Pub Version](https://img.shields.io/pub/v/bottom_sheet?logo=dart&logoColor=white)](https://pub.dev/packages/bottom_sheet)
[![Pub Likes](https://badgen.net/pub/likes/bottom_sheet)](https://pub.dev/packages/bottom_sheet)
[![Pub popularity](https://badgen.net/pub/popularity/bottom_sheet)](https://pub.dev/packages/bottom_sheet/score)
![Flutter Platform](https://badgen.net/pub/flutter-platform/bottom_sheet)

This package is part of the [SurfGear](https://github.com/surfstudio/SurfGear) toolkit made by [Surf](https://surf.ru).

[![Bottom sheet](https://i.ibb.co/MZqkwTv/bottom-sheet.png)](https://github.com/surfstudio/SurfGear)

## About

Custom bottom sheet widget that can be resized in response to drag gestures and then scrolled.

## Description

Main classes:

1. [FlexibleBottomSheet](lib/src/flexible_bottom_sheet.dart)
2. [BottomSheetRoute and showing methods](lib/src/flexible_bottom_sheet_route.dart)

Flexible and scrollable bottom sheet.

All you have to do is call `showFlexibleBottomSheet()` and you'll get a popup that looks like a modal bottom sheet and can be resized by dragging it up and down and scrolled when expanded.

There are 2 types of BottomSheets:

1. BottomSheet
2. StickyBottomSheet

## Example
#### Simple BottomSheet

![](https://i.ibb.co/KKR0SDF/open-flexible-bottom-sheet.gif)

To show bottomSheet, use :

```dart
showFlexibleBottomSheet(
  minHeight: 0,
  initHeight: 0.5,
  maxHeight: 1,
  context: context,
  builder: _buildBottomSheet,
  anchors: [0, 0.5, 1],
  isSafeArea: true,
);

Widget _buildBottomSheet(
    BuildContext context,
    ScrollController scrollController,
    double bottomSheetOffset,
  ) {
    return Material(
        child: Container(
          child: ListView(
            controller: scrollController,
            ...
          ),
        ),
      );
  }
```

#### BottomSheet with height based on content

![](https://i.ibb.co/xmhkTQm/example-with-height-base-on-content.gif)

```dart
showFlexibleBottomSheet(
  minHeight: 0,
  initHeight: 0.8,
  maxHeight: 0.8,
  context: context,
  builder: _buildBottomSheet,
  isExpand: false,
);

Widget _buildBottomSheet(
    BuildContext context,
    ScrollController scrollController,
    double bottomSheetOffset,
  ) {
    return Material(
        child: Container(
          child: ListView(
              controller: scrollController,
              shrinkWrap: true,
              ...
          ),
        ),
      );
  }
```

#### Sticky BottomSheet

![](https://i.ibb.co/M7C1qtB/open-sticky-bottom-sheet.gif)

To show sticky BottomSheet, use:  
**You have to return SliverChildListDelegate from builder !!!**

```dart
showStickyFlexibleBottomSheet(
  minHeight: 0,
  initHeight: 0.5,
  maxHeight: 1,
  headerHeight: 200,
  context: context,
  backgroundColor: Colors.white,
  headerBuilder: (BuildContext context, double offset) {
    return Container(
      ...
    );
  },
  builder: (BuildContext context, double offset) {
    return SliverChildListDelegate(
      <Widget>[...],
    );
  },
  anchors: [0, 0.5, 1],
);
```

## Installation

Add `bottom_sheet` to your `pubspec.yaml` file:

```yaml
dependencies:
  bottom_sheet: $currentVersion$
```

<p>At this moment, the current version of <code>bottom_sheet</code> is <a href="https://pub.dev/packages/bottom_sheet"><img style="vertical-align:middle;" src="https://img.shields.io/pub/v/bottom_sheet.svg" alt="bottom_sheet version"></a>.</p>

## Changelog

All notable changes to this project will be documented in [this file](./CHANGELOG.md).

## Issues

To report your issues,  submit them directly in the [Issues](https://github.com/surfstudio/flutter-bottom-sheet/issues) section.

## Contribute

If you would like to contribute to the package (e.g. by improving the documentation, fixing a bug or adding a cool new feature), please read our [contribution guide](./CONTRIBUTING.md) first and send us your pull request.

Your PRs are always welcome.

## How to reach us

Please feel free to ask any questions about this package. Join our community chat on Telegram. We speak English and Russian.

[![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/SurfGear)

## License

[Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)
