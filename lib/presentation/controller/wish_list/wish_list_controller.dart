import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/result.dart';
import '../../../domain/model/circle_wish_model.dart';
import '../../../provider/usecase/usecase_providers.dart';

part 'wish_list_controller.g.dart';

@riverpod
class WishListController extends _$WishListController {
  WishListController();

  @override
  FutureOr<List<CircleWishModel>> build() {
    state = const AsyncValue.loading();
    return _fetchWishList();
  }

  Future<void> updateWishList(CircleWishModel wish) async {
    final useCase = ref.read(updateWishListUseCaseProvider);
    final result = await useCase.call(wish);
    switch (result) {
      case Success<void, Exception>():
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(_fetchWishList);
      case Failure<void, Exception>():
        throw result.exception;
    }
  }

  Future<void> deleteWishList(CircleWishModel wish) async {
    final useCase = ref.read(deleteWishUseCaseProvider);
    final result = await useCase.call(wish.circleId);
    switch (result) {
      case Success<void, Exception>():
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(_fetchWishList);
      case Failure<void, Exception>():
        throw result.exception;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchWishList);
  }

  Future<List<CircleWishModel>> _fetchWishList() async {
    final useCase = ref.read(fetchWishListUseCaseProvider);
    final result = await useCase.call();
    switch (result) {
      case Success<List<CircleWishModel>, Exception>():
        return result.value;
      case Failure<List<CircleWishModel>, Exception>():
        throw result.exception;
    }
  }
}
