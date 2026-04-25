import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/m3_theme.dart';
import '../../../../core/theme/m3_theme_config.dart';
import '../../../../core/utils/circle_util.dart';
import '../../../../domain/model/circle_model.dart';
import '../../../controller/circle_list/circle_list_controller.dart';
import '../../components/circle_list/favorite_button.dart';
import '../../components/common/margin.dart';
import '../../components/common/toast.dart';

class CircleDetailPage extends StatelessWidget {
  const CircleDetailPage({super.key, required this.circle});
  final CircleModel circle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          circle.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MarginVertical(15),
              _CircleName(name: circle.name),
              const MarginVertical(15),
              _CircleSpaceArea(
                realSp: circle.realSp,
                webSp: circle.webSp,
              ),
              const MarginVertical(15),
              _CirclePrText(prText: circle.prText),
              const MarginVertical(15),
              _SocialLinks(links: circle.links),
              const MarginVertical(15),
              _WishToggleButton(circle: circle),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleName extends StatelessWidget {
  const _CircleName({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'サークル名: ',
          style: TextStyle(
            fontSize: M3ThemeConfig.fontSize.normal,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: M3ThemeConfig.fontSize.normal,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}

class _CircleSpaceArea extends StatelessWidget {
  const _CircleSpaceArea({required this.realSp, required this.webSp});
  final RealSpModel? realSp;
  final WebSpModel? webSp;

  String _getHall(String area) {
    var hall = '';
    if (CircleUtil.isUpperCaseEnglish(area)) {
      hall = '第一展示場';
    } else if (CircleUtil.isHiragana(area)) {
      hall = '第二展示場(1階)';
    } else if (CircleUtil.isKatakana(area)) {
      hall = '第二展示場(2階)';
    }
    return hall;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (realSp != null)
          Text(
            'リアル: [${_getHall(realSp!.area ?? "")}] ${realSp!.area}-${realSp!.no}',
          ),
        if (realSp != null && webSp != null) const MarginVertical(15),
        if (webSp != null) Text('Web: ${webSp!.area}-${webSp!.no}'),
      ],
    );
  }
}

class _CirclePrText extends StatelessWidget {
  const _CirclePrText({required this.prText});
  final String prText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: m3ColorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(prText),
    );
  }
}

class _SocialLinks extends StatelessWidget {
  const _SocialLinks({required this.links});
  final SnsLinksModel links;
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      try {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } on Exception catch (_) {
        MessageWidget.show('URLを開けませんでした');
      }
    } else {
      MessageWidget.show('URLを開けませんでした');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (links.twitter?.url.isNotEmpty ?? false)
              IconButton(
                icon: M3CustomIcon.x(width: 20, height: 20),
                onPressed: () {
                  _launchUrl(links.twitter!.url);
                },
              ),
            if (links.youtube?.url.isNotEmpty ?? false)
              IconButton(
                icon: M3CustomIcon.youtube(width: 20, height: 20),
                onPressed: () {
                  _launchUrl(links.youtube!.url);
                },
              ),
          ],
        ),
        if (links.sns?.url.isNotEmpty ?? false)
          TextButton(
            child: Text(
              (links.sns!.text.isNotEmpty) ? links.sns!.text : links.sns!.url,
            ),
            onPressed: () {
              _launchUrl(links.sns!.url);
            },
          ),
        if (links.site?.url.isNotEmpty ?? false)
          TextButton(
            child: Text(
              (links.site!.text.isNotEmpty) ? links.sns!.text : links.site!.url,
            ),
            onPressed: () {
              _launchUrl(links.site!.url);
            },
          ),
      ],
    );
  }
}

class _WishToggleButton extends HookConsumerWidget {
  const _WishToggleButton({
    required this.circle,
  });
  final CircleModel circle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(circleListControllerProvider.notifier);
    final isFavorite = useState<bool>(circle.isFavorite ?? false);
    final futureState = useState<bool>(false);

    Future<void> updateMethod() async {
      try {
        futureState.value = true;
        await notifier
            .updateFavorite(circle.copyWith(isFavorite: isFavorite.value));
        futureState.value = false;
        isFavorite.value = !isFavorite.value;
      } on Exception catch (_) {
        MessageWidget.show('お気に入り登録に失敗しました');
        futureState.value = false;
      }
    }

    return Stack(
      children: [
        FavoriteButton(
          isFavorite: isFavorite.value,
          onPressed: () async {
            if (isFavorite.value) {
              await showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('ウィッシュリストから削除しますか？'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await updateMethod();
                        },
                        child: const Text('削除'),
                      ),
                    ],
                  );
                },
              );
            } else {
              await updateMethod();
            }
          },
        ),
        if (futureState.value) const Text('更新中...'),
      ],
    );
  }
}
