import 'package:flutter/material.dart';
import 'mock-data.dart';
import 'utils/HexColor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LearnScreen extends StatelessWidget {
  renderHoneyYouShouldSeeMeInACrown(course) {
    return course.levelReached > 0 ?
      <Widget>[
        Image.asset(
          'assets/icons/crown.png',
          width: 60,
        ),
        Positioned(
          child: Text(
            course.levelReached.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Varela',
              fontSize: 12,
              color: Colors.deepOrangeAccent,
            ),),
        ),
      ]
        :
      <Widget>[
        Image.asset(
          'assets/icons/crown_locked.png',
          width: 60,
        ),
      ] ;
  }

  renderCourseImage(course) {
    return course.isUnlocked ?
      Container(
        color: HexColor(course.backgroundColor),
        child: Image.asset(
          'assets/' + course.unlockedIconUrl,
          width: 70,
          fit: BoxFit.cover,
        ),
      )
        :
      Container(
        color: Color(0xffe5e5e5),
        child: Image.asset(
          'assets/' + course.lockedIconUrl,
          width: 70,
          fit: BoxFit.cover,
        ),
      );
  }

  renderCourseGroup(courseGroup) {
    return Column(
      children: courseGroup.rows.map<Widget>((row) => (
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map<Widget>((course) => (
            Container(
              margin: EdgeInsets.fromLTRB(10, 25, 10, 0),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: 100.0,
                        lineWidth: 7.0,
                        percent: course.levelProgress,
                        startAngle: 135.0,
                        animation: true,
                        animationDuration: 800,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: renderCourseImage(course),
                        ),
                        progressColor: Colors.orangeAccent,
                        backgroundColor: Colors.black12,
                      ),
                      Positioned(
                        right: -14.0,
                        bottom: -10.0,
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: renderHoneyYouShouldSeeMeInACrown(course)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    course.name,
                    style: TextStyle(
                      fontFamily: 'Varela',
                      fontWeight: FontWeight.bold,
                      color: course.isUnlocked ? Colors.black54 : Colors.black26,
                      fontSize: 18.0,
                    ),
                  )
                ],
              )
            )
          )).toList(),
        )
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: new BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                color: Colors.grey,
                blurRadius: 2.0,
              ),]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  Icons.directions_run,
                  size: 38,
                  color: Color(0xff1cb0f6),
                ),
                Icon(
                  Icons.directions_car,
                  size: 38,
                  color: Color(0xffcf1cf6),
                ),
                Icon(
                  Icons.new_releases,
                  size: 38,
                  color: Color(0xfff6621c),
                ),
                Icon(
                  Icons.accessible_forward,
                  size: 38,
                  color: Color(0xff43f61c),
                )
              ],
            ),
          ),
          Container(
            child: Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  renderCourseGroup(courseGroup1),
                  renderCourseGroup(courseGroup2),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}