import 'package:flutter/material.dart';

import '../../../../core/theme/m3_theme.dart';
import '../../../../core/theme/m3_theme_config.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });
  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // 角丸の半径を指定
          side: BorderSide(
            color: M3ThemeConfig.customColor.favoriteButton,
          ),
        ),
        elevation: 0,
        color: isFavorite
            ? M3ThemeConfig.customColor.favoriteButton
            : m3ColorScheme.onInverseSurface,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            isFavorite ? 'ウィッシュリストに追加済み' : 'ウィッシュリストに追加',
            style: TextStyle(fontSize: M3ThemeConfig.fontSize.normal),
          ),
        ),
      ),
    );
  }
}
