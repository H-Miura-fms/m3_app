import '../../../core/utils/circle_util.dart';
import '../../../core/utils/result.dart';
import '../../../infrastructure/repository/circle_repository.dart';
import '../../../infrastructure/repository/wish_list_repository.dart';
import '../../model/circle_model.dart';
import '../../model/circle_wish_model.dart';

/**
 * ウィッシュリストに追加、サークルDBのお気に入りを更新
 */
class AddWishListUseCase {
  AddWishListUseCase(this._wishListRepository, this._circleRepository);
  final WishListRepository _wishListRepository;
  final CircleRepository _circleRepository;

  Future<Result<void, Exception>> call(CircleModel circle) async {
    try {
      final result = await _updateDB(circle);
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<void> _updateDB(CircleModel circle) async {
    final newWishModel = CircleWishModel(
      circleId: circle.id,
      name: circle.name,
      spaceName: CircleUtil.generateSpaceName(
        realSp: circle.realSp,
        webSp: circle.webSp,
      ),
      isFavorite: true,
      isDone: false,
      amount: 0,
      memo: '',
    );
    try {
      await _wishListRepository.addCircleFav(newWishModel);
      await _circleRepository.updateCircleFavorite(
        circleId: circle.id,
        isFav: true,
      );
    } on Exception catch (_) {
      rethrow;
    }
  }
}
