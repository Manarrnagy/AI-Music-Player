import 'dart:convert';

import 'package:music_app/models/user_model.dart';
import 'package:music_app/music_app.dart';

import '../../domain/core/resources/app_shared_preferences.dart';

class SaveUserData {
  static saveUserMainData(dynamic data) {
    UserModel userModel = UserModel(
      uId: data['uId'],
      name: data['name'],
      email: data['email'],
      birthDate: data['birthDate'],
      profileImage: data['profileImage'],
    );
    MusicApp.userModel = userModel;
    String value = jsonEncode(userModel.toJson());
    AppSharedPreferences().saveUID(value);
  }

  static getUserMainData() async {
    dynamic jsonData;
    dynamic value = AppSharedPreferences().getUID;
    if (value == null || value.isEmpty) {
      return;
    } else {
      jsonData = jsonDecode(value);
      MusicApp.userModel = UserModel.fromJson(jsonData);
    }
  }

  static clearUserData() {
    UserModel userModel = UserModel(
      uId: '',
      name: '',
      email: '',
      profileImage: '',
      birthDate: null,
    );

    MusicApp.userModel = userModel;
    // AppSharedPreferences.setData(key: _userKey, value: value);
  }
}
