import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:m3_app/core/utils/result.dart';
import 'package:m3_app/domain/model/circle_model.dart';
import 'package:m3_app/domain/usecase/circle/fetch_circle_usecase.dart';
import 'package:m3_app/infrastructure/repository/circle_repository.dart';
import 'package:m3_app/infrastructure/repository/provider/repository_providers.dart';
import 'package:m3_app/provider/usecase/usecase_providers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'circle_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CircleRepository>()])
void main() {
  late ProviderContainer container;
  late MockCircleRepository mockCircleRepository;

  setUp(() {
    mockCircleRepository = MockCircleRepository();
    container = ProviderContainer(
      overrides: [
        circleRepositoryProvider.overrideWithValue(mockCircleRepository),
        fetchCircleUseCaseProvider.overrideWithValue(
          FetchCircleUseCase(mockCircleRepository),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('useCase test', () {
    test('fetchCircleInfoFromDB正常系', () async {
      // Arrange
      when(mockCircleRepository.fetchCircleInfoFromDB()).thenAnswer(
        (_) async => [
          const CircleModel(
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
            realSp: RealSpModel(area: 'A', no: '01'),
          ),
        ],
      );
      final fetchCircleUseCase = container.read(fetchCircleUseCaseProvider);

      // Act
      final result = await fetchCircleUseCase.call();

      if (result is Failure) {
        fail('ここは通らないはず');
      }

      // Assert
      expect(result, isA<Success<List<CircleModel>, Exception>>());
    });
  });

  test('fetchCircleInfoFromDB異常系', () async {
    // Arrange
    when(mockCircleRepository.fetchCircleInfoFromDB()).thenThrow(Exception());
    final fetchCircleUseCase = container.read(fetchCircleUseCaseProvider);

    // Act
    final result = await fetchCircleUseCase.call();

    // Assert
    expect(result, isA<Failure<void, Exception>>());
  });
}
