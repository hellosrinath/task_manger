import 'package:flutter/material.dart';
import 'package:task_manger/presentation/screens/auth/signin_screen.dart';
import 'package:task_manger/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manger/presentation/widgets/main_background.dart';

import '../../controller/auth_controller.dart';
import '../../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    bool userExist = await AuthController.isUserLoggedIn();

    if (mounted) {
      if (userExist) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainBottomNavScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MainBackground(
      child: Center(
        child: AppLogo(),
      ),
    );
  }
}
