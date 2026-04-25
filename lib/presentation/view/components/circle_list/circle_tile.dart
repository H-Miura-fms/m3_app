import 'package:flutter/material.dart';

import '../../../../core/theme/m3_theme.dart';
import '../../../../core/theme/m3_theme_config.dart';
import '../../../../core/utils/circle_util.dart';
import '../../../../domain/model/circle_model.dart';
import '../common/margin.dart';

class CircleTile extends StatelessWidget {
  const CircleTile({super.key, required this.circle, required this.onTap});

  final CircleModel circle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: m3ColorScheme.primaryContainer,
        child: Container(
          height: 85,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: CircleNameAndSpaceName(
                  circle: circle,
                ),
              ),
              Icon(
                (circle.isFavorite ?? false)
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 35,
                color: M3ThemeConfig.customColor.favorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleNameAndSpaceName extends StatelessWidget {
  const CircleNameAndSpaceName({super.key, required this.circle});

  final CircleModel circle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          CircleUtil.generateSpaceName(
            realSp: circle.realSp,
            webSp: circle.webSp,
          ),
          style: TextStyle(
            fontSize: M3ThemeConfig.fontSize.normal,
          ),
        ),
        const MarginVertical(5),
        Flexible(
          child: Text(
            circle.name,
            style: TextStyle(
              fontSize: M3ThemeConfig.fontSize.large,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
