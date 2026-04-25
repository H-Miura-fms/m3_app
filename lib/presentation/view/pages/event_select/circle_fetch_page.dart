import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/routing_path_const.dart';
import '../../../controller/circle_db/circle_db_controller.dart';
import '../../components/common/margin.dart';

class CircleFetchPage extends ConsumerWidget {
  const CircleFetchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final circleDBController = ref.watch(circleDBControllerProvider);
    return Scaffold(
      body: Center(
        child: circleDBController.when(
          data: (data) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('success'),
                  const MarginVertical(10),
                  ElevatedButton(
                    onPressed: () {
                      context.go(RoutingPathConst.circleList);
                    },
                    child: const Text('次へ'),
                  ),
                ],
              ),
            );
          },
          error: (error, stack) {
            return Text('Error: $error');
          },
          loading: () {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('データ取得中'),
                  MarginVertical(10),
                  CircularProgressIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
