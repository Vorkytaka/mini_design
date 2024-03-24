import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that lock orientation of the UI with given [lockWith];
///
/// When this widget is disposed – unlock orientation to be any.
class OrientationLockerWidget extends StatefulWidget {
  final Widget child;
  final List<DeviceOrientation> lockWith;

  const OrientationLockerWidget({
    required this.child,
    required this.lockWith,
    super.key,
  });

  @override
  State<OrientationLockerWidget> createState() =>
      _OrientationLockerWidgetState();
}

class _OrientationLockerWidgetState extends State<OrientationLockerWidget> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(widget.lockWith);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
