import 'package:bilinguo_flutter/models/Achievement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'mock-data.dart';
// import 'utils/HexColor.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';

class AchievementScreen extends StatefulWidget {
  @override
  _AchievementScreenState createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  _renderHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: new BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(
          color: Colors.black12,
          blurRadius: 2.0,
        ),],
        border: Border(bottom: BorderSide(color: Colors.grey[300], width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
              'assets/flags/flag-american.png',
              height: 30
          ),
          Row(
            children: <Widget>[
              Image.asset('assets/icons/crown.png', width: 35),
              SizedBox(width: 0,),
              Text(
                '8',
                style: TextStyle(
                    fontFamily: 'Varela',
                    fontWeight: FontWeight.bold,
                    color: Color(0xffffc800),
                    fontSize: 16
                ),),
            ],
          ),
          Row(
            children: <Widget>[
              Image.asset('assets/icons/streak.png', width: 30),
              SizedBox(width: 0,),
              Text(
                '1',
                style: TextStyle(
                    fontFamily: 'Varela',
                    fontWeight: FontWeight.bold,
                    color: Color(0xffff9600),
                    fontSize: 16
                ),),
            ],
          ),
          Row(
            children: <Widget>[
              Image.asset('assets/icons/lingot.png', width: 30),
              SizedBox(width: 0,),
              Text(
                '66',
                style: TextStyle(
                    fontFamily: 'Varela',
                    fontWeight: FontWeight.bold,
                    color: Color(0xffff4b4b),
                    fontSize: 16
                ),),
            ],
          ),
        ],
      ),
    );
  }

  _buildUserInfo() {
    return Container(
      margin: EdgeInsets.all(10.0),
      // decoration: BoxDecoration(color: Colors.black87),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 30, 10),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.asset('assets/anonymous-avatar.jpg', height: 80,),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 1.8),
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: Icon(Icons.edit, size: 16, color: Colors.grey,),
                  ),
                )
              ],
            )
          ),
          Expanded(
            child: Container(
              child: Text(
                  'Minh Ho (chiminhho1998)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
            )
          ),
        ],
      )
    );
  }

  _renderAllAchievements() {
    return mockAchievements.map<Widget>((achievement) {
      // return ListTile(
      //   leading: SvgPicture.network(achievement.imgURL),
      //   title: Text(achievement.title),
      //   subtitle: Text(achievement.description),
      // );

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SvgPicture.network(achievement.imgURL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(achievement.title),
                Text(achievement.description)
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  _buildAchievementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Thành tích', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        Expanded(
          child: ListView(
            children: _renderAllAchievements()
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _renderHeader(),
          _buildUserInfo(),
          Expanded(child: _buildAchievementSection(),)
          // _buildAchievementSection(),
        ],
      )
    );
  }
}