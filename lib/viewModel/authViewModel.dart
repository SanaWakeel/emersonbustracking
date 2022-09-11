import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../repository/auth_repositories.dart';
import '../utils/routes/route_name.dart';
import '../utils/utils.dart';

class AuthViewModel with ChangeNotifier {
  final _myRepo = AuthRepository();
  static bool _isloading = false;

  static bool get isloading => _isloading;

  isloadingSetter(bool value) {
    _isloading = value;
    notifyListeners();
  }

  static bool _isloadingSignUp = false;

  static bool get isloadingSignUp => _isloadingSignUp;

  isloadingSignUpSetter(bool value) {
    _isloadingSignUp = value;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context) async {
    isloadingSetter(true);
    _myRepo.loginApi(data).then((value) {
      Utils.flushBarErrorMessage("Login Successful", context);
      Navigator.pushNamed(context, RouteName.home);
      if (kDebugMode) {
        print(value.toString());
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      if (kDebugMode) print(error.toString());
    });
    isloadingSetter(false);
  }

  Future<void> signupApi(dynamic data, BuildContext context) async {
    isloadingSignUpSetter(true);
    _myRepo.loginApi(data).then((value) {
      Utils.flushBarErrorMessage("Signup Successful", context);
      Navigator.pushNamed(context, RouteName.home);
      if (kDebugMode) {
        print(value.toString());
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      if (kDebugMode) print(error.toString());
    });
    isloadingSignUpSetter(false);
  }
}
