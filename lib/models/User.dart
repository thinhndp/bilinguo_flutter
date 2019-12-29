import 'dart:convert';

class User {
  String uid;
  String displayName;
  String profilePicture;
  String email;

  User({String uid, String displayName, String profilePicture, String email}) {
    this.uid = uid;
    this.displayName = displayName;
    this.profilePicture = profilePicture;
    this.email = email;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      displayName: json['displayName'],
      profilePicture: json['profilePicture'],
      email: json['email'],
    );
  }
}