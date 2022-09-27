import 'dart:async';
import 'package:emersonbustracking/view/HomeView.dart';
import 'package:emersonbustracking/view/onboarding/onboardingView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../view/LoginView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashServices {
  void isLogin(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    final pref = await SharedPreferences.getInstance();
    final showHome = pref.getBool('showHome') ?? false;

    if (showHome == false) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => OnboardingView())));
    } else if (user != null && showHome) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeView())));
    } else if (user == null && showHome) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginView())));
    }
  }
}
