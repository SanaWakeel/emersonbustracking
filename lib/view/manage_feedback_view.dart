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
import 'package:firebase_database/firebase_database.dart';
import 'widgets/drawer_menu.dart';

class ManageFeedbackView extends StatefulWidget {
  const ManageFeedbackView({Key? key}) : super(key: key);

  @override
  State<ManageFeedbackView> createState() => _ManageFeedbackViewState();
}

class _ManageFeedbackViewState extends State<ManageFeedbackView> {
  final textStyleHeading =
      const TextStyle(color: AppColors.white, fontSize: 22);
  final textStyleLabel = const TextStyle(color: AppColors.white, fontSize: 15);
  final databaseRef = FirebaseDatabase.instance.ref('Feedback');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  Widget BusRoutesList(DataSnapshot snapshot) {
    return ReusableCard(
      onPress: () {
        // Navigator.pushNamed(context, RouteName.bustracking);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "registrationNo:",
                      style: textStyleLabel,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    snapshot.child('registrationNo').value != null
                        ? Text(
                            snapshot.child('registrationNo').value.toString(),
                            style: textStyleLabel,
                          )
                        : Text(
                            "",
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
                      "Feedback:",
                      style: textStyleLabel,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      snapshot.child('feedback').value.toString(),
                      style: textStyleLabel,
                    ),
                  ],
                ),
              ],
            ),
            /*  Positioned(
              right: 5,
              bottom: 20,
              child: PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.white,
                ),
                itemBuilder: (context) => [
                  // PopupMenuItem(
                  //     value: 1,
                  //     child: ListTile(
                  //       onTap: () {
                  //         Navigator.pop(context);
                  //         showModalBottomSheet(
                  //           context: context,
                  //           builder: (BuildContext context) {
                  //             return EditBusRouteScreen(
                  //               busRouteNumber: int.parse(snapshot
                  //                   .child('busRouteNumber')
                  //                   .value
                  //                   .toString()),
                  //               sourceLocationName: snapshot
                  //                   .child('sourceLocationName')
                  //                   .value
                  //                   .toString(),
                  //               sourceLocationLatitude: snapshot
                  //                   .child('sourceLocationLatitude')
                  //                   .value
                  //                   .toString(),
                  //               sourceLocationLongitude: snapshot
                  //                   .child('sourceLocationLongitude')
                  //                   .value
                  //                   .toString(),
                  //               destinationLocationName: snapshot
                  //                   .child('destinationLocationName')
                  //                   .value
                  //                   .toString(),
                  //               destinationLocationLatitude: snapshot
                  //                   .child('destinationLocationLatitude')
                  //                   .value
                  //                   .toString(),
                  //               destinationLocationLongitude: snapshot
                  //                   .child('destinationLocationLongitude')
                  //                   .value
                  //                   .toString(),
                  //               onItemSaved: (int _busRouteNumber,
                  //                   String sourceLocation,
                  //                   double sourceLocationLongitude,
                  //                   double sourceLocationLatitude,
                  //                   String destinationLocationName,
                  //                   double destinationLocationLatitude,
                  //                   double destinationLocationLongitude) {
                  //                 // setState(() {
                  //                 databaseRef
                  //                     .child(
                  //                         snapshot.child('id').value.toString())
                  //                     .update({
                  //                   // 'fname': editController.text.toString(),
                  //                   'busRouteNumber': _busRouteNumber,
                  //                   'sourceLocationName': sourceLocation,
                  //                   'sourceLocationLatitude':
                  //                       sourceLocationLatitude,
                  //                   'sourceLocationLongitude':
                  //                       sourceLocationLongitude,
                  //                   'destinationLocationName':
                  //                       destinationLocationName,
                  //                   'destinationLocationLatitude':
                  //                       destinationLocationLatitude,
                  //                   'destinationLocationLongitude':
                  //                       destinationLocationLongitude,
                  //                 }).then((value) {
                  //                   Utils.toastMessage(
                  //                       'updated', AppColors.successToast);
                  //                 }).onError((error, stackTrace) =>
                  //                         Utils.toastMessage(error.toString(),
                  //                             AppColors.errorToast));
                  //                 // items[index] = newItem;
                  //                 // });
                  //                 Navigator.pop(context);
                  //               },
                  //             );
                  //             /*  showMyDialog(snapshot.child('lname').value.toString(),
                  //             snapshot.child('id').value.toString());  */
                  //           },
                  //         );
                  //       },
                  //       leading: Icon(Icons.edit),
                  //       title: Text('Edit'),
                  //     )),
                  PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        onTap: () async {
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
           */
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseRef.onValue.listen((event) {}); // through stream get all data
  }

  @override
  Widget build(BuildContext context) {
    final userPreference = Provider.of<UserViewModel>(context);
    final auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Feedback'),
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
                Utils.toastMessage(error.toString(), AppColors.errorToast);
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
                  hintText: "enter registration number",
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
                    final registrationNo =
                        snapshot.child('registrationNo').value.toString();

                    if (searchFilter.text.isEmpty) {
                      return BusRoutesList(snapshot);
                    } else if (registrationNo
                        .toLowerCase()
                        .contains(searchFilter.text.toLowerCase().toString())) {
                      return BusRoutesList(snapshot);
                    } else {
                      return Container();
                    }
                  }),
            ),
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
                      Utils.toastMessage('updated', AppColors.successToast);
                    }).onError((error, stackTrace) => Utils.toastMessage(
                            error.toString(), AppColors.errorToast));
                  },
                  child: Text("Update")),
            ],
          );
        });
  }
}
