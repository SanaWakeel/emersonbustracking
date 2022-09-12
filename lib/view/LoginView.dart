import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../res/colors.dart';
import '../res/components/round_button.dart';
import '../utils/routes/route_name.dart';
import '../utils/utils.dart';
import '../viewModel/authViewModel.dart';
import 'HomeView.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  ValueNotifier<bool> obsurePassword = new ValueNotifier<bool>(true);

  FocusNode emailFocusNode = FocusNode();

  FocusNode passwordFocusNode = FocusNode();
  final _auth = FirebaseAuth.instance;

  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    obsurePassword.dispose();
  }

  void login() async{

    showDialog(context: context, builder: (context){
      return Center(child: CircularProgressIndicator(),);
    });
    
    await _auth
        .signInWithEmailAndPassword(
            email: _emailController.text.toString(),
            password: _passwordController.text.toString())
        .then((value) {
      Utils.toastMessage("Login Success");
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeView()));
      // Utils.toastMessage(value.user!.email.toString());
    }).onError((error, stackTrace) {

      Utils.toastMessage("Error : $error");
      Navigator.of(context).pop();
    });


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
            title: Center(
              child: Text('login'),
            ),
          ),
          body: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.all(32),
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
                          child: Image.asset('lib/res/images/bus_circle.png'),
                          backgroundColor: AppColors.white,
                          maxRadius: 80,

                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          focusNode: emailFocusNode,
                          decoration: InputDecoration(
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
                                    label: Text("Password"),
                                    prefixIcon: Icon(Icons.lock),
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
                        SizedBox(
                          height: 30,
                        ),
                        RoundButton(
                            loading: AuthViewModel.isloading,
                            title: "Login",
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                // Utils.flushBarErrorMessage(
                                //     "Successfully log in", context);
                                login();
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
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, RouteName.signup);
                          },
                          child: Text("Don't have an account? Sign up"),
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
