import 'package:emersonbustracking/res/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../enum/user_type.dart';
import '../../utils/routes/route_name.dart';
import '../../utils/utils.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final List<Widget> listTiles =
        Utils.userType == UserType.admin.index //admin
            ? [
                ListTile(
                  title: const Text('Dashboard'),
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.adminHome);
                  },
                ),
                ListTile(
                  title: const Text('Manage Students'),
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.manageStudents);
                  },
                ),
                ListTile(
                  title: const Text('Manage Feedback'),
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.manageFeedbackView);
                  },
                ),
              ]
            : [
                ListTile(
                  title: const Text('Dashboard'),
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.home);
                  },
                ),
                /* ListTile(
                  title: Text('My Profile'),
                  onTap: () {},
                ), */
                ListTile(
                  title: const Text('Give FeedBack'),
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.giveFeedback);
                  },
                ),
              ];
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              margin: const EdgeInsets.only(bottom: 0),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image(
                  //   image: AssetImage("assets/logo-01_600x.png"),
                  //   width: double.maxFinite,
                  // ),
                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.userName,
                            style: const TextStyle(color: Colors.black),
                            // style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            Utils.registrationNo,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          FloatingActionButton(
                            heroTag: "backbtn",
                            mini: true,
                            elevation: 15,
                            tooltip: "sign out",
                            //focusElevation: 15,
                            backgroundColor: AppColors.btnColor,
                            onPressed: () async {
                              auth.signOut().then((value) async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove('userModel');
                                if (context.mounted) Navigator.of(context).pop();


                                Navigator.pushNamedAndRemoveUntil(
                                    context, RouteName.login, (route) => false);
                              }).onError((error, stackTrace) {
                                Utils.toastMessage(
                                    error.toString(), AppColors.errorToast);
                                Navigator.of(context).pop();
                              });
                            },
                            child: Image.asset(
                              'lib/res/images/logout.png',
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Text(headItem.title, style: const TextStyle(color: Colors.black, fontSize: 20),),
                ],
              )),
          ...listTiles,
        ],
      ),
    );
  }
}
