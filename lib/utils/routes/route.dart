import 'package:flutter/material.dart';
import '../../view/HomeView.dart';
import '../../view/LoginView.dart';
import '../../view/SignupView.dart';
import '../../view/SignupView.dart';
import '../../view/onboarding/onboardingView.dart';
import '../../view/order_tracking_page.dart';
import '../../view/splashView.dart';
import 'route_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.home:
        return MaterialPageRoute(builder: (BuildContext context) => HomeView());
      case RouteName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginView());
      case RouteName.signup:
        return MaterialPageRoute(
            builder: (BuildContext context) => SignupView());
      case RouteName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => SplashScreen());
      case RouteName.bustracking:
        return MaterialPageRoute(
            builder: (BuildContext context) => BusTrackingView());
      case RouteName.onboarding:
        return MaterialPageRoute(
            builder: (BuildContext context) => OnboardingView());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No Route defined'),
            ),
          );
        });
    }
  }

  static const String home = 'home_screen';
}
