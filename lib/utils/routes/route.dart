import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/signup_model.dart';
import '../../view/Firebase_view.dart';
import '../../view/customer_home_view.dart';
import '../../view/home_view.dart';
import '../../view/login_view.dart';
import '../../view/signup_view.dart';
import '../../view/onboarding/onboarding_view.dart';
import '../../view/order_tracking_page.dart';
import '../../view/splash_view.dart';
import '../../view/map_page.dart';
import 'route_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    debugPrint("generateRoute: ${settings.name}");
    switch (settings.name) {
      case RouteName.home:
        // final prefs = await SharedPreferences.getInstance();
        // SignUpModel? signUpModel = json.decode(prefs.getString('userModel')!);
        return MaterialPageRoute(
            builder: (BuildContext context) => const CustomerHomeView());
      case RouteName.adminHome:
        debugPrint("================get adin route=============");
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeView());
      case RouteName.firebase:
        return MaterialPageRoute(
            builder: (BuildContext context) => const FirebaseView());
      case RouteName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginView());
      case RouteName.signup:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignupView());
      case RouteName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case RouteName.bustracking:
        return MaterialPageRoute(
            builder: (BuildContext context) => const BusTrackingView());
      case RouteName.map:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MapView());
      case RouteName.onboarding:
        return MaterialPageRoute(
            builder: (BuildContext context) => const OnboardingView());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No Route defined'),
            ),
          );
        });
    }
  }

  static const String home = 'home_screen';
}
