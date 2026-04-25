import 'package:flutter/material.dart';

import '../../../../core/theme/m3_theme.dart';
import '../../../../core/theme/m3_theme_config.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.eventName, required this.onTap});

  final String eventName;
  final VoidCallback onTap;
  // TODO: イベント開催

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: m3ColorScheme.primaryContainer,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              style: TextStyle(
                color: m3ColorScheme.surfaceTint,
                fontSize: M3ThemeConfig.fontSize.large,
                fontWeight: FontWeight.bold,
              ),
              eventName,
            ),
          ),
        ),
      ),
    );
  }
}
