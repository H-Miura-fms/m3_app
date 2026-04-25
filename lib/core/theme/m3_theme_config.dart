// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'm3_theme.dart';

class FontSize {
  double get small => 10;
  double get normal => 14;
  double get large => 20;
}

class M3CustomColor {
  Color get favorite => const Color.fromARGB(255, 245, 70, 143);
  Color get favoriteButton => const Color.fromRGBO(255, 204, 0, 1);
  Color get overBudget => m3ColorScheme.error;
  Color get underBudget => m3ColorScheme.inversePrimary;
}

class M3CustomIcon {
  static SvgPicture youtube({double? width, double? height}) {
    return SvgPicture.asset(
      'assets/youtube_logo.svg',
      width: width,
      height: height,
      colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
    );
  }

  static SvgPicture x({double? width, double? height}) {
    return SvgPicture.asset(
      'assets/x_logo.svg',
      width: width,
      height: height,
    );
  }
}

class M3ThemeConfig {
  static FontSize get fontSize => FontSize();
  static M3CustomColor get customColor => M3CustomColor();
}
