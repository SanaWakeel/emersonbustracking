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

class CustomerHomeView extends StatefulWidget {
  const CustomerHomeView({Key? key}) : super(key: key);

  @override
  State<CustomerHomeView> createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> {
  final textStyleHeading =
      const TextStyle(color: AppColors.white, fontSize: 22);
  final textStyleLabel = const TextStyle(color: AppColors.white, fontSize: 15);
  final databaseRef = FirebaseDatabase.instance.ref('BusRoutes');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  Widget busRoutesList(DataSnapshot snapshot) {
    return ReusableCard(
        onPress: () {
          Navigator.pushNamed(context, RouteName.bustracking);
        },
        colour: AppColors.primaryColor,
        cardChild: Container(
          width: double.infinity,
          height: 120,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Route ${snapshot.child('busRouteNumber').value}",
                  style: textStyleHeading,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "From:",
                    style: textStyleLabel,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    snapshot.child('sourceLocationName').value.toString(),
                    style: textStyleLabel,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "To:",
                    style: textStyleLabel,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    snapshot.child('destinationLocationName').value.toString(),
                    style: textStyleLabel,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("customer page init");
    databaseRef.onValue.listen((event) {}); // through stream get all data
  }

  @override
  Widget build(BuildContext context) {
    final userPreference = Provider.of<UserViewModel>(context);
    final auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
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
                if (context.mounted) Navigator.of(context).pop();

                var pushNamedAndRemoveUntil = Navigator.pushNamedAndRemoveUntil(
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
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: searchFilter,
                decoration: const InputDecoration(
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
                  defaultChild: const Text('Loading'),
                  itemBuilder: (context, snapshot, animation, index) {
                    final title =
                        snapshot.child('busRouteNumber').value.toString();
                    if (searchFilter.text.isEmpty) {
                      return busRoutesList(snapshot);
                    } else if (title
                        .toLowerCase()
                        .contains(searchFilter.text.toLowerCase().toString())) {
                      return busRoutesList(snapshot);
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
}
