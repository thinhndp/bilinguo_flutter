import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';

void main() {
  runApp(MaterialApp(
    title: 'Deus Vult',
    initialRoute: '/',
    routes: {
      '/': (context) => WelcomeScreen(),
      '/home': (context) => HomeScreen(),
    },
  ));
}

class WelcomeScreen extends StatelessWidget {
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
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          'assets/wassupmahcommies.png',
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                          'We will take Jerusalem',
                          style: TextStyle(fontSize: 20.0, color: Colors.black38),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Deus Vult',
                        style: TextStyle(fontSize: 20.0, color: Colors.black38),
                      ),
                    ],
                  ),
                ),
              ),
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
                    Navigator.pushNamed(context, '/learn');
                  },
                  color: Colors.white,
                  textColor: Colors.lightGreen,
                  child: Text(
                      'Đăng kí tài khoản'.toUpperCase(),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          )
        )
      ),
    );
  }
}


