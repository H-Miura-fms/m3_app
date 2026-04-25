import '../../../core/utils/result.dart';
import '../../../infrastructure/repository/circle_repository.dart';
import '../../model/circle_model.dart';

class FetchCircleFromIdUseCase {
  FetchCircleFromIdUseCase(this._circleRepository);
  final CircleRepository _circleRepository;

  Future<Result<CircleModel, Exception>> call(int circleId) async {
    try {
      final result = await _circleRepository.fetchCircleFromId(circleId);
      return Success(result);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
