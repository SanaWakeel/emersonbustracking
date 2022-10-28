import 'package:emersonbustracking/model/signup_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../res/colors.dart';
import '../res/components/round_button.dart';
import '../utils/routes/route_name.dart';
import '../utils/utils.dart';
import '../viewModel/auth_view_model.dart';
import 'package:firebase_database/firebase_database.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final databaseRef = FirebaseDatabase.instance.ref('User');

  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ValueNotifier<bool> obsurePassword = ValueNotifier<bool>(true);

  FocusNode fnameFocusNode = FocusNode();
  FocusNode lnameFocusNode = FocusNode();
  FocusNode ageFocusNode = FocusNode();
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

  void signUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    final pref = await SharedPreferences.getInstance();
    try {
      UserCredential? result = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.toString(),
          password: _passwordController.text.toString());

      //     .then((value) {
      //
      //
      //   // Utils.toastMessage(value.user!.email.toString());
      // }).onError((error, stackTrace) {
      //   Utils.toastMessage("Error : $error");
      //   Navigator.of(context).pop();
      // });
      if (result.user != null) {
        print("uid: ${result.user?.uid}");
        String? nodeKey = databaseRef.push().key;
        debugPrint("token from sharedP:${pref.getString("fcmToken")}");
        SignUpModel signUpModel = SignUpModel(
            id: result.user!.uid,
            firstName: _fnameController.text,
            lastName: _lnameController.text,
            email: _emailController.text,
            age: int.parse(_ageController.text),
            deviceToken: pref.getString("fcmToken"),
            timeStamp: DateTime.now().millisecondsSinceEpoch,
            role: 1);
        databaseRef
            .child(result.user!.uid)
            .set(signUpModel.toJson())
            .then((value) {
          Utils.toastMessage("Signup Success");
          Navigator.of(context).pop();
          Navigator.pushNamed(context, RouteName.home);
        }).onError((error, stackTrace) => Utils.toastMessage(error.toString()));
      }
    } catch (e) {
      Navigator.of(context).pop();
      Utils.toastMessage("Error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              "Signup",
            ),
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
                      child: Image.asset('lib/res/images/bus_circle.png'),
                      backgroundColor: AppColors.white,
                      maxRadius: 80,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _fnameController,
                      focusNode: fnameFocusNode,
                      decoration: const InputDecoration(
                        hintText: "first name",
                        label: Text("First name"),
                        // prefixIcon: Icon(Icons.person),
                      ),
                      onFieldSubmitted: (value) {
                        Utils.fieldFocusChange(
                            context, fnameFocusNode, lnameFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter first name";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _lnameController,
                      focusNode: lnameFocusNode,
                      decoration: const InputDecoration(
                        hintText: "last name",
                        label: Text("Last name"),
                        // prefixIcon: Icon(Icons.person),
                      ),
                      onFieldSubmitted: (value) {
                        Utils.fieldFocusChange(
                            context, lnameFocusNode, ageFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter last name";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _ageController,
                      focusNode: ageFocusNode,
                      decoration: const InputDecoration(
                        hintText: "age",
                        label: Text("Age"),
                        // prefixIcon: Icon(Icons.person),
                      ),
                      onFieldSubmitted: (value) {
                        Utils.fieldFocusChange(
                            context, ageFocusNode, emailFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter age";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      focusNode: emailFocusNode,
                      decoration: const InputDecoration(
                        hintText: "abc@gmail.com",
                        label: Text("Email"),
                        // prefixIcon: Icon(Icons.email),
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
                                // prefixIcon: const Icon(Icons.lock),
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
                        title: "Signup",
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            // Utils.flushBarErrorMessage(
                            //     "Successfully log in", context);
                            signUp();
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
                        Navigator.pop(context);
                      },
                      child: const Text("Already have an account? Login"),
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
    );
    //   WillPopScope(
    //   // onWillPop: () async {
    //   //   SystemNavigator.pop();
    //   //   return true;
    //   // },
    //   child: ,
    // );
  }
}
