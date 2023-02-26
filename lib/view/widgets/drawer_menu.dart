import 'package:emersonbustracking/res/colors.dart';
import 'package:flutter/material.dart';

import '../../enum/user_type.dart';
import '../../utils/routes/route_name.dart';
import '../../utils/utils.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> listTiles =
        Utils.UserType == UserType.admin.index //admin
            ? [
                ListTile(
                  title: Text('Manage Students'),
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.manageStudents);
                    // ...
                  },
                ),
                ListTile(
                  title: Text('Manage Feedback'),
                  onTap: () {
                    // ...
                  },
                ),
              ]
            : [
                ListTile(
                  title: Text('My Profile'),
                  onTap: () {
                    // ...
                  },
                ),
                ListTile(
                  title: Text('My Route'),
                  onTap: () {
                    // ...
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
                            style: TextStyle(color: Colors.black),
                            // style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            Utils.registrationNo,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          FloatingActionButton(
                            heroTag: "backbtn",
                            mini: true,
                            elevation: 15,
                            tooltip: "Back",
                            //focusElevation: 15,
                            backgroundColor: AppColors.btnColor,
                            onPressed: () async {},
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
