import '../../../core/utils/result.dart';
import '../../../infrastructure/repository/circle_repository.dart';
import '../../model/circle_model.dart';

/**
 * DBからサークル情報を取得
 */
class FetchCircleUseCase {
  FetchCircleUseCase(this._circleRepository);
  final CircleRepository _circleRepository;

  Future<Result<List<CircleModel>, Exception>> call() async {
    try {
      final result = await _circleRepository.fetchCircleInfoFromDB();
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
