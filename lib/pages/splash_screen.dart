import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    _goToHomePage(context);


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Column(
        children: [
          const Spacer(), // Pushes the content in the center vertically
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensures the content takes minimum vertical space
              children: [
                SvgPicture.asset(
                  'lib/assets/splash_screen_app_icon.svg', // Path to your asset
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 8), // Reduced space between image and text
                const Text(
                  'Red Vožnje', // Normal text
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4), // Reduced space between the texts
                const Text(
                  'Novi Sad', // Larger and bold text
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(), // Pushes the content towards the center
          const Padding(
            padding: EdgeInsets.only(bottom: 20), // Bottom padding for the text
            child: Text(
              'Powered by Crystal Pigeon', // Text at the bottom
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );


  }
}

Future<void> _goToHomePage(BuildContext context) async {
  await Future.delayed(const Duration(
    milliseconds: 1000 ,
  ));
  // context.goNamed('homePage');
}
