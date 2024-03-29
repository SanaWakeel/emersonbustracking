import 'package:flutter/material.dart';
import '../viewModel/service/firebase_service/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              // color: Colors.blue,
              child: Image.asset('lib/res/images/bus_circle.png'),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Emerson Bus Tracking',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      // Image.asset('lib/res/images/splash.jpeg'),
    );
  }
}
