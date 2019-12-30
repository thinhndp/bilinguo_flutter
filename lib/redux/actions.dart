import 'package:firebase_auth/firebase_auth.dart';

enum Action {
  Set
}

class ActionSetUser {
  final FirebaseUser user;

  ActionSetUser(this.user);
}