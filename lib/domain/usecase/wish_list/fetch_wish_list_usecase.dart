import '../../../core/utils/result.dart';
import '../../../infrastructure/repository/wish_list_repository.dart';
import '../../model/circle_wish_model.dart';

/**
 * ウィッシュリストを取得
 */
class FetchWishListUseCase {
  FetchWishListUseCase(this._wishListRepository);
  final WishListRepository _wishListRepository;

  Future<Result<List<CircleWishModel>, Exception>> call() async {
    try {
      final result = await _wishListRepository.getAllCircleFav();
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
