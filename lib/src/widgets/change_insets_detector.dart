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
  double? lastInsets;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newInsets = MediaQuery.of(context).viewInsets.bottom;
    final delta = lastInsets == null ? 0.0 : newInsets - lastInsets!;
    if (newInsets != lastInsets) {
      if (widget.handler != null) {
        widget.handler!.call(delta, newInsets);
      }
    }
    lastInsets = newInsets;
  }
}
