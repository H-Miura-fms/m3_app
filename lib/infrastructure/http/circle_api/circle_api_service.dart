import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../model/circle_api_response/circle_api_response_model.dart';

part 'circle_api_service.g.dart';

@RestApi()
// ignore: one_member_abstracts
abstract class CircleApiService {
  factory CircleApiService(Dio dio, {String baseUrl}) = _CircleApiService;

  @GET('/{event}/resources/circles.json')
  Future<CircleApiResponse> getLatestEventCircles(@Path('event') String event);
}
