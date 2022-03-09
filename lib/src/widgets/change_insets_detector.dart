import 'package:flutter/material.dart';

/// The signature of the method that provides [delta]
/// and [inset] for determining bottom inset status.
/// [delta] - value of delata previous inset and new.
/// [inset] - value of bottom insets.
typedef OnInsetsChange = void Function(double delta, double inset);

/// Widget that calls [handler] when viewInsets.bottom changes
class ChangeInsetsDetector extends StatefulWidget {
  final Widget child;
  final OnInsetsChange? handler;
  const ChangeInsetsDetector({
    required this.child,
    Key? key,
    this.handler,
  }) : super(key: key);

  @override
  _ChangeInsetsDetectorState createState() => _ChangeInsetsDetectorState();
}

class _ChangeInsetsDetectorState extends State<ChangeInsetsDetector> {
  late BottomInsetObserver _insetObserver;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    _insetObserver = BottomInsetObserver()..addListener(_insetChangeHandler);
  }

  @override
  void dispose() {
    _insetObserver.dispose();
    super.dispose();
  }

  void _insetChangeHandler(BottomInsetChanges change) {
    widget.handler?.call(change.delta, change.currentInset);
  }
}

typedef BottomInsetChangeListener = Function(BottomInsetChanges change);

/// Observer of bottom view inset changes usually changed by keyboard
class BottomInsetObserver extends WidgetsBindingObserver {
  final _changeListeners = <BottomInsetChangeListener>[];
  double? _currentInset;

  BottomInsetObserver() {
    _init();
  }

  /// Callback on changing metrics
  @override
  void didChangeMetrics() {
    _listener();
  }

  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _changeListeners.clear();
  }

  /// Add bottom inset listener
  void addListener(
    BottomInsetChangeListener onChange,
  ) {
    _changeListeners.add(onChange);
    if (_currentInset! > 0) {
      onChange(
        BottomInsetChanges(
          currentInset: _currentInset!,
          delta: 0,
        ),
      );
    }
  }

  void _init() {
    final instance = WidgetsBinding.instance;
    if (instance != null) {
      instance.addObserver(this);
      _currentInset =
          instance.window.viewInsets.bottom / instance.window.devicePixelRatio;
    }
  }

  /// Callculate changes in bottom insets
  void _listener() {
    if (WidgetsBinding.instance == null) return;
    final newInset = WidgetsBinding.instance!.window.viewInsets.bottom /
        WidgetsBinding.instance!.window.devicePixelRatio;
    final delta = newInset - (_currentInset ?? newInset);
    if (delta == 0) return;
    _onChange(
      BottomInsetChanges(
        currentInset: newInset,
        delta: delta,
      ),
    );
    _currentInset = newInset;
  }

  /// Call listeners on change insets
  void _onChange(BottomInsetChanges change) {
    for (final listener in _changeListeners) {
      listener(change);
    }
  }
}

/// Representation of changes in bottom view inset
/// [delta] difference in values between previous and new
/// [currentInset] current inset value
/// all values in physicals pixels
class BottomInsetChanges {
  final double delta;

  final double currentInset;

  const BottomInsetChanges({
    required this.delta,
    required this.currentInset,
  });
}
