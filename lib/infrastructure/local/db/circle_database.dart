import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../domain/model/circle_model.dart';
import '../../../domain/model/circle_wish_model.dart';

part 'circle_database.g.dart';

@DataClassName('Circle')
class Circles extends Table {
  IntColumn get id => integer()(); // 主キー
  TextColumn get name => text()();
  TextColumn get phonetic => text()();
  TextColumn get genre => text()();
  IntColumn get spaceSize => integer().nullable()();
  BoolColumn get adult => boolean()();
  TextColumn get prText => text()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}

@DataClassName('SnsLink')
class SnsLinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get circleId => integer().references(Circles, #id)();
  TextColumn get siteText => text().nullable()();
  TextColumn get siteUrl => text().nullable()();
  TextColumn get twitterText => text().nullable()();
  TextColumn get twitterUrl => text().nullable()();
  TextColumn get youtubeText => text().nullable()();
  TextColumn get youtubeUrl => text().nullable()();
  TextColumn get snsText => text().nullable()();
  TextColumn get snsUrl => text().nullable()();
}

@DataClassName('RealSp')
class RealSps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get circleId => integer().references(Circles, #id)();
  TextColumn get area => text().nullable()();
  TextColumn get no => text().nullable()();
}

@DataClassName('WebSp')
class WebSps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get circle => integer().references(Circles, #id)();
  TextColumn get area => text().nullable()();
  TextColumn get no => text().nullable()();
}

@DataClassName('Keyword')
class Keywords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get circleId => integer().references(Circles, #id)();
  TextColumn get keywordText => text()();
  TextColumn get phonetic => text()();
}

@DataClassName('Wish')
class Wishes extends Table {
  IntColumn get id => integer().autoIncrement()(); // 主キー
  BoolColumn get isFavorite => boolean().references(Circles, #isFavorite)();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  TextColumn get space => text().nullable()();
  IntColumn get circleId => integer().references(Circles, #id)();
  TextColumn get circleName => text().references(Circles, #name)();
  IntColumn get amount => integer().withDefault(const Constant(0))();
  TextColumn get memo => text().nullable()();
}

@DriftDatabase(tables: [Circles, SnsLinks, RealSps, WebSps, Keywords, Wishes])
class CircleDatabase extends _$CircleDatabase {
  // SQLite用のファクトリー
  factory CircleDatabase() {
    return CircleDatabase._(_openConnection());
  }

  CircleDatabase._(super.e);

  // テスト用のファクトリー
  factory CircleDatabase.memory() {
    return CircleDatabase._(NativeDatabase.memory());
  }
  // テスト用のファクトリー
  factory CircleDatabase.fotTest(QueryExecutor e) {
    return CircleDatabase._(e);
  }
  // CircleDatabase() : super(_openConnection());

  // マイグレーションを行う場合に使用ため、テーブルを追加／変更／削除する場合はこの値をインクリメントする
  @override
  int get schemaVersion => 1;

  // サークル全件取得
  Future<List<Circle>> getAllCircle() async {
    final data = await select(circles).get();

    return data;
  }

  Future<List<Circle>> getCircle(int circleId) async {
    final data =
        await (select(circles)..where((tbl) => tbl.id.equals(circleId))).get();
    return data;
  }

  Future<SnsLink?> getSnsLinks(int circleId) async {
    final data = await (select(snsLinks)
          ..where((tbl) => tbl.circleId.equals(circleId)))
        .get();
    if (data.isEmpty) {
      return null;
    }
    return data[0];
  }

  Future<RealSp?> getRealSp(int circleId) async {
    final data = await (select(realSps)
          ..where((tbl) => tbl.circleId.equals(circleId)))
        .get();
    if (data.isEmpty) {
      return null;
    }
    return data[0];
  }

  Future<WebSp?> getWebSp(int circleId) async {
    final data = await (select(webSps)
          ..where((tbl) => tbl.circle.equals(circleId)))
        .get();
    if (data.isEmpty) {
      return null;
    }
    return data[0];
  }

  Future<List<Keyword>> getKeywords(int circleId) async {
    final data = await (select(keywords)
          ..where((tbl) => tbl.circleId.equals(circleId)))
        .get();
    return data;
  }

  Future<void> addCircle({
    required CircleModel circle,
  }) async {
    final futureList = <Future<dynamic>>[];

    final addCircleFuture = into(circles).insert(
      CirclesCompanion(
        id: Value(circle.id),
        name: Value(circle.name),
        phonetic: Value(circle.phonetic),
        genre: Value(circle.genre),
        spaceSize: Value(circle.spaceSize),
        adult: Value(circle.adult),
        prText: Value(circle.prText),
      ),
    );

    final addLinkFuture = addLink(
      circleId: circle.id,
      links: circle.links,
    );

    final addRealSpFuture = (circle.realSp != null)
        ? addRealSp(
            circleId: circle.id,
            realSp: circle.realSp!,
          )
        : null;

    final addWebSpFuture = (circle.webSp != null)
        ? addWebSp(
            circleId: circle.id,
            webSp: circle.webSp!,
          )
        : null;

    final addKeywordFuture = circle.keywords.map(
      (keyword) => addKeyword(
        circleId: circle.id,
        keyword: keyword,
      ),
    );

    futureList
      ..add(addCircleFuture)
      ..add(addLinkFuture);
    if (addRealSpFuture != null) {
      futureList.add(addRealSpFuture);
    }
    if (addWebSpFuture != null) {
      futureList.add(addWebSpFuture);
    }
    futureList.addAll(addKeywordFuture);

    await Future.wait(futureList);
  }

  Future<void> addLink({
    required int circleId,
    required SnsLinksModel links,
  }) async {
    await into(snsLinks).insert(
      SnsLinksCompanion(
        circleId: Value(circleId),
        siteText: Value(links.site?.text),
        siteUrl: Value(links.site?.url),
        twitterText: Value(links.twitter?.text),
        twitterUrl: Value(links.twitter?.url),
        youtubeText: Value(links.youtube?.text),
        youtubeUrl: Value(links.youtube?.url),
        snsText: Value(links.sns?.text),
        snsUrl: Value(links.sns?.url),
      ),
    );
  }

  Future<void> addRealSp({
    required int circleId,
    required RealSpModel realSp,
  }) async {
    await into(realSps).insert(
      RealSpsCompanion(
        circleId: Value(circleId),
        area: Value(realSp.area),
        no: Value(realSp.no),
      ),
    );
  }

  Future<void> addWebSp({
    required int circleId,
    required WebSpModel webSp,
  }) async {
    await into(webSps).insert(
      WebSpsCompanion(
        circle: Value(circleId),
        area: Value(webSp.area),
        no: Value(webSp.no),
      ),
    );
  }

  Future<void> addKeyword({
    required int circleId,
    required KeywordModel keyword,
  }) async {
    await into(keywords).insert(
      KeywordsCompanion(
        circleId: Value(circleId),
        keywordText: Value(keyword.text),
        phonetic: Value(keyword.phonetic),
      ),
    );
  }

  Future<void> updateCircleFav({
    // required CircleModel circle,
    required int circleId,
    required bool isFavorite,
  }) async {
    await (update(circles)..where((tbl) => tbl.id.equals(circleId))).write(
      CirclesCompanion(
        isFavorite: Value(isFavorite),
      ),
    );
  }

  //TODO 再取得、更新

  // -----------------------------

  Future<List<Wish>> getAllWishes() async {
    final data = await select(wishes).get();
    return data;
  }

  Future<void> addWish({
    required CircleWishModel wish,
  }) async {
    await into(wishes).insert(
      WishesCompanion(
        isFavorite: Value(wish.isFavorite),
        done: Value(wish.isDone),
        space: Value(wish.spaceName),
        circleId: Value(wish.circleId),
        circleName: Value(wish.name),
        amount: Value(wish.amount),
        memo: Value(wish.memo),
      ),
    );
  }

  Future<void> updateWish({required CircleWishModel wish}) async {
    await (update(wishes)..where((tbl) => tbl.circleId.equals(wish.circleId)))
        .write(
      WishesCompanion(
        isFavorite: Value(wish.isFavorite),
        done: Value(wish.isDone),
        amount: Value(wish.amount),
        memo: Value(wish.memo),
      ),
    );
  }

  Future<void> deleteWish({
    required int circleId,
  }) async {
    await (delete(wishes)..where((tbl) => tbl.circleId.equals(circleId))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'circle_db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
