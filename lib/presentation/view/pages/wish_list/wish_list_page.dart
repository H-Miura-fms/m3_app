import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/routing_path_const.dart';
import '../../../../core/theme/m3_theme.dart';
import '../../../../core/theme/m3_theme_config.dart';
import '../../../../core/utils/result.dart';
import '../../../../domain/model/circle_model.dart';
import '../../../../domain/model/circle_wish_model.dart';
import '../../../../provider/usecase/usecase_providers.dart';
import '../../../../provider/wish_list_page/budget_state.dart';
import '../../../controller/wish_list/wish_list_controller.dart';
import '../../components/common/error_page.dart';
import '../../components/common/loading_page.dart';
import '../../components/common/margin.dart';
import '../../components/common/toast.dart';

class WishListPage extends ConsumerWidget {
  const WishListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishListController = ref.watch(wishListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ウィッシュリスト'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, top: 15),
        child: wishListController.when(
          data: (data) {
            var totalEstimatedAmount = 0;
            var totalDoneAmount = 0;
            for (var i = 0; i < data.length; i++) {
              totalEstimatedAmount += data[i].isFavorite ? data[i].amount : 0;
              totalDoneAmount += data[i].isDone ? data[i].amount : 0;
            }
            return Column(
              children: [
                _BudgetArea(
                  totalEstimatedAmount: totalEstimatedAmount,
                  totalDoneAmount: totalDoneAmount,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // 横スクロール
                      child: Column(
                        children: [
                          _HeaderCell(),
                          Column(
                            children: data.map((wish) {
                              return _DataCellRow(
                                wish: wish,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const LoadingPage(),
          error: (error, stack) => ErrorPage(
            retryMethod: () {
              ref.invalidate(wishListControllerProvider);
            },
          ),
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 184, 184, 184), // ボーダーの色
          ),
        ),
      ),
      child: Row(
        children: [
          _DataCell(
            width: 45,
            child: Text(
              '行くかも',
              style: TextStyle(fontSize: M3ThemeConfig.fontSize.small),
            ),
          ),
          const _DataCell(width: 45, child: Text('済')),
          const _DataCell(width: 80, child: Text('場所')),
          const _DataCell(width: 120, child: Text('サークル名')),
          const _DataCell(width: 100, child: Text('予定金額')),
          const _DataCell(width: 200, child: Text('メモ')),
        ],
      ),
    );
  }
}

class _DataCellRow extends ConsumerWidget {
  const _DataCellRow({required this.wish});
  final CircleWishModel wish;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(wishListControllerProvider.notifier);

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 184, 184, 184), // ボーダーの色
          ),
        ),
        // color: Colors.amber,
      ),
      child: Row(
        children: [
          _DataCell(
            width: 45,
            child: _WishCheckBox(
              value: wish.isFavorite,
              onChanged: (value) async {
                await notifier.updateWishList(
                  wish.copyWith(isFavorite: !wish.isFavorite),
                );
              },
            ),
          ),
          _DataCell(
            width: 45,
            child: _WishCheckBox(
              value: wish.isDone,
              onChanged: (value) async {
                await notifier.updateWishList(
                  wish.copyWith(isDone: !wish.isDone),
                );
              },
            ),
          ),
          _DataCell(width: 80, child: Text(wish.spaceName)),
          _DataCell(
            width: 120,
            child: _CircleName(
              name: wish.name,
              onTap: () async {
                // サークル詳細に遷移
                // めんどくさいのでusecaseから取得
                final result = await ref
                    .read(fetchCircleFromIdUseCaseProvider)
                    .call(wish.circleId);
                if (!context.mounted) {
                  return;
                }
                switch (result) {
                  case Success<CircleModel, Exception>():
                    final circle = result.value;
                    await context.push(
                      '${RoutingPathConst.wishList}/${RoutingPathConst.circleDetails}',
                      extra: circle,
                    );
                  case Failure<CircleModel, Exception>():
                    MessageWidget.show('サークル情報の取得に失敗しました');
                }
              },
            ),
          ),
          _DataCell(
            width: 100,
            child: _WishAmountTextEditingArea(
              amount: wish.amount,
              onTapOutside: (value) async {
                await notifier.updateWishList(
                  wish.copyWith(amount: int.parse(value)),
                );
              },
            ),
          ),
          _DataCell(
            width: 200,
            child: _WishMemoTextEditingArea(
              memo: wish.memo,
              onTapOutside: (value) {
                notifier.updateWishList(wish.copyWith(memo: value));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  const _DataCell({this.width, required this.child});
  final double? width;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 3),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Center(child: child),
    );
  }
}

class _WishCheckBox extends StatelessWidget {
  const _WishCheckBox({required this.value, required this.onChanged});
  final bool value;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
    );
  }
}

class _WishAmountTextEditingArea extends HookWidget {
  const _WishAmountTextEditingArea({
    required this.amount,
    required this.onTapOutside,
  });
  final int amount;
  final ValueChanged<String> onTapOutside;
  @override
  Widget build(BuildContext context) {
    final textEditingController =
        useTextEditingController(text: amount.toString());
    final focusNode = useFocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        onTapOutside(textEditingController.text);
      }
    });
    return TextField(
      controller: textEditingController,
      focusNode: focusNode,
      decoration: const InputDecoration(
        border: InputBorder.none,
        suffixText: '円',
      ),
      textAlign: TextAlign.end,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onTapOutside: (event) {
        focusNode.unfocus();
      },
    );
  }
}

class _WishMemoTextEditingArea extends HookWidget {
  const _WishMemoTextEditingArea({
    required this.memo,
    required this.onTapOutside,
  });
  final String memo;
  final ValueChanged<String> onTapOutside;
  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController(text: memo);
    final focusNode = useFocusNode();

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        onTapOutside(textEditingController.text);
      }
    });
    return TextField(
      controller: textEditingController,
      focusNode: focusNode,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      maxLines: null,
      onTapOutside: (event) {
        focusNode.unfocus();
      },
    );
  }
}

class _BudgetArea extends ConsumerWidget {
  const _BudgetArea({
    required this.totalEstimatedAmount,
    required this.totalDoneAmount,
  });
  final int totalEstimatedAmount;
  final int totalDoneAmount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(budgetStateProvider);

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 50, child: Text('予算: ')),
            _BudgetAmountTextField(
              initialAmount: budget,
              onTapOutside: (value) {
                ref.read(budgetStateProvider.notifier).updateBudget(
                      int.parse(value),
                    );
              },
            ),
            const Text('円'),
          ],
        ),
        const MarginVertical(15),
        Row(
          children: [
            const SizedBox(width: 50, child: Text('検討中: ')),
            _BudgetAmountTextContainer(
              amount: totalEstimatedAmount,
            ),
            const Text('円'),
            const MarginHorizontal(5),
            _BudgetDifference(amount: totalEstimatedAmount, budget: budget),
          ],
        ),
        const MarginVertical(15),
        Row(
          children: [
            const SizedBox(width: 50, child: Text('済: ')),
            _BudgetAmountTextContainer(
              amount: totalDoneAmount,
            ),
            const Text('円'),
            const MarginHorizontal(5),
            _BudgetDifference(amount: totalDoneAmount, budget: budget),
          ],
        ),
      ],
    );
  }
}

class _BudgetAmountTextContainer extends StatelessWidget {
  const _BudgetAmountTextContainer({
    required this.amount,
  });
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 35,
      decoration: BoxDecoration(
        color: m3ColorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.centerRight,
        child: Text(
          amount.toString(),
          style: TextStyle(
            fontSize: M3ThemeConfig.fontSize.normal,
          ),
        ),
      ),
    );
  }
}

class _BudgetAmountTextField extends HookWidget {
  const _BudgetAmountTextField({
    required this.initialAmount,
    required this.onTapOutside,
  });
  final int initialAmount;
  final ValueChanged<String> onTapOutside;

  @override
  Widget build(BuildContext context) {
    final textEditingController =
        useTextEditingController(text: initialAmount.toString());
    final focusNode = useFocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        onTapOutside(textEditingController.text);
      }
    });
    return SizedBox(
      width: 100,
      height: 35,
      child: TextField(
        controller: textEditingController,
        focusNode: focusNode,
        decoration: InputDecoration(
          filled: true,
          fillColor: m3ColorScheme.surfaceContainer,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 5,
          ),
          border: OutlineInputBorder(
            gapPadding: 0,
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(
          fontSize: M3ThemeConfig.fontSize.normal, // Adjust the font size here
        ),
        textAlign: TextAlign.end,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onTapOutside: (event) {
          focusNode.unfocus();
        },
      ),
    );
  }
}

class _BudgetDifference extends StatelessWidget {
  const _BudgetDifference({
    required this.budget,
    required this.amount,
  });
  final int budget;
  final int amount;

  @override
  Widget build(BuildContext context) {
    final diff = amount - budget;
    return Row(
      children: [
        Text(
          '(${diff > 0 ? '+' : ''}$diff円)',
          style: TextStyle(
            fontSize: M3ThemeConfig.fontSize.normal,
            color: diff > 0
                ? M3ThemeConfig.customColor.overBudget
                : M3ThemeConfig.customColor.underBudget,
          ),
        ),
      ],
    );
  }
}

class _CircleName extends StatelessWidget {
  const _CircleName({required this.name, required this.onTap});
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.zero,
        ),
        splashFactory: NoSplash.splashFactory, // インクエフェクトを無効にする // テキストカラー
        backgroundColor:
            WidgetStateProperty.all(Colors.transparent), // 背景色を透明にする
        overlayColor: WidgetStateProperty.all(Colors.transparent), // ハイライ
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: M3ThemeConfig.fontSize.normal,
        ),
      ),
    );
  }
}
