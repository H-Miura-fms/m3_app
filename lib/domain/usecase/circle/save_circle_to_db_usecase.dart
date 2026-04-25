import '../../../core/utils/result.dart';

import '../../../infrastructure/repository/circle_repository.dart';

/**
 * APIから取得して、DBに保存
 */
class SaveCircleInfoToDBUseCase {
  SaveCircleInfoToDBUseCase(this._circleRepository);
  final CircleRepository _circleRepository;

  Future<Result<void, Exception>> call() async {
    try {
      final result = await _circleRepository.saveCircleInfoToDB();
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
