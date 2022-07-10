import 'package:flutter/material.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/domain/core/resources/app_shared_preferences.dart';
import 'package:music_app/ui/view/splash_screen.dart';

import 'models/user_model.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({Key? key}) : super(key: key);

  //initialize user
  static UserModel userModel = UserModel();
  static bool isLoggedIn = false;
  // Takes information about a piece of media (maybe null)
  // MediaQuery : obtains the size of the mobile screen (We use it to make app responsive)
  static MediaQueryData? mediaQuery;

  @override
  Widget build(BuildContext context) {
    // if isloggedin is null it gets value false
    isLoggedIn = AppSharedPreferences().getIsLoggedIn() ?? false;
    return MaterialApp(
      // hides the debug banner
      debugShowCheckedModeBanner: false,
      // default colors in the application
      theme: ThemeData(
          primarySwatch: AppColors.mainColor,
          scaffoldBackgroundColor: AppColors.backgroundColor),
      //gives a title description for the app
      title: 'Music App',
      // displays the splash screen as the first screen in the app
      home: const SplashScreen(),
    );
  }
}
