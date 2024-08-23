import 'package:delivery_flutter_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static String get routeName => 'splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        child: Center(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.modulate,
            ),
            child: Image.asset(
              'asset/img/logo/my_logo.png',
              width: MediaQuery.of(context).size.width * 0.85,
            ),
          ),
        ));
  }
}
