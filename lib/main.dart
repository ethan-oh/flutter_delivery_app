import 'package:delivery_flutter_app/common/provider/go_route_provider.dart';
import 'package:delivery_flutter_app/common/provider/theme_provider.dart';
import 'package:delivery_flutter_app/common/const/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      themeMode: themeMode,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: MaterialTheme.lightScheme(),
        useMaterial3: true,
        fontFamily: 'NotoSans',
      ),
      darkTheme: ThemeData(
        colorScheme: MaterialTheme.darkScheme(),
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
