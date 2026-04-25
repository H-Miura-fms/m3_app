import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/shared_preference_provider.dart';

part 'budget_state.g.dart';

@riverpod
class BudgetState extends _$BudgetState {
  @override
  int build() {
    final budget = ref.read(sharedPreferencesProvider).getInt('budget') ?? 0;
    return budget;
  }

  void updateBudget(int budget) {
    ref.read(sharedPreferencesProvider).setInt('budget', budget);
    state = budget;
  }
}
