# Changelog

## [Unreleased]

## 2.1.0
### Fixed
* Fixed hole between keyboard and bottom sheet;
### Added
* keyboardBarrierColor parameter that sets the color for the space behind the keyboard;
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
