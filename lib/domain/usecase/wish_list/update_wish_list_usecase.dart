import 'package:m3_app/domain/model/circle_wish_model.dart';

import '../../../core/utils/result.dart';
import '../../../infrastructure/repository/wish_list_repository.dart';

/**
 * wishListの更新
 */
class UpdateWishListUseCase {
  UpdateWishListUseCase(this._wishListRepository);
  final WishListRepository _wishListRepository;

  Future<Result<void, Exception>> call(CircleWishModel wish) async {
    try {
      final result = await _wishListRepository.updateCircleFav(wish);
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
