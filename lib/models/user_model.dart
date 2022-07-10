import 'package:cloud_firestore/cloud_firestore.dart';

// defines a user using user id, user name, user email, birthdate and profile image
class UserModel {
  String? uId;
  String? name;
  String? email;
  Timestamp? birthDate;
  String? profileImage;

  UserModel({
    this.uId,
    this.name,
    this.email,
    this.birthDate,
    this.profileImage,
  });
// converts user id, user name, user email, birthdate and profile image from
// firebase json files (firebase files are .json extension) to store them in the app
  UserModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    email = json['email'];
    birthDate = json['birthDate'];
    profileImage = json['profileImage'];
  }
// converts user id, user name, user email, birthdate and profile image to json files to send to firebase
  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'birthDate': birthDate,
      'profileImage': profileImage,
    };
  }
}
