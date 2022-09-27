import 'package:emersonbustracking/res/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/routes/route.dart';
import 'utils/routes/route_name.dart';
import 'viewModel/authViewModel.dart';
import 'viewModel/userViewModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final pref = await SharedPreferences.getInstance();
  final showHomeV = pref.getBool('showHome') ?? false;
  runApp(MyApp(showHome: showHomeV));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final bool showHome;

  const MyApp({Key? key, required this.showHome}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bus Tracking App',
        theme: ThemeData(
            primaryColor: Colors.teal,
            appBarTheme: AppBarTheme(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white //here you can give the text color
                )),

        // initialRoute: RouteName.splash,
        // initialRoute: RouteName.bustracking,
        initialRoute: RouteName.splash,
        // initialRoute: showHome ? RouteName.home : RouteName.onboarding,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
