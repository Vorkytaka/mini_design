import 'package:flutter/material.dart';

/// With this widget, if user somehow hide an keyboard, then focused node will be unfocused.
class KeyboardUnfocus extends StatefulWidget {
  final Widget child;

  const KeyboardUnfocus({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<KeyboardUnfocus> createState() => _KeyboardUnfocusState();
}

class _KeyboardUnfocusState extends State<KeyboardUnfocus> {
  double _prev = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    final curr = mediaQuery.viewInsets.bottom;
    if (_prev > 0 && curr < _prev) {
      FocusScope.of(context).unfocus();
    }
    _prev = curr;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// This widget give us ability to run some actions, when user hide keyboard.
class KeyboardHideAction extends StatefulWidget {
  final Widget child;
  final VoidCallback? onStartHide;
  final VoidCallback? onEndHide;

  const KeyboardHideAction({
    required this.child,
    Key? key,
    this.onStartHide,
    this.onEndHide,
  }) : super(key: key);

  @override
  State<KeyboardHideAction> createState() => _KeyboardHideActionState();
}

class _KeyboardHideActionState extends State<KeyboardHideAction> {
  double _prev = 0;
  bool _actionWasDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    final curr = mediaQuery.viewInsets.bottom;
    if (_prev > 0 && curr < _prev && !_actionWasDone) {
      widget.onStartHide?.call();
      _actionWasDone = true;
    }
    if (_prev > 0 && curr == 0) {
      widget.onEndHide?.call();
    }
    _prev = curr;
    if (_prev == 0) {
      _actionWasDone = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
