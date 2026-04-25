import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../infrastructure/local/db/circle_database.dart';

final databaseProvider = Provider<CircleDatabase>((ref) => CircleDatabase());
