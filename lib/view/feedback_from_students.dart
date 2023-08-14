
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/feedback_model.dart';
import '../res/colors.dart';
import '../res/components/round_button.dart';
import '../utils/utils.dart';
import '../viewModel/auth_view_model.dart';
import 'package:firebase_database/firebase_database.dart';

import 'widgets/drawer_menu.dart';

class FeedbackStudentsView extends StatefulWidget {
  const FeedbackStudentsView({Key? key}) : super(key: key);

  @override
  State<FeedbackStudentsView> createState() => _FeedbackStudentsViewState();
}

class _FeedbackStudentsViewState extends State<FeedbackStudentsView> {
  final _formKey = GlobalKey<FormState>();
  final databaseRef = FirebaseDatabase.instance.ref('Feedback');

  final TextEditingController _feedbackController = TextEditingController();

  FocusNode feedbackFocusNode = FocusNode();
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    feedbackFocusNode.dispose();
  }

  void saveFeedback() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    final pref = await SharedPreferences.getInstance();
    try {
      String? nodeKey = databaseRef.push().key;
      FeedbackModel feedbackModel = FeedbackModel(
        id: nodeKey,
        feedback: _feedbackController.text,
        registrationNo: Utils.registrationNo,
        timeStamp: DateTime.now().millisecondsSinceEpoch,
      );
      databaseRef
          .child(nodeKey!)
          .set(feedbackModel.toJson())
          .then((value) async {
        Utils.toastMessage(
            "your feedback submitted successfully", AppColors.successToast);
        Navigator.of(context).pop();
      }).onError((error, stackTrace) {
        Utils.toastMessage(error.toString(), AppColors.errorToast);
        Navigator.of(context).pop();
      });
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      Utils.toastMessage("Error:$e", AppColors.errorToast);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return SafeArea(
      child: Scaffold(
        drawer: DrawerMenu(),
        appBar: AppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              "Feedback",
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
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 2, //Normal textInputField will be displayed
                      maxLines: null,
                      controller: _feedbackController,
                      focusNode: feedbackFocusNode,
                      decoration: const InputDecoration(
                        hintText: "enter your feedback",
                        label: Text("Feedback"),
                        // prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter feedback";
                        }
                        return null;
                      },
                    ),
                    /*  TextFormField(
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
                            context, lnameFocusNode, registrationFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter last name";
                        }
                        return null;
                      },
                    ), */
                    const SizedBox(
                      height: 30,
                    ),
                    RoundButton(
                        loading: AuthViewModel.isloading,
                        title: "Submit",
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            // Utils.flushBarErrorMessage(
                            //     "Successfully log in", context);
                            saveFeedback();
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
