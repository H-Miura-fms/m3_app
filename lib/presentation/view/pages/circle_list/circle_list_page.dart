import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:m3_app/core/router/routing_path_const.dart';
import 'package:m3_app/presentation/view/components/circle_list/circle_tile.dart';
import 'package:m3_app/presentation/view/components/circle_list/no_search_hit.dart';
import 'package:m3_app/presentation/view/components/circle_list/search_area.dart';
import 'package:m3_app/presentation/view/components/common/error_page.dart';
import 'package:m3_app/presentation/view/components/common/loading_page.dart';

import '../../../controller/circle_list/circle_list_controller.dart';

class CircleListPage extends HookConsumerWidget {
  const CircleListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();

    final circleListController = ref.watch(circleListControllerProvider);
    final notifier = ref.read(circleListControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        // TODO イベント名
        title: const Text('M3-2026春'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomScrollView(
          slivers: [
            SearchArea(
              controller: textEditingController,
              onChanged: notifier.search,
            ),
            circleListController.when(
              data: (data) {
                if (data.isEmpty) {
                  return const SliverFillRemaining(
                    child: NoSearchHitPage(),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final circle = data[index];
                      final a = circle.name;

                      return CircleTile(
                        circle: circle,
                        onTap: () {
                          context.push(
                            '${RoutingPathConst.circleList}/${RoutingPathConst.circleDetails}',
                            extra: circle,
                          );
                        },
                      );
                    },
                    childCount: data.length,
                  ),
                );
              },
              error: (error, stackTrace) {
                return SliverFillRemaining(
                  child: ErrorPage(
                    retryMethod: () async {
                      ref.invalidate(circleListControllerProvider);
                    },
                  ),
                );
              },
              loading: () {
                return const SliverFillRemaining(
                  child: LoadingPage(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
