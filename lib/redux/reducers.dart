import 'package:bilinguo_flutter/models/AppState.dart';
import 'package:bilinguo_flutter/models/User.dart';
import 'package:bilinguo_flutter/redux/actions.dart';
// import 'package:firebase_auth/firebase_auth.dart';

AppState appStateReducer(AppState state, dynamic action) {
  return AppState(
    currentUser: userReducer(state.currentUser, action)
  );
}

User userReducer(User state, action) {
  if (action is ActionSetUser) {
    return action.user;
  }

  return state;
}