import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'learn.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    LearnScreen(),
    PlaceholderWidget(Colors.green),
    PlaceholderWidget(Colors.blue),
    PlaceholderWidget(Colors.yellow),
    PlaceholderWidget(Colors.deepOrange),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
                title: Text('Bài tập'),
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