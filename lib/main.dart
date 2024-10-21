import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:m3_app/core/theme/m3_theme.dart';
import 'package:m3_app/provider/common/router/router_privder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/common/shared_preference_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// sharedPreferencesインスタンス取得
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(
          prefs,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routerConfig: router,
      title: 'M3 APP',
      theme: m3Theme,
    );
  }
}
