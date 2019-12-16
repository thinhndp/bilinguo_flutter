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
  final List<Widget> _children = [ LearnScreen(), PlaceholderWidget(Colors.green), PlaceholderWidget(Colors.blue), ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: _children[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              child: Icon(Icons.bubble_chart),
              height: 50,
            ),
            title: Text('Learn'),
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              child: Icon(Icons.bookmark),
              height: 50,
            ),
            title: Text('Achivements'),
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              child: Icon(Icons.person),
              height: 50,
            ),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}