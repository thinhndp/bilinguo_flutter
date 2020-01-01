import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

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

  static Future<User> getUserByToken(token) async {
    try {
      var response = await http.get(
        'https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/getUserByToken',
        headers: { 'Authorization': 'Bearer ' + token },
      );
      // print('complete');
      final responseJSON = json.decode(response.body);
      // print(responseJSON);
      return User(
        token: token,
        uid: responseJSON['uid'],
        email: responseJSON['email'],
        displayName: responseJSON['displayName'],
        profilePicture: responseJSON['profilePicture'],
        fortune: responseJSON['fortune'],
        inventory: responseJSON['inventory'],
      );
    }
    catch(err) {
      print(err);
    }
  }

  static Future<User> updateUserProfile(token, newUserInfo) async {
    try {
      await http.post(
        "https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/updateUserProfile",
        headers: { 'Authorization': 'Bearer ' + token },
        body: { 'profilePicture': newUserInfo.profilePicture }
      );
      User user = await User.getUserByToken(token);
      return user;
    }
    catch(err) {
      print(err);
    }
  }
}