import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/theme/m3_theme.dart';
import '../../../../core/theme/m3_theme_config.dart';

// ignore: avoid_classes_with_only_static_members
class MessageWidget {
  static void show(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: m3ColorScheme.primaryContainer,
      textColor: Colors.black,
      fontSize: M3ThemeConfig.fontSize.normal,
    );
  }
}
