import 'dart:convert';

import 'package:bilinguo_flutter/models/AppState.dart';
import 'package:bilinguo_flutter/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var _email = '';
  var _password = '';

  var errMessage = '';

  // TextEditingController _emailController = new TextEditingController();
  // TextEditingController _passwordController = new TextEditingController();

  Future _handleSignIn(ViewModel viewModel) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        print('handle' + _email);
        final FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: _email, password: _password)).user;
        user.getIdToken()
          .then((onValue) {
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
                viewModel.onSetCurrentUser(currentUser);
              });
          })
          .catchError((onError) {
            print(onError);
          });
        // viewModel.onSetCurrentUser(user);
        print((await user.getIdToken()).token);
        print('Sign in successfully.');
      } on PlatformException catch (err) {
        print(err);
        // switch (err.code) {
        //   case 'ERROR_WRONG_PASSWORD':
        //     setState(() {
        //       errMessage = 'The password is invalid. Please try again.';
        //     });
        // }
        
        // TODO: Use switch case for better error message
        setState(() {
          errMessage = err.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      converter: (Store<AppState> store) => ViewModel.create(store),
      builder: (context, ViewModel viewModel) => MaterialApp(
        title: 'Bilinguo',
        theme: ThemeData(
          fontFamily: 'Varela',
        ),
        home: Scaffold(
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      decoration: new InputDecoration(
                          hintText: 'Email',
                          icon: new Icon(
                            Icons.mail,
                            color: Colors.grey,
                          )),
                      validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
                      onSaved: (value) => _email = value.trim(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      obscureText: true,
                      autofocus: false,
                      decoration: new InputDecoration(
                          hintText: 'Password',
                          icon: new Icon(
                            Icons.lock,
                            color: Colors.grey,
                          )),
                      validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                      onSaved: (value) => _password = value.trim(),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(errMessage, style: TextStyle(color: Colors.red),),
                  SizedBox(height: 10,),
                  Container (
                    padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                    width: double.infinity,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)
                      ),
                      elevation: 4,
                      padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                      onPressed: () async {
                        await _handleSignIn(viewModel);
                      },
                      color: Colors.white,
                      textColor: Colors.lightGreen,
                      child: Text(
                          'Đăng nhập'.toUpperCase(),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );

    // // TODO: implement build
    // return MaterialApp(
    //   title: 'Bilinguo',
    //   theme: ThemeData(
    //     fontFamily: 'Varela',
    //   ),
    //   home: Scaffold(
    //     body: SafeArea(
    //       child: Form(
    //         key: _formKey,
    //         child: Column(
    //           children: <Widget>[
    //             Padding(
    //               padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
    //               child: new TextFormField(
    //                 maxLines: 1,
    //                 keyboardType: TextInputType.emailAddress,
    //                 autofocus: false,
    //                 decoration: new InputDecoration(
    //                     hintText: 'Email',
    //                     icon: new Icon(
    //                       Icons.mail,
    //                       color: Colors.grey,
    //                     )),
    //                 validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
    //                 onSaved: (value) => _email = value.trim(),
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
    //               child: new TextFormField(
    //                 maxLines: 1,
    //                 obscureText: true,
    //                 autofocus: false,
    //                 decoration: new InputDecoration(
    //                     hintText: 'Password',
    //                     icon: new Icon(
    //                       Icons.lock,
    //                       color: Colors.grey,
    //                     )),
    //                 validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
    //                 onSaved: (value) => _password = value.trim(),
    //               ),
    //             ),
    //             SizedBox(height: 10,),
    //             Text(errMessage, style: TextStyle(color: Colors.red),),
    //             SizedBox(height: 10,),
    //             Container (
    //               padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
    //               width: double.infinity,
    //               child: RaisedButton(
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(16.0)
    //                 ),
    //                 elevation: 4,
    //                 padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
    //                 onPressed: () async {
    //                   await _handleSignIn();
    //                 },
    //                 color: Colors.white,
    //                 textColor: Colors.lightGreen,
    //                 child: Text(
    //                     'Đăng nhập'.toUpperCase(),
    //                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)
    //                 ),
    //               ),
    //             ),
    //           ],
    //         )
    //       ),
    //     ),
    //   ),
    // );
  }
}