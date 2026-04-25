import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/routing.dart';

final routerProvider = Provider<GoRouter>((_) => router);
