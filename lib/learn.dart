import 'package:flutter/material.dart';
import 'mock-data.dart';
import 'utils/HexColor.dart';

class LearnScreen extends StatelessWidget {

  renderCourseGroup(courseGroup) {
    return Column(
      children: courseGroup.rows.map<Widget>((row) => (
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map<Widget>((course) => (
            Container(
              margin: EdgeInsets.fromLTRB(15, 25, 15, 0),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        color: HexColor(course.backgroundColor),
                        child: Image.asset(
                          'assets/' + course.unlockedIconUrl,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                  ),
                  SizedBox(height: 10),
                  Text(
                    course.name,
                    style: TextStyle(
                      fontFamily: 'Varela',
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
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