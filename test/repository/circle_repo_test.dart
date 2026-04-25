import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:m3_app/domain/model/circle_model.dart';
import 'package:m3_app/infrastructure/http/circle_api/circle_api_service.dart';
import 'package:m3_app/infrastructure/local/dao/circle_dao.dart';
import 'package:m3_app/infrastructure/local/db/circle_database.dart';
import 'package:m3_app/infrastructure/model/circle_api_response/circle_api_response_model.dart';
import 'package:m3_app/infrastructure/model/dto/circle_model_dto.dart';
import 'package:m3_app/infrastructure/repository/circle_repository.dart';
import 'package:m3_app/provider/infrastructure/dao_provider.dart';
import 'package:m3_app/provider/infrastructure/http_service_providers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'circle_repo_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CircleApiService>()])
void main() {
  late ProviderContainer container;
  late CircleInfoDao dao;
  late MockCircleApiService mockApiService;
  late CircleRepository repository;

  final db = CircleDatabase.memory();
  ProviderContainer createContainer() => ProviderContainer(
        overrides: [
          circleDaoProvider.overrideWithValue(CircleInfoDao(db)),
          circleApiServiceProvider.overrideWithValue(mockApiService),
        ],
      );

  setUp(() {
    mockApiService = MockCircleApiService();
    container = createContainer();
    dao = container.read(circleDaoProvider);
    repository = CircleRepository(mockApiService, dao);

    // getLatestEventCirclesメソッドのスタブを設定
    when(mockApiService.getLatestEventCircles('2024a')).thenAnswer(
      (_) async => const CircleApiResponse(
        items: [
          CircleModelDto(
            id: 1,
            name: 'name',
            phonetic: 'phonetic',
            genre: 'genre',
            spaceSize: 1,
            adult: false,
            prText: 'prText',
            links: SnsLinksModel(
              twitter: SocialLink(text: 'twitter', url: 'twitter'),
            ),
            keywords: [
              KeywordModel(text: 'text', phonetic: 'phonetic'),
            ],
            area: 'A',
            number: '01',
          ),
        ],
      ),
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('repository test', () {
    test('response to db', () async {
      await repository.saveCircleInfoToDB();

      final data = await dao.getAllCircle();

      // api呼び出しがされているか
      verify(mockApiService.getLatestEventCircles('2024a')).called(1);

      expect(data, isA<List<CircleModel>>());
      expect(data.length, 1);
      expect(data[0].name, 'name');
    });
  });
}
