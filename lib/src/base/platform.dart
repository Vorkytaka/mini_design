import 'dart:io';

import 'package:flutter/services.dart';

extension PlatformUtils on Platform {
  bool get isDesktop =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  bool get isMobile =>
      Platform.isAndroid || Platform.isIOS || Platform.isFuchsia;
}

extension TargetPlatformUtils on TargetPlatform {
  bool get isDesktop =>
      this == TargetPlatform.windows ||
      this == TargetPlatform.linux ||
      this == TargetPlatform.macOS;

  bool get isMobile =>
      this == TargetPlatform.android ||
      this == TargetPlatform.iOS ||
      this == TargetPlatform.fuchsia;
}
