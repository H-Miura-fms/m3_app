import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/circle_util.dart';
import '../../../core/utils/result.dart';
import '../../../domain/model/circle_model.dart';
import '../../../provider/usecase/usecase_providers.dart';
import '../wish_list/wish_list_controller.dart';

part 'circle_list_controller.g.dart';

@riverpod
class CircleListController extends _$CircleListController {
  List<CircleModel> _allCircles = [];
  @override
  FutureOr<List<CircleModel>> build() async {
    state = const AsyncValue.loading();
    return _allCircles = await _fetchCircleInfoFromDB();
  }

  // リストを更新するためのメソッド
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchCircleInfoFromDB);
  }

  // 検索
  void search(String query) {
    if (query.isEmpty) {
      state = AsyncValue.data(_allCircles);
    } else {
      state = state.whenData(
        (circles) => [
          ..._allCircles.where(
            (e) =>
                e.name.contains(query) ||
                e.phonetic.contains(query) ||
                e.prText.contains(query) ||
                e.keywords.any(
                  (keyword) =>
                      keyword.text.contains(query) ||
                      keyword.phonetic.contains(query),
                ) ||
                CircleUtil.generateSpaceName(realSp: e.realSp, webSp: e.webSp)
                    .contains(query),
          ),
        ],
      );
    }
  }

  Future<void> updateFavorite(CircleModel circle) async {
    try {
      await _updateWishListDB(circle);
    } on Exception catch (_) {
      rethrow;
    }

    ref.invalidate(wishListControllerProvider);

    final newCircle = circle.copyWith(isFavorite: !circle.isFavorite!);
    state = state.whenData(
      (circles) => [...circles.map((e) => e.id == circle.id ? newCircle : e)],
    );
  }

  Future<void> _updateWishListDB(CircleModel circle) async {
    final addWishListUseCase = ref.read(addWishListUseCaseProvider);
    final deleteWishUseCase = ref.read(deleteWishUseCaseProvider);

    switch (circle.isFavorite!) {
      case true:
        final result = await deleteWishUseCase.call(circle.id);
        switch (result) {
          case Success<void, Exception>():
            break;
          case Failure<void, Exception>():
            throw result.exception;
        }
      case false:
        final result = await addWishListUseCase.call(circle);
        switch (result) {
          case Success<void, Exception>():
            break;
          case Failure<void, Exception>():
            throw result.exception;
        }
    }
  }

  Future<List<CircleModel>> _fetchCircleInfoFromDB() async {
    final useCase = ref.read(fetchCircleUseCaseProvider);
    final result = await useCase.call();

    switch (result) {
      case Success<List<CircleModel>, Exception>():
        return result.value;
      case Failure<List<CircleModel>, Exception>():
        throw result.exception;
    }
  }
}
