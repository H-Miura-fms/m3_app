import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/model/circle_model.dart';
import '../../presentation/view/components/common/scaffold_wish_bottom_nav_bar.dart';
import '../../presentation/view/pages/circle_list/circle_detail_page.dart';
import '../../presentation/view/pages/circle_list/circle_list_page.dart';
import '../../presentation/view/pages/event_select/circle_fetch_page.dart';
import '../../presentation/view/pages/event_select/event_select_page.dart';
import '../../presentation/view/pages/map/map_page.dart';
import '../../presentation/view/pages/wish_list/wish_list_page.dart';
import 'routing_path_const.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
// final _sectionNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RoutingPathConst.home,
  routes: <RouteBase>[
    // ホーム(イベント選択画面)
    GoRoute(
      path: RoutingPathConst.home,
      builder: (BuildContext context, GoRouterState state) {
        return const EventSelectPage();
      },
    ),
    GoRoute(
      path: RoutingPathConst.fetchCircle,
      builder: (context, state) {
        return const CircleFetchPage();
      },
    ),
    // ボトムナビゲーションバー
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithBottomNavBar(
          navigationShell: navigationShell,
        );
      },
      branches: [
        // サークルリスト
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: RoutingPathConst.circleList,
              builder: (context, state) => const CircleListPage(),
              routes: <RouteBase>[
                GoRoute(
                  path: RoutingPathConst.circleDetails,
                  builder: (context, state) {
                    return CircleDetailPage(
                      circle: state.extra! as CircleModel,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        // ウィッシュリスト
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: RoutingPathConst.wishList,
              builder: (context, state) => const WishListPage(),
              routes: [
                GoRoute(
                  path: RoutingPathConst.circleDetails,
                  builder: (context, state) {
                    return CircleDetailPage(
                      circle: state.extra! as CircleModel,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        // マップ
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: RoutingPathConst.map,
              builder: (context, state) => const CircleMapPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
