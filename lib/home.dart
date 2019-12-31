import 'package:bilinguo_flutter/profile.dart';
import 'package:bilinguo_flutter/models/AppState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'placeholder_widget.dart';

import 'achievement.dart';
import 'learn.dart';
import 'shop.dart';
import 'forum.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> _navigatorKey;
  final ViewModel _viewModel;

  HomeScreen(this._navigatorKey, this._viewModel);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  int _currentIndex = 0;
  final List<Widget> _children = [
    // LearnScreen(widget._navigatorKey),
    // AchievementScreen(),
    // ForumScreen(),
    // ShopScreen(),
    // PlaceholderWidget(Colors.deepOrange),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override void initState() {
    super.initState();

    // Temp. TODO: Fix
    _children.add(LearnScreen(widget._navigatorKey));
    _children.add(AchievementScreen());
    _children.add(ForumScreen());
    _children.add(ShopScreen());
    _children.add(ProfileScreen());

    // _auth.currentUser()
    //   .then((currentUser) {
    //     widget._viewModel.onSetCurrentUser(currentUser);
    //     currentUser.getIdToken().then((onValue) {
    //       print(onValue.token);
    //     });
    //   })
    //   .catchError((err) {
    //     print(err);
    //   });
  }

  @override
  Widget build(BuildContext context) {
    widget._navigatorKey;
    // TODO: implement build
    return MaterialApp(
      title: 'Bilinguo',
      theme: ThemeData(
//        primaryColor: Colors.white,
        fontFamily: 'Quicksand',
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
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
            selectedLabelStyle: TextStyle( fontWeight: FontWeight.w500 ),
            unselectedLabelStyle: TextStyle( fontWeight: FontWeight.w500 ),
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