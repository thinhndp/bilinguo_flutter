import 'package:bilinguo_flutter/models/AppState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'placeholder_widget.dart';

import 'achievement.dart';
import 'learn.dart';
import 'shop.dart';

class HomeScreen extends StatefulWidget {
  final ViewModel _viewModel;

  HomeScreen(this._viewModel);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  int _currentIndex = 0;
  final List<Widget> _children = [
    LearnScreen(),
    AchievementScreen(),
    PlaceholderWidget(Colors.green),
    ShopScreen(),
    PlaceholderWidget(Colors.deepOrange),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // @override void initState() {
  //   super.initState();

  //   // _auth.currentUser()
  //   //   .then((currentUser) {
  //   //     widget._viewModel.onSetCurrentUser(currentUser);
  //   //     currentUser.getIdToken().then((onValue) {
  //   //       print(onValue.token);
  //   //     });
  //   //   })
  //   //   .catchError((err) {
  //   //     print(err);
  //   //   });
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Bilinguo',
      theme: ThemeData(
//        primaryColor: Colors.white,
        fontFamily: 'Varela',
      ),
      home: Scaffold(
        body: SafeArea(
          child: _children[_currentIndex],
        ),
        bottomNavigationBar: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                activeIcon: Image.asset('assets/icons/learn.png', height: 30),
                icon: Image.asset('assets/icons/learn_inactive.png', height: 30),
                title: Text('Bài học'),
              ),
              BottomNavigationBarItem(
                activeIcon: Image.asset('assets/icons/achievements.png', height: 30),
                icon: Image.asset('assets/icons/achievements_inactive.png', height: 30),
                title: Text('Thành tích'),
              ),
              BottomNavigationBarItem(
                activeIcon: Image.asset('assets/icons/discuss.png', height: 30),
                icon: Image.asset('assets/icons/discuss_inactive.png', height: 30),
                title: Text('Thảo luận'),
              ),
              BottomNavigationBarItem(
                activeIcon: Image.asset('assets/icons/shop.png', height: 30),
                icon: Image.asset('assets/icons/shop_inactive.png', height: 30),
                title: Text('Cửa hàng'),
              ),
              BottomNavigationBarItem(
                activeIcon: Image.asset('assets/icons/profile.png', height: 30),
                icon: Image.asset('assets/icons/profile_inactive.png', height: 30),
                title: Text('Hồ sơ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}