import 'dart:convert';

import 'package:bilinguo_flutter/common_widgets/my_button.dart';
import 'package:bilinguo_flutter/models/AppState.dart';
import 'package:bilinguo_flutter/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> _navigatorKey;

  SignInScreen(this._navigatorKey);

  @override
  State<StatefulWidget> createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  var _isSignUpForm = false;
  var _isLoading = false;

  var _displayName = '';
  var _email = '';
  var _password = '';
  // var _repeatPassword = '';

  var errMessage = '';

  // TextEditingController _emailController = new TextEditingController();
  // TextEditingController _passwordController = new TextEditingController();

  Future _handleSignIn(ViewModel viewModel) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
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

                widget._navigatorKey.currentState.pushNamed('/');
                
                setState(() {
                  _isLoading = false;
                });
              });
          })
          .catchError((onError) {
            print(onError);
            
            setState(() {
              _isLoading = false;
            });
          });
      } on PlatformException catch (err) {
        print(err);
        // TODO: Use switch case for better error message
        setState(() {
          errMessage = err.message;
        });
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future _handleSignUp(ViewModel viewModel) async {
    // _showSignUpSuccessDialog();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      http.post(
      'https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/signUp',
      body: { 'displayName': _displayName, 'email': _email, 'password': _password },
    )
      .then((response) {
        print('complete');
        final responseJSON = json.decode(response.body);
        print(responseJSON);
        if (responseJSON['uid'] != '' && responseJSON['uid'] != null) {
          _showSignUpSuccessDialog();
        } else {
          if (responseJSON['message']) {
            setState(() {
              errMessage = responseJSON['message'];
            });
          } else {
            setState(() {
              errMessage = 'Có gì đó sai sai';
            });
          }
        }

        setState(() {
          _isLoading = false;
        });
      })
      .catchError((err) {
        print('error');
        print(err);
        setState(() {
          errMessage = err.message;
          _isLoading = false;
        });
      });
    }
  }

  _showSignUpSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: new Text('Thành công'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.green,
              ),
              SizedBox(height: 10,),
              Text(
                'Đăng ký thành công',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          actions: <Widget>[
            // buttons at the bottom of the dialog
            new FlatButton(
              child: new Text('Đăng nhập'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isSignUpForm = false;
                  errMessage = '';
                  _displayName = '';
                  _email = '';
                  _password = '';
                });
              },
            ),
          ],
        );
      }
    );
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
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.red
                    gradient: LinearGradient(
                      // Where the linear gradient begins and ends
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      // Add one stop for each color. Stops should increase from 0 to 1
                      stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        // Colors are easy thanks to Flutter's Colors class.
                        Colors.blue[300],
                        Colors.blue[400],
                        Colors.blue[600],
                        Colors.blue[800],
                      ],
                    )
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          'https://www.stickpng.com/assets/images/584c697c6e7d5809d2fa6365.png',
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'BILINGUO',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 170,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          offset: Offset(0, 5),
                          blurRadius: 8,
                        ),
                      ]
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _isSignUpForm ?
                            TextFormField(
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              decoration: new InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                  // borderRadius: BorderRadius.all(Radius.circular(30))
                                ),
                                hintText: 'Tên hiển thị',
                                prefixIcon: new Icon(
                                  Icons.mail,
                                  color: Colors.grey,
                                )),
                              validator: (value) => value.isEmpty ? 'Tên hiển thị không được để trống' : null,
                              onSaved: (value) => _displayName = value.trim(),
                            )
                            :
                            SizedBox(width: 0, height: 0,),
                          SizedBox(height: 10,),
                          TextFormField(
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            autofocus: false,
                            decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                // borderRadius: BorderRadius.all(Radius.circular(30))
                              ),
                              hintText: 'Email',
                              prefixIcon: new Icon(
                                Icons.mail,
                                color: Colors.grey,
                              )),
                            validator: (value) => value.isEmpty ? 'Email không được để trống' : null,
                            onSaved: (value) => _email = value.trim(),
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            maxLines: 1,
                            obscureText: true,
                            autofocus: false,
                            decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                // borderRadius: BorderRadius.all(Radius.circular(30))
                              ),
                              hintText: 'Password',
                              prefixIcon: new Icon(
                                Icons.lock,
                                color: Colors.grey,
                              )),
                            validator: (value) => value.isEmpty ? 'Password không được để trống' : null,
                            onSaved: (value) => _password = value.trim(),
                          ),
                          SizedBox(height: 5,),
                          Text(errMessage, style: TextStyle(color: Colors.red),),
                          SizedBox(height: 5,),
                          MyButton(
                            btnColor: Colors.green,
                            textColor: Colors.white,
                            isLoading: _isLoading,
                            child: Text(
                              !_isSignUpForm ? 'ĐĂNG NHẬP' : 'ĐĂNG KÝ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )
                            ),
                            onBtnPressed: () async {
                              if (!_isSignUpForm) {
                                await _handleSignIn(viewModel);
                              } else {
                                await _handleSignUp(viewModel);
                              }
                            },
                          ),
                          SizedBox(height: 10,),
                          MyButton(
                            btnColor: Colors.grey[200],
                            textColor: Colors.green,
                            isLoading: _isLoading,
                            child: Text(
                              !_isSignUpForm ? 'ĐĂNG KÝ' : 'ĐĂNG NHẬP',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )
                            ),
                            onBtnPressed: () async {
                              if (!_isSignUpForm) {
                                setState(() {
                                  _isSignUpForm = true;
                                });
                              } else {
                                setState(() {
                                  _isSignUpForm = false;
                                });
                              }
                            },
                          ),
                        ],
                      )
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}