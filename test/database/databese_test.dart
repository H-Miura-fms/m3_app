import 'package:flutter_test/flutter_test.dart';
import 'package:m3_app/domain/model/circle_model.dart';
import 'package:m3_app/domain/model/circle_wish_model.dart';
import 'package:m3_app/infrastructure/local/db/circle_database.dart';

void main() {
  late CircleDatabase db;

  setUp(() {
    db = CircleDatabase.memory();
  });

  tearDown(() async {
    await db.close();
  });

  group('サークルdb操作テスト', () {
    test('サークルデータ追加、取得', () async {
      const mockModel = CircleModel(
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
      );
      await db.addCircle(
        circle: mockModel,
      );

      final data = await db.getAllCircle();

      expect(data, isA<List<Circle>>());
      expect(data.length, 1);
      expect(data[0].name, 'name');
    });

    test('ウィッシュリスト操作', () async {
      const wishMock = CircleWishModel(
        circleId: 1,
        name: 'name',
        spaceName: 'A01',
        isFavorite: true,
        isDone: true,
        amount: 1000,
        memo: 'memo',
      );
      await db.addWish(wish: wishMock);

      final wishList = await db.getAllWishes();

      expect(wishList, isA<List<Wish>>());
      expect(wishList.length, 1);
      expect(wishList[0].circleName, 'name');
      expect(wishList[0].amount, 1000);
    });
  });
}
