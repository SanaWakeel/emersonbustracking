import 'package:emersonbustracking/utils/routes/route_name.dart';
import 'package:emersonbustracking/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required String subTitle,
  }) =>
      Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              urlImage,
              fit: BoxFit.cover,
              width: double.infinity,
              // height: 80.0,
            ),
            const SizedBox(
              height: 64,
            ),
            Text(
              title,
              style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              subTitle,
              style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: PageView(
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          controller: controller,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 120, 0, 0),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/res/images/onboarding1.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    // height: 80.0,
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Track University Bus",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "From Pickup to Drop",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/res/images/onboarding2.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    // height: 80.0,
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Smart Notification",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "From Pickup to Drop",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/res/images/onboarding3.png',
                      fit: BoxFit.fitWidth, width: 290
                      // height: 80.0,
                      ),
                  const SizedBox(
                    height: 64,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Emerson Bus Tracking",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Your Profile will be Prefilled from University",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // buildPage(
            //   urlImage: 'lib/res/images/onboarding1.jpg',
            //   color: Colors.white,
            //   title: "Track University Bus",
            //   subTitle: "From Pickup to Drop",
            // ),
            // buildPage(
            //   urlImage: 'lib/res/images/onboarding2.png',
            //   color: Colors.white,
            //   title: "Smart Notification",
            //   subTitle: "From Pickup to Drop",
            // ),
            // buildPage(
            //   urlImage: 'lib/res/images/onboarding3.png',
            //   color: Colors.white,
            //   title: "Emerson Bus Tracking",
            //   subTitle: "Your Profile will be Prefilled from University",
            // ),
            // Container(
            //   color: Colors.red,
            //   child: const Center(
            //     child: Text("Page1"),
            //   ),
            // ),
            // Container(
            //   color: Colors.green,
            //   child: const Center(
            //     child: Text("Page2"),
            //   ),
            // ),
            // Container(
            //   color: Colors.yellow,
            //   child: const Center(
            //     child: Text("Page3"),
            //   ),
            // ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.primaryColor,
                  // backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size.fromHeight(80)),
              child: const Text(
                "Get started",
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () async {
                final pref = await SharedPreferences.getInstance();
                pref.setBool('showHome', true);
                Navigator.pushReplacementNamed(context, RouteName.login);
                // Navigator.pushNamed(context, RouteName.home);
              },
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => controller.jumpTo(2),
                    child: const Text("skip"),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: const WormEffect(
                        spacing: 16,
                        dotColor: Colors.black26,
                        activeDotColor: AppColors.primaryColor,
                      ),
                      onDotClicked: (index) => controller.animateToPage(index,
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeIn),
                    ),
                  ),
                  TextButton(
                    onPressed: () => controller.nextPage(
                        duration: const Duration(microseconds: 500),
                        curve: Curves.easeInOut),
                    child: const Text("Next"),
                  )
                ],
              ),
            ),
    );
  }
}
