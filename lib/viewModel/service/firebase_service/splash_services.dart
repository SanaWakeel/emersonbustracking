import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../utils/routes/route_name.dart';

class SplashServices {
  void isLogin(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    final pref = await SharedPreferences.getInstance();
    final showHome = pref.getBool('showHome') ?? false;

    if (showHome == false) {
      Timer(const Duration(seconds: 3),
          () => Navigator.pushReplacementNamed(context, RouteName.onboarding));
    } else if (user != null && showHome) {
      Timer(const Duration(seconds: 3),
          () => Navigator.pushReplacementNamed(context, RouteName.home));
    } else if (user == null && showHome) {
      Timer(const Duration(seconds: 3),
          () => Navigator.pushReplacementNamed(context, RouteName.login));
    }
  }
}
