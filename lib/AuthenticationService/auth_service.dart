import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../model/signup_model.dart';

class AuthenticationService {
  Future<SignUpModel?> getUserDetail(String uid) async {
    SignUpModel? model = SignUpModel();
    debugPrint("========getUserDetail=========");
    try {
      final ref = FirebaseDatabase.instance.ref();
      final event = await ref.child('User').child(uid).once();
      if (event.snapshot.exists) {
        debugPrint("event: ${event.snapshot.value}");
        Map<String, dynamic> myUser = Map<String, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);
        debugPrint("user map is: $myUser");
        model = SignUpModel.fromJson(myUser);
      }

      return model;
    } catch (e) {
      debugPrint("Exception to getUserDetail: $e");
      return model;
    }
  }
}
