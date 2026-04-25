import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider/infrastructure/dao_provider.dart';
import '../../../provider/infrastructure/http_service_providers.dart';
import '../../../provider/infrastructure/map_pdf_service_provider.dart';
import '../circle_repository.dart';
import '../map_pdf_repository.dart';
import '../wish_list_repository.dart';

final circleRepositoryProvider = Provider<CircleRepository>(
  (ref) => CircleRepository(
    ref.read(circleApiServiceProvider),
    ref.read(circleDaoProvider),
  ),
);

final wishListRepositoryProvider = Provider<WishListRepository>(
  (ref) => WishListRepository(
    ref.read(circleFavDaoProvider),
  ),
);

final mapPdfRepositoryProvider = Provider<MapPdfRepository>(
  (ref) => MapPdfRepository(
    ref.read(mapPdfServiceProvider),
  ),
);
