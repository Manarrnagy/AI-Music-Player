import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_app/ui/core/layout/main_layout.dart';

import '../../domain/core/resources/app_assets_paths.dart';
import '../../music_app.dart';
import 'login/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int needUpdate = -1;
  // keeps splash screen for 2 seconds before navigating to the next page
  startSplashScreen() async {
    const duration = Duration(seconds: 2);
    return Timer(duration, navigateToHomePage);
  }

  // navigates to home page if user is logged in otherwise it navigates
  // user to login page
  // The app doesn't cache the last played song
  void navigateToHomePage() {
    if (MusicApp.isLoggedIn) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const MainLayout(),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  // building the splash screen
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    MusicApp.mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: mediaQuery.size.width *
                    0.4, //this gets the width of the page * 0.4
                child: Hero(
                  tag: "AppLogo",
                  child: Image.asset(
                    AppAssets.appLogo,
                    width: mediaQuery.size.width * 0.4,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
