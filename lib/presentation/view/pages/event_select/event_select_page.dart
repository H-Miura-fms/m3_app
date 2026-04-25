import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/routing_path_const.dart';
import '../../../../provider/common/shared_preference_provider.dart';
import '../../components/event_select/event_card.dart';

class EventSelectPage extends ConsumerWidget {
  const EventSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              EventCard(
                eventName: '2026春',
                onTap: () {
                  final isLocalAvailable = ref
                          .read(sharedPreferencesProvider)
                          .getBool('isLocalAvailable') ??
                      false;
                  if (isLocalAvailable) {
                    context.go(RoutingPathConst.circleList);
                  } else {
                    context.go(RoutingPathConst.fetchCircle);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
