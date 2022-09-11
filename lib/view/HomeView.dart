import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/routes/route_name.dart';
import '../viewModel/userViewModel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final userPreference = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                userPreference.remove().then((value) {
                  Navigator.pushNamed(context, RouteName.login);
                });
              },
              child: Text("logout"),
            ),
          ],
        ),
      ),
    );
  }
}
