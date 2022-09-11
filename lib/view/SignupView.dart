import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/components/round_button.dart';
import '../utils/routes/route_name.dart';
import '../utils/utils.dart';
import '../viewModel/authViewModel.dart';

class SignupView extends StatefulWidget {
  // const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  ValueNotifier<bool> obsurePassword = new ValueNotifier<bool>(true);

  FocusNode emailFocusNode = FocusNode();

  FocusNode passwordFocusNode = FocusNode();

  void dispose() {
    // super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    obsurePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final height = MediaQuery.of(context).size.height * 1;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('SignUp'),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: Main
          children: [
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
                            obsurePassword.value = !obsurePassword.value;
                          },
                          child: Icon(obsurePassword.value
                              ? Icons.visibility
                              : Icons.visibility_off)),
                    ),
                  );
                }),
            SizedBox(
              height: height * .085,
            ),
            RoundButton(
                loading: AuthViewModel.isloadingSignUp,
                title: "SignUp",
                onPress: () {
                  if (_emailController.text.isEmpty) {
                    Utils.flushBarErrorMessage("Please Enter Email", context);
                  } else if (_passwordController.text.isEmpty) {
                    Utils.flushBarErrorMessage(
                        "Please Enter Password", context);
                  } else if (_passwordController.text.length < 6) {
                    Utils.flushBarErrorMessage(
                        "Please Enter 6 digit password", context);
                  } else {
                    Map data = {
                      "email": _emailController.text.toString(),
                      "password": _passwordController.text.toString(),
                      // "email": "eve.holt@reqres.in",
                      // "password": "cityslicka",
                    };
                    var x = authViewModel.signupApi(data, context);
                    print(x);
                    Utils.flushBarErrorMessage("Ápi hit", context);
                  }
                }),
            SizedBox(
              height: height * .02,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteName.login);
              },
              child: Text("Already have an account? Login"),
            ),
          ],
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
    );
  }
}
