import 'dart:convert';

import 'package:bilinguo_flutter/learn_detail.dart';
import 'package:bilinguo_flutter/models/AppState.dart';
import 'package:bilinguo_flutter/models/User.dart';
import 'package:bilinguo_flutter/redux/reducers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'signIn.dart';

void main() {
  final Store<AppState> store = Store<AppState>(
    appStateReducer,
    initialState: AppState.initialState(),
  );

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  runApp(
    StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Deus Vult',
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (context) => StoreConnector(
            converter: (Store<AppState> store) => ViewModel.create(store),
            builder: (context, ViewModel viewModel) => WelcomeScreen(viewModel),
          ),
          '/home': (context) => StoreConnector(
            converter: (Store<AppState> store) => ViewModel.create(store),
            builder: (context, ViewModel viewModel) => HomeScreen(navigatorKey, viewModel),
          ),
          '/sign-in': (context) => SignInScreen(navigatorKey),
          // '/learn-detail': (context) => LearnDetailScreen(),
          '/learn-detail': (context) => StoreConnector(
            converter: (Store<AppState> store) => ViewModel.create(store),
            builder: (context, ViewModel viewModel) => LearnDetailScreen(navigatorKey, viewModel),
          )
        },
      )
    )
  );

  // runApp(MaterialApp(
  //   title: 'Deus Vult',
  //   initialRoute: '/',
  //   routes: {
  //     '/': (context) => WelcomeScreen(),
  //     '/home': (context) => HomeScreen(),
  //     '/sign-in': (context) => SignInScreen(),
  //   },
  // ));
}

class WelcomeScreen extends StatefulWidget {
  final ViewModel _viewModel;

  WelcomeScreen(this._viewModel);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  initState() {
    super.initState();

    _auth.currentUser()
      .then((currentUser) {
        // widget._viewModel.onSetCurrentUser(currentUser);
        currentUser.getIdToken().then((onValue) {
          print(onValue.token);

          http.get(
            'https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/getUserByToken',
            headers: { 'Authorization': 'Bearer ' + onValue.token },
          )
            .then((response) {
              print('complete');
              final responseJSON = json.decode(response.body);
              print(responseJSON);
              User currentUser = new User(
                token: onValue.token,
                uid: responseJSON['uid'],
                email: responseJSON['email'],
                displayName: responseJSON['displayName'],
                profilePicture: responseJSON['profilePicture'],
                fortune: responseJSON['fortune'],
                inventory: responseJSON['inventory'],
              );
              print('day ne');
              print(currentUser);
              widget._viewModel.onSetCurrentUser(currentUser);
              print(widget._viewModel.currentUser);
            })
            .catchError((onError) {
              print(onError);
            });
        });
      })
      .catchError((err) {
        print(err);
      });

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white,
    ));
    return MaterialApp(
      title: 'Bilinguo',
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'Varela',
      ),
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.blue[200], Colors.blue[300], Colors.blue[400], Colors.blue[600]],
                    stops: [0.2, 0.5, 0.7, 1],
                    center: Alignment(0, -0.3)
                  )
                ),
              ),
              Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              'https://www.freeiconspng.com/uploads/angry-birds-transparent-background-22.png',
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                              'BILINGUO',
                              style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget._viewModel.currentUser == null ?
                              'Bạn cần đăng nhập để tiếp tục'
                              :
                              'Chào mừng bạn đã quay trở lại, ' + widget._viewModel.currentUser.displayName + '!',
                            style: TextStyle(fontSize: 20.0, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget._viewModel.currentUser == null ?
                  SizedBox(width: 0, height: 0,)
                  :
                  Container (
                    padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                    width: double.infinity,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)
                      ),
                      elevation: 4,
                      padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      color: Colors.lightGreen,
                      textColor: Colors.white,
                      child: Text(
                          'Bắt đầu'.toUpperCase(),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container (
                    padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                    width: double.infinity,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)
                      ),
                      elevation: 4,
                      padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                      onPressed: () {
                        if (widget._viewModel.currentUser == null) {
                          Navigator.pushNamed(context, '/sign-in');
                        } else {
                          _auth.signOut();
                          widget._viewModel.onSetCurrentUser(null);
                        }
                      },
                      color: Colors.white,
                      textColor: Colors.lightGreen,
                      child: Text(
                          widget._viewModel.currentUser == null ? 'Đăng nhập'.toUpperCase() : 'Đăng xuất'.toUpperCase(),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                ],
              )
            ],
          )
          
        )
      ),
    );
  }
}