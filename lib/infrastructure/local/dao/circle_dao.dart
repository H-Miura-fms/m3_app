import '../../../domain/model/circle_model.dart';
import '../../model/circle_api_response/circle_api_response_model.dart';
import '../db/circle_database.dart';

class CircleInfoDao {
  CircleInfoDao(this.db);
  final CircleDatabase db;

  Future<List<CircleModel>> getAllCircle() async {
    final list = <CircleModel>[];
    final data = await db.getAllCircle();

    for (final circle in data) {
      final links = await db.getSnsLinks(circle.id);
      final keywords = await db.getKeywords(circle.id);
      final realSp = await db.getRealSp(circle.id);
      final webSp = await db.getWebSp(circle.id);
      final model = _toModel(circle, links, keywords, realSp, webSp);

      list.add(model);
    }

    return list;
  }

  Future<CircleModel> getCircleFromID(int id) async {
    final circles = await db.getCircle(id);
    if (circles.isEmpty) {
      throw Exception('サークル情報が見つかりませんでした');
    }
    final circle = circles.first;
    final links = await db.getSnsLinks(id);
    final keywords = await db.getKeywords(id);
    final realSp = await db.getRealSp(id);
    final webSp = await db.getWebSp(id);

    final circleModel = _toModel(circle, links, keywords, realSp, webSp);

    return circleModel;
  }

  Future<void> updateCircleFav({
    required int circleId,
    required bool isFav,
  }) async {
    await db.updateCircleFav(circleId: circleId, isFavorite: isFav);
  }

  /// APIレスポンスからデータベースに保存
  Future<void> addCircleInfoFromResponse(CircleApiResponse response) async {
    final circles = response.items;

    for (final circle in circles) {
      final c = CircleModel.fromDto(circle);
      await db.addCircle(circle: c);
    }
  }

  CircleModel _toModel(
    Circle circle,
    SnsLink? links,
    List<Keyword> keywords,
    RealSp? realSp,
    WebSp? webSp,
  ) {
    return CircleModel(
      id: circle.id,
      name: circle.name,
      phonetic: circle.phonetic,
      genre: circle.genre,
      spaceSize: circle.spaceSize,
      adult: circle.adult,
      prText: circle.prText,
      isFavorite: circle.isFavorite,
      links: (links != null)
          ? SnsLinksModel(
              twitter: SocialLink(
                text: links.twitterText ?? '',
                url: links.twitterUrl ?? '',
              ),
              site: SocialLink(
                text: links.siteText ?? '',
                url: links.siteUrl ?? '',
              ),
              youtube: SocialLink(
                text: links.youtubeText ?? '',
                url: links.youtubeUrl ?? '',
              ),
              sns: SocialLink(
                text: links.snsText ?? '',
                url: links.snsUrl ?? '',
              ),
            )
          : const SnsLinksModel(),
      keywords: keywords
          .map(
            (keyword) => KeywordModel(
              text: keyword.keywordText,
              phonetic: keyword.phonetic,
            ),
          )
          .toList(),
      realSp: realSp != null
          ? RealSpModel(
              area: realSp.area,
              no: realSp.no,
            )
          : null,
      webSp: webSp != null
          ? WebSpModel(
              area: webSp.area ?? '',
              no: webSp.no ?? '',
            )
          : null,
    );
  }
}
