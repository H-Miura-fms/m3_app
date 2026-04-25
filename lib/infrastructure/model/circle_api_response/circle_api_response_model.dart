import 'package:freezed_annotation/freezed_annotation.dart';

import '../dto/circle_model_dto.dart';

part 'circle_api_response_model.freezed.dart';
part 'circle_api_response_model.g.dart';

@freezed
abstract class CircleApiResponse with _$CircleApiResponse {
  const factory CircleApiResponse({
    required List<CircleModelDto> items,
  }) = _CircleApiResponse;

  factory CircleApiResponse.fromJson(Map<String, dynamic> json) =>
      _$CircleApiResponseFromJson(json);
}
