// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/log_views/SignInPage.dart';
import 'package:chat_app/screens/HomeManagement.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/mainUser.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  dynamic user;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  dynamic getUserInfo() {
    user = UserInfo();

    verifyAccessTokenInLocalStorage();
  }

  verifyAccessTokenInLocalStorage() async {
    if (user != null) {
      await Future.delayed(const Duration(seconds: 3));
      if (user["access_token"] != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => HomeManagement(
              title: 'Horama Chat',
            ),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const SignIn(),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Lottie.asset(
          'assets/LottieFile/chat_animation.json',
          height: 180,
        ),
      ),
    );
  }
}
