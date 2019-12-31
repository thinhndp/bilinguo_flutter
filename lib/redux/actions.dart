import 'package:bilinguo_flutter/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Action {
  Set
}

class ActionSetUser {
  final User user;

  ActionSetUser(this.user);
}