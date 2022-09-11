import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../model/userModel.dart';
import '../../utils/routes/route_name.dart';
import '../userViewModel.dart';

class SplashServices {
  Future<UserModel> getUserDate() => UserViewModel().getUser();

  void checKAuthentication(BuildContext context) async {
    getUserDate().then((value) async {
      if (value.token == "null" || value.token == '') {
        await Future.delayed(
          Duration(seconds: 3),
        );
        Navigator.pushNamed(context, RouteName.login);
      } else {
        await Future.delayed(
          Duration(seconds: 3),
        );
        Navigator.pushNamed(context, RouteName.home);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
