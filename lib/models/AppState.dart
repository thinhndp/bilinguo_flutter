import 'package:bilinguo_flutter/redux/actions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';

class AppState {
  final FirebaseUser currentUser;

  AppState({
    this.currentUser
  });

  // void initialState() {
  //   this.currentUser = null;
  // }

  AppState.initialState() : currentUser = null;
}

class ViewModel {
  final FirebaseUser currentUser;
  final Function(FirebaseUser) onSetCurrentUser;

  ViewModel({
    this.currentUser,
    this.onSetCurrentUser,
  });

  factory ViewModel.create(Store<AppState> store) {
    _onSetCurrentUser(FirebaseUser user) {
      store.dispatch(ActionSetUser(user));
    }

    return ViewModel(
      currentUser: store.state.currentUser,
      onSetCurrentUser: _onSetCurrentUser,
    );
  }
}