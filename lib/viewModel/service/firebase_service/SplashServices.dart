import 'dart:async';
import 'package:emersonbustracking/view/HomeView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../view/LoginView.dart';

class SplashServices{



  void isLogin(BuildContext context){
    final auth=FirebaseAuth.instance;
    final user=auth.currentUser;

    if(user!=null){
      Timer(Duration(seconds: 3),()=>Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomeView())));
    }else{
      Timer(Duration(seconds: 3),()=>Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginView())));
    }


  }
}