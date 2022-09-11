import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/routes/route.dart';
import 'utils/routes/route_name.dart';
import 'viewModel/authViewModel.dart';
import 'viewModel/userViewModel.dart';

void main() {
  runApp(const MyApp());
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
        title: 'Bus Tracking App',
        initialRoute: RouteName.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
