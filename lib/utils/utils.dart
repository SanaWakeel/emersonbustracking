import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static const String googleApiKey = "AIzaSyDXRCj0868fNVIVvBvLVMnwjgZUT43f1c8";
  static String userName = "";
  static String registrationNo = "";
  static int userType = 1;

  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static toastMessage(String message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: color,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG);
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          forwardAnimationCurve: Curves.decelerate,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
          padding: const EdgeInsets.all(15),
          borderRadius: BorderRadius.circular(8),
          message: message,
          duration: const Duration(seconds: 3),
          messageColor: Colors.white,
          backgroundColor: Colors.red,
          reverseAnimationCurve: Curves.easeInOut,
          positionOffset: 20,
          icon: const Icon(Icons.error, size: 28, color: Colors.white),
        )..show(context));
  }

  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
