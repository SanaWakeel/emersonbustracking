import 'package:emersonbustracking/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/routes/route_name.dart';
import '../viewModel/userViewModel.dart';
import 'LoginView.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final userPreference = Provider.of<UserViewModel>(context);
    final auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Home'),),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  });

              auth.signOut().then((value) {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, RouteName.login);
              }).onError((error, stackTrace) {
                Utils.toastMessage(error.toString());
                Navigator.of(context).pop();
              });
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // InkWell(
            //   onTap: () {
            //     showDialog(
            //         context: context,
            //         builder: (context) {
            //           return Center(
            //             child: CircularProgressIndicator(),
            //           );
            //         });
            //
            //     userPreference.remove().then((value) {
            //       Navigator.pushReplacement(context,
            //           MaterialPageRoute(builder: (context) => LoginView()));
            //     });
            //     Navigator.of(context).pop();
            //   },
            //   child: Text("logout"),
            // ),
          ],
        ),
      ),
    );
  }
}
