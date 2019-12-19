import 'package:bilinguo_flutter/models/Achievement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'mock-data.dart';
// import 'utils/HexColor.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AchievementScreen extends StatefulWidget {
  @override
  _AchievementScreenState createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  bool _isDisplayAchievementDetail = false;

  _renderHeader() {
    return Container(
      height: 57,
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

  _buildAchievementSectionTitle() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      padding: EdgeInsets.only(bottom: 10.0),
      // decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[350], width: 2))),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: Text('Thành tích', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          InkWell(
            child: Text(_isDisplayAchievementDetail ? 'Ẩn' : 'Xem', style: TextStyle(color: Colors.blue),),
            onTap: () => _toggleAchievementDisplay(),
          )
        ],
      )
    );
  }

  // TODO: Make this into a Widget
  _renderStar(bool isGolden) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: isGolden ? 0.0 : 0.4,
          child: SvgPicture.network('http://d35aaqx5ub95lt.cloudfront.net/images/achievements/star_black.svg', width: 18, height: 18),
        ),
        Opacity(
          opacity: isGolden ? 1.0 : 0.0,
          child: SvgPicture.network('http://d35aaqx5ub95lt.cloudfront.net/images/achievements/star.svg', width: 18, height: 18),
        ),
      ],
    );
  }

  // TODO: Make this into a Widget
  _renderAchievementPicture(Achievement achievement) {
    return Stack(
      children: <Widget>[
        SvgPicture.network(achievement.imgURL, width: 80.0,),
        Positioned(
          left: 5,
          right: 5,
          bottom: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _renderStar(achievement.level >= 1),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: _renderStar(achievement.level >= 2)
              ),
              _renderStar(achievement.level >= 3),
            ]
          ),
        ),
      ],
    );
  }

  _renderDetailAllAchievements() {
    return mockAchievements.map<Widget>((achievement) {
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        padding: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[350], width: 2))),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: _renderAchievementPicture(achievement),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      achievement.title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(
                      achievement.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[800])
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        LinearPercentIndicator(
                          width: 200.0,
                          lineHeight: 14.0,
                          percent: achievement.currentProgress / achievement.totalProgress,
                          backgroundColor: Colors.grey[350],
                          progressColor: Colors.orange[400],
                        ),
                        Text(
                          achievement.currentProgress.toString()+'/'+achievement.totalProgress.toString(),
                          style: TextStyle(color: Colors.grey[700])
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
      );
    }).toList();
  }

  _toggleAchievementDisplay() {
    setState(() {
      _isDisplayAchievementDetail = !_isDisplayAchievementDetail;
    });
  }

  _buildDetailAchievementSection() {
    return ListView(
      children: _renderDetailAllAchievements()
    );
  }

  _renderNonDetailAllAchievements() {
    return mockAchievements.map<Widget>((achievement) {
      return Container(
        padding: EdgeInsets.all(5.0),
        child: _renderAchievementPicture(achievement)
      );
    }).toList();
  }

  _buildNonDetailAchievementSection() {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: Wrap(
        direction: Axis.horizontal,
        children: _renderNonDetailAllAchievements(),
      )
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
          _buildAchievementSectionTitle(),
          Expanded(child:
            _isDisplayAchievementDetail ? _buildDetailAchievementSection() : _buildNonDetailAchievementSection()
          )
          // _buildAchievementSection(),
        ],
      )
    );
  }
}