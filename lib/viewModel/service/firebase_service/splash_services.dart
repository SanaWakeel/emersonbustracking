import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../enum/user_type.dart';
import '../../../model/signup_model.dart';
import '../../../utils/routes/route_name.dart';
import '../../../utils/utils.dart';

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
      final prefs = await SharedPreferences.getInstance();
      var userModel = prefs.getString('userModel');
      if (userModel != null) {
        var signUpModel = json.decode(userModel);
        signUpModel = SignUpModel.fromJson(signUpModel);
        debugPrint("SignUpModel Role:$signUpModel");
        if (signUpModel!.role == UserType.admin.index) {
          Utils.userType = 0;
          Timer(
              const Duration(seconds: 3),
              () =>
                  Navigator.pushReplacementNamed(context, RouteName.adminHome));
        } else if (signUpModel!.role == UserType.user.index) {
          Utils.userType = 1;
          Timer(const Duration(seconds: 3),
              () => Navigator.pushReplacementNamed(context, RouteName.home));
        }
      } else {}

      // Timer(const Duration(seconds: 3),
      //     () => Navigator.pushReplacementNamed(context, RouteName.home));
    } else if (user == null && showHome) {
      Timer(const Duration(seconds: 3),
          () => Navigator.pushReplacementNamed(context, RouteName.login));
    }
  }
}
