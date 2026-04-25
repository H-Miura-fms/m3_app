import '../../domain/model/circle_wish_model.dart';
import '../local/dao/circle_fav_dao.dart';

class WishListRepository {
  const WishListRepository(this._dao);
  final CircleFavDao _dao;

  Future<void> addCircleFav(CircleWishModel wish) async {
    try {
      await _dao.addCircleFav(wish: wish);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> deleteCircleFav(int circleId) async {
    try {
      await _dao.deleteCircleFav(circleId: circleId);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<List<CircleWishModel>> getAllCircleFav() async {
    try {
      final data = await _dao.getAllCircleFav();

      return data;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> updateCircleFav(CircleWishModel wish) async {
    try {
      await _dao.updateCircleFav(wish: wish);
    } on Exception catch (_) {
      rethrow;
    }
  }
}
