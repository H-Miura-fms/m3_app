import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/usecase/circle/fetch_circle_from_id_usecase.dart';
import '../../domain/usecase/circle/fetch_circle_usecase.dart';
import '../../domain/usecase/circle/save_circle_to_db_usecase.dart';
import '../../domain/usecase/map_pdf/get_map_pdf_usecase.dart';
import '../../domain/usecase/wish_list/add_wish_list_usecase.dart';
import '../../domain/usecase/wish_list/delete_wish_usecase.dart';
import '../../domain/usecase/wish_list/fetch_wish_list_usecase.dart';
import '../../domain/usecase/wish_list/update_wish_list_usecase.dart';
import '../../infrastructure/repository/provider/repository_providers.dart';

final Provider<FetchCircleUseCase> fetchCircleUseCaseProvider =
    Provider((ref) => FetchCircleUseCase(ref.read(circleRepositoryProvider)));

final Provider<FetchCircleFromIdUseCase> fetchCircleFromIdUseCaseProvider =
    Provider(
  (ref) => FetchCircleFromIdUseCase(ref.read(circleRepositoryProvider)),
);

final Provider<SaveCircleInfoToDBUseCase> saveCircleUseCaseProvider = Provider(
  (ref) => SaveCircleInfoToDBUseCase(ref.read(circleRepositoryProvider)),
);

final Provider<FetchWishListUseCase> fetchWishListUseCaseProvider = Provider(
  (ref) => FetchWishListUseCase(
    ref.read(wishListRepositoryProvider),
  ),
);

final Provider<AddWishListUseCase> addWishListUseCaseProvider = Provider(
  (ref) => AddWishListUseCase(
    ref.read(wishListRepositoryProvider),
    ref.read(circleRepositoryProvider),
  ),
);

final Provider<DeleteWishUseCase> deleteWishUseCaseProvider = Provider(
  (ref) => DeleteWishUseCase(
    ref.read(wishListRepositoryProvider),
    ref.read(circleRepositoryProvider),
  ),
);

final Provider<UpdateWishListUseCase> updateWishListUseCaseProvider = Provider(
  (ref) => UpdateWishListUseCase(
    ref.read(wishListRepositoryProvider),
  ),
);

final Provider<GetMapPdfUseCase> getMapPdfUseCaseProvider = Provider(
  (ref) => GetMapPdfUseCase(
    ref.read(mapPdfRepositoryProvider),
  ),
);
