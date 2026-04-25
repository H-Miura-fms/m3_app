import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infrastructure/local/dao/circle_dao.dart';
import '../../infrastructure/local/dao/circle_fav_dao.dart';
import 'database_provider.dart';

final circleDaoProvider =
    Provider<CircleInfoDao>((ref) => CircleInfoDao(ref.read(databaseProvider)));

final circleFavDaoProvider =
    Provider<CircleFavDao>((ref) => CircleFavDao(ref.read(databaseProvider)));
