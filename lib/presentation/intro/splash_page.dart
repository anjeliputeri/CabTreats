import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import '../../core/assets/assets.gen.dart';
import '../../core/constants/colors.dart';
import '../../core/router/app_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    print('isLoggedIn: $isLoggedIn');

    if (isLoggedIn) {
      context.goNamed(
        RouteConstants.root,
        pathParameters: PathParameters().toMap(),
      );
    } else {
      Future.delayed(
        const Duration(seconds: 1),
            () => context.goNamed(
          RouteConstants.login,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Assets.images.logo.image(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text(
          'CabTreats',
          style: TextStyle(
            color: Color(0XFFDB1A1B),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
