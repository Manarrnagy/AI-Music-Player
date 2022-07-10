import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static late SharedPreferences sharedPreferences;

// obtains shared preferences to store user data on user's device
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // ========================== Get Preference =======================================
  // saves login status on user's device
  Future<bool> saveIsLoggedIn(bool isLoggedIn) =>
      sharedPreferences.setBool('isLoggedIn', isLoggedIn);
  // saves users id on user's device
  Future<bool> saveUID(String uid) => sharedPreferences.setString('uID', uid);

// ========================== Get Preference =======================================
  // returns login status from user's device
  bool? getIsLoggedIn() => sharedPreferences.getBool('isLoggedIn');
  // returns user id from user's device
  String? getUID() => sharedPreferences.getString('uID');
}
