import 'dart:convert';

import 'package:emersonbustracking/enum/user_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AuthenticationService/auth_service.dart';
import '../model/signup_model.dart';
import '../res/colors.dart';
import '../res/components/round_button.dart';
import '../utils/routes/route_name.dart';
import '../utils/utils.dart';
import '../viewModel/auth_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('User');

  ValueNotifier<bool> obsurePassword = ValueNotifier<bool>(true);

  FocusNode emailFocusNode = FocusNode();

  FocusNode passwordFocusNode = FocusNode();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseRef.onValue.listen((event) {}); // through stream get all data
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    obsurePassword.dispose();
  }

  login() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.toString(),
          password: _passwordController.text.toString());
      if (result.user != null) {
        SignUpModel? signUpModel =
            await AuthenticationService().getUserDetail(result.user!.uid);
        debugPrint("SignUp Model after login:$signUpModel");

        if (signUpModel != null) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('userModel', json.encode(signUpModel));
          Utils.userName = "${signUpModel.firstName} ${signUpModel.lastName}";
          Utils.registrationNo = signUpModel.registrationNo.toString();
          Utils.userType = signUpModel.role!;
          Utils.toastMessage("Login Success", AppColors.successToast);
          if (kDebugMode) {
            print("role:${signUpModel.role}");
          }

          var signUpModelShared = json.decode(prefs.getString('userModel')!);
          signUpModelShared = SignUpModel.fromJson(signUpModelShared);
          debugPrint("SignUpModel Role SharedPreference:$signUpModelShared");
          if (context.mounted) Navigator.of(context).pop();
          if (signUpModelShared!.role == UserType.admin.index) {
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     RouteName.adminHome, (Route<dynamic> route) => false);
            if (context.mounted)  Navigator.pushReplacementNamed(context, RouteName.adminHome);
          } else if (signUpModelShared!.role == UserType.user.index) {
            if (context.mounted) Navigator.pushReplacementNamed(context, RouteName.home);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     RouteName.home, (Route<dynamic> route) => false);
            // Navigator.pushReplacementNamed(context, RouteName.home);
          }

          // if (signUpModel.role == 0) {
          //   // Navigator.push(HomeView());
          //   // Navigator.push(
          //   //   context,
          //   //   MaterialPageRoute(builder: (context) => const HomeView()),
          //   // );
          //
          //   Navigator.pushReplacementNamed(context, RouteName.map);
          // } else if (signUpModel.role == 1) {
          //   // Navigator.push(
          //   //   context,
          //   //   MaterialPageRoute(builder: (context) => const CustomerHomeView()),
          //   // );
          //   Navigator.pushReplacementNamed(context, RouteName.home);
          // }
          // Navigator.pushReplacementNamed(context, RouteName.home);
        } else {
          if (context.mounted) Navigator.of(context).pop();
        }
        if (kDebugMode) {
          print("My User Model is:  ${signUpModel?.toJson()}");
        }
      } else {
        if (context.mounted)  Navigator.of(context).pop();
      }
    } catch (e) {
      Navigator.of(context).pop();
      Utils.toastMessage("Error:$e", AppColors.errorToast);
    }

    // await _auth
    //     .signInWithEmailAndPassword(
    //         email: _emailController.text.toString(),
    //         password: _passwordController.text.toString())
    //     .then((value) {
    //   Utils.toastMessage("Login Success");
    //   Navigator.of(context).pop();
    //   Navigator.pushReplacementNamed(context, RouteName.home);
    //
    //   // Utils.toastMessage(value.user!.email.toString());
    // }).onError((error, stackTrace) {
    //   Utils.toastMessage("Error : $error");
    //   Navigator.of(context).pop();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Center(
              child: Text('login'),
            ),
          ),
          body: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: Main
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.white,
                        maxRadius: 80,
                        child: Image.asset('lib/res/images/bus_circle.png'),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        focusNode: emailFocusNode,
                        decoration: const InputDecoration(
                          hintText: "abc@gmail.com",
                          label: Text("Email"),
                          prefixIcon: Icon(Icons.email),
                        ),
                        onFieldSubmitted: (value) {
                          Utils.fieldFocusChange(
                              context, emailFocusNode, passwordFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter email";
                          }
                          return null;
                        },
                      ),
                      ValueListenableBuilder(
                          valueListenable: obsurePassword,
                          builder: (context, value, child) {
                            return TextFormField(
                                focusNode: passwordFocusNode,
                                controller: _passwordController,
                                obscureText: obsurePassword.value,
                                obscuringCharacter: "*",
                                decoration: InputDecoration(
                                  hintText: "enter password",
                                  label: const Text("Password"),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffix: InkWell(
                                      onTap: () {
                                        obsurePassword.value =
                                            !obsurePassword.value;
                                      },
                                      child: Icon(obsurePassword.value
                                          ? Icons.visibility
                                          : Icons.visibility_off)),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter password";
                                  } else if (value.length < 8) {
                                    return "Please enter 8 digit password";
                                  }
                                  return null;
                                });
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      RoundButton(
                          loading: AuthViewModel.isloading,
                          title: "Login",
                          onPress: () async {
                            if (_formKey.currentState!.validate()) {
                              // Utils.flushBarErrorMessage(
                              //     "Successfully log in", context);
                              await login();
                            }

                            // if (_emailController.text.isEmpty) {
                            //   Utils.flushBarErrorMessage(
                            //       "Please Enter Email", context);
                            // } else if (_passwordController.text.isEmpty) {
                            //   Utils.flushBarErrorMessage(
                            //       "Please Enter Password", context);
                            // } else if (_passwordController.text.length < 8) {
                            //   Utils.flushBarErrorMessage(
                            //       "Please Enter 8 digit password", context);
                            // } else {
                            //   Map data = {
                            //     "email": _emailController.text.toString(),
                            //     "password": _passwordController.text.toString(),
                            //     // "email": "eve.holt@reqres.in",
                            //     // "password": "cityslicka",
                            //   };
                            // authViewModel.loginApi(data, context);
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RouteName.signup);
                        },
                        child: const Text("Don't have an account? Sign up"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Center(
          //   child: InkWell(
          //     onTap: () {
          //       Utils.snackBar('message 1', context);
          //       // Utils.flushBarErrorMessage('message 2', context);
          //       // Utils.toastMessage("Login btn Clicked");
          //
          //       // Navigator.pushNamed(context, RouteName.home);
          //     },
          //     child: Text('Go to Home Page'),
          //   ),
          // ),
        ),
      ),
    );
  }
}
