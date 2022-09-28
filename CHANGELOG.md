# Changelog

## [Unreleased, estimated N.N.N]

## 3.1.2
### Fixed
* Indentation rules trailing commas;
* Error with showFlexibleBottomSheet - DraggableScrollableController is not attached to a sheet;
### Added
* Added optional draggableScrollableController;

## 3.1.1
### Fixed
* Overflow error when swipe down with opened keyboard;
* Wrong behavior when open and close bottomsheet with opened keyboard;

## 3.1.0
### Added
* ability to set the barrier color;
### Changed
* Flutter 3 is supported;

## 3.0.0
### Fixed
* Absent scrolling in showStickyFlexibleBottomSheet when input was destroyed by cache area when keyboard was opened.
### Added 
* Ability to pass decorated when calling showFlexibleBottomSheet.
* Ability to set the height of the bottom sheet based on the content.
* Ability to set the bottom sheet color.

## 2.1.0
### Fixed
* Hole between keyboard and bottom sheet;
### Added
* keyboardBarrierColor parameter that sets the color for the space behind the keyboard;
* custom bottom sheet's animation duration;
### Changed
* ChangeInsetsDetector used BottomInsetObserver;

## 2.0.0
### Fixed
* LateInitializationError when bottom sheet appear with an open keyboard;
### Changed
* DraggableScrollableSheet from Flutter used as core;
* FlexibleDraggableScrollableWidgetBuilder uses ScrollController instead FlexibleDraggableScrollableSheetScrollController;
### Removed
* FlexibleScrollNotifier;

## 1.0.5

* Docs improvement.

## 1.0.4

* Fix double pop navigator(tnx Renesanse).

## 1.0.3

* Coverage integration.

## 1.0.2

* Useless classes has been removed
* Fix wrong behaviour when isCollapsible = true
* Added isDismissible property
* Migrate to AndroidX for example
* Fix some dirty code
* Fix extent counting

## 1.0.1

* Stable release

## 1.0.1-dev.2

* Remove animation listeners.

## 1.0.1-dev.1

* Apply new lint rules.

## 1.0.0

* Migrate this package to null safety.

## 0.0.1-dev.3

* Fix lint hints

## 0.0.1-dev.0

* Initial release
