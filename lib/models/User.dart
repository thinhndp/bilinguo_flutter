import 'dart:convert';

class User {
  String token;
  String uid;
  String email;
  String displayName;
  String profilePicture;
  int fortune;
  List<dynamic> inventory;

  User({String token, String uid, String email, String displayName, String profilePicture, int fortune, List<dynamic> inventory}) {
    this.token = token;
    this.uid = uid;
    this.email = email;
    this.displayName = displayName;
    this.profilePicture = profilePicture;
    this.fortune = fortune;
    this.inventory = inventory != null ? List.from(inventory) : [] ;
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