import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/routes/route.dart';
import 'utils/routes/route_name.dart';
import 'viewModel/authViewModel.dart';
import 'viewModel/userViewModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bus Tracking App',
        initialRoute: RouteName.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
