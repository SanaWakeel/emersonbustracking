import 'package:emersonbustracking/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/routes/route_name.dart';
import '../viewModel/user_view_model.dart';
import '../res/components/round_button.dart';
import '../viewModel/auth_view_model.dart';

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
        title: const Center(
          child: Text('Home'),
        ),
        actions: [
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
                // final pref = await SharedPreferences.getInstance();
                // pref.setBool('showHome', false);
                Navigator.of(context).pop();
                Navigator.pushNamed(context, RouteName.login);
              }).onError((error, stackTrace) {
                Utils.toastMessage(error.toString());
                Navigator.of(context).pop();
              });
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            RoundButton(
                loading: AuthViewModel.isloading,
                title: "Open Map",
                onPress: () {
                  Navigator.pushNamed(context, RouteName.bustracking);
                }),
            RoundButton(
                loading: AuthViewModel.isloading,
                title: "Open MapView",
                onPress: () {
                  Navigator.pushNamed(context, RouteName.map);
                }),
          ],
        ),
      ),
    );
  }
}
