import 'package:flutter/material.dart';
import './forum_home.dart';
import './forum_new_post.dart';

class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  Widget _currentScreen = ForumHomeScreen();

  @override
  void initState() {
    super.initState();
    _currentScreen = ForumHomeScreen(
      onNewPostTap: _handleNewPostTap,
    );
  }

  void _backToForumHome() {
    setState(() {
      _currentScreen = ForumHomeScreen(
        onNewPostTap: _handleNewPostTap,
      );
    });
  }

  void _handleNewPostTap() {
    setState(() {
      _currentScreen = ForumNewPostScreen(
        backToForumHome: _backToForumHome,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: _currentScreen,
    );
  }
}

