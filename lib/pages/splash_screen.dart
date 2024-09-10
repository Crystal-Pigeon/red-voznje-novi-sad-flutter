import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    _goToHomePage(context);


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Center(
        child: Image.asset(
          'lib/assets/splash_screen_app_icon.png', // Path to your SVG asset
          width: 180, // Specify the size of the icon
          height: 180,
        ),
      ),
    );
  }
}

Future<void> _goToHomePage(BuildContext context) async {
  await Future.delayed(const Duration(
    milliseconds: 1000 ,
  ));
  context.goNamed('homePage');
}
