import 'package:emersonbustracking/utils/utils.dart';
import 'package:emersonbustracking/view/widgets/reusable_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../res/colors.dart';
import '../utils/routes/route_name.dart';
import '../viewModel/user_view_model.dart';
import '../res/components/round_button.dart';
import '../viewModel/auth_view_model.dart';
import 'package:firebase_database/firebase_database.dart';

import 'widgets/drawer_menu.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final textStyleHeading =
      const TextStyle(color: AppColors.white, fontSize: 22);
  final textStyleLabel = const TextStyle(color: AppColors.white, fontSize: 15);
  final databaseRef = FirebaseDatabase.instance.ref('BusRoutes');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  Widget BusRoutesList(DataSnapshot snapshot) {
    return ReusableCard(
      onPress: () {
        Navigator.pushNamed(context, RouteName.bustracking);
      },
      colour: AppColors.primaryColor,
      cardChild: Container(
        width: double.infinity,
        height: 150,
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Route ${snapshot.child('busRouteNumber').value}",
                    style: textStyleHeading,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "id:",
                      style: textStyleLabel,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      snapshot.child('id').value.toString(),
                      style: textStyleLabel,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "From:",
                      style: textStyleLabel,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      snapshot.child('sourceLocationName').value.toString(),
                      style: textStyleLabel,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "To:",
                      style: textStyleLabel,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      snapshot
                          .child('destinationLocationName')
                          .value
                          .toString(),
                      style: textStyleLabel,
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 5,
              bottom: 20,
              child: PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.white,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          showMyDialog(snapshot.child('lname').value.toString(),
                              snapshot.child('id').value.toString());
                        },
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                      )),
                  PopupMenuItem(
                      value: 2,
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          databaseRef
                              .child(snapshot.child('id').value.toString())
                              .remove();
                        },
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("adim page init");
    databaseRef.onValue.listen((event) {}); // through stream get all data
  }

  @override
  Widget build(BuildContext context) {
    final userPreference = Provider.of<UserViewModel>(context);
    final auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  });

              auth.signOut().then((value) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('userModel');
                // final pref = await SharedPreferences.getInstance();
                // pref.setBool('showHome', false);
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteName.login, (route) => false);
              }).onError((error, stackTrace) {
                Utils.toastMessage(error.toString());
                Navigator.of(context).pop();
              });
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      drawer: DrawerMenu(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: searchFilter,
                decoration: InputDecoration(
                  hintText: "Search bus root number",
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),

            Expanded(
              child: FirebaseAnimatedList(
                  query: databaseRef,
                  defaultChild: Text('Loading'),
                  itemBuilder: (context, snapshot, animation, index) {
                    final title =
                        snapshot.child('busRouteNumber').value.toString();
                    if (searchFilter.text.isEmpty) {
                      return BusRoutesList(snapshot);
                    } else if (title
                        .toLowerCase()
                        .contains(searchFilter.text.toLowerCase().toString())) {
                      return BusRoutesList(snapshot);
                    } else {
                      return Container();
                    }
                  }),
            ),

            // Expanded(
            //     child: StreamBuilder(
            //       stream: databaseRef.onValue,
            //       builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            //         if (!snapshot.hasData) {
            //           return CircularProgressIndicator();
            //         } else {
            //           Map<dynamic, dynamic> map =
            //           snapshot.data!.snapshot.value as dynamic;
            //           List<dynamic> list = [];
            //           list.clear();
            //           list = map.values.toList();
            //           return ListView.builder(
            //             itemCount: snapshot.data!.snapshot.children.length,
            //             itemBuilder: (context, index) {
            //               return ListTile(
            //                 title: Text(list[index]['fname']),
            //                 subtitle: Text(list[index]['id']),
            //               );
            //             },
            //           );
            //         }
            //       },
            //     )),
          ],
        ),
      ),
    );
  }

  Future<void> showMyDialog(String fname, String id) async {
    editController.text = fname;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(
                  hintText: "edit",
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    databaseRef
                        .child('id')
                        .update({'fname': editController.text.toString()}).then(
                            (value) {
                      Utils.toastMessage('updated');
                    }).onError((error, stackTrace) =>
                            Utils.toastMessage(error.toString()));
                  },
                  child: Text("Update")),
            ],
          );
        });
  }
}
