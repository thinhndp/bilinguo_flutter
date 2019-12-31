import 'package:bilinguo_flutter/models/User.dart';
import 'package:bilinguo_flutter/redux/actions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';

class AppState {
  final User currentUser;

  AppState({
    this.currentUser
  });

  // void initialState() {
  //   this.currentUser = null;
  // }

  AppState.initialState() : currentUser = null;
}

class ViewModel {
  final User currentUser;
  final Function(User) onSetCurrentUser;

  ViewModel({
    this.currentUser,
    this.onSetCurrentUser,
  });

  factory ViewModel.create(Store<AppState> store) {
    _onSetCurrentUser(User user) {
      store.dispatch(ActionSetUser(user));
    }

    return ViewModel(
      currentUser: store.state.currentUser,
      onSetCurrentUser: _onSetCurrentUser,
    );
  }
}