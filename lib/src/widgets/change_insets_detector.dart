import 'package:bottom_inset_observer/bottom_inset_observer.dart';
import 'package:flutter/material.dart';

// ignore_for_file: library_private_types_in_public_api

/// Widget that calls [handler] when viewInsets.bottom changes
class ChangeInsetsDetector extends StatefulWidget {
  final Widget child;
  final BottomInsetChangeListener? handler;

  const ChangeInsetsDetector({
    required this.child,
    Key? key,
    this.handler,
  }) : super(key: key);

  @override
  _ChangeInsetsDetectorState createState() => _ChangeInsetsDetectorState();
}

class _ChangeInsetsDetectorState extends State<ChangeInsetsDetector> {
  final BottomInsetObserver _insetObserver = BottomInsetObserver();

  @override
  void initState() {
    super.initState();
    _insetObserver.addListener(_insetChangeHandler);
  }

  void _insetChangeHandler(BottomInsetChanges change) {
    widget.handler?.call(change);
  }

  @override
  void dispose() {
    _insetObserver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
