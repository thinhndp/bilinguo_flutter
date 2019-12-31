import 'package:bilinguo_flutter/models/AppState.dart';
import 'package:bilinguo_flutter/models/Course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'mock-data.dart';
import 'utils/HexColor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http; 

class LearnScreen extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey;

  LearnScreen(this._navigatorKey);

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

  renderCourseImage(BuildContext context, Course course) {
    return StoreConnector(
      converter: (Store<AppState> store) => ViewModel.create(store),
      builder: (context, ViewModel viewModel) => GestureDetector(
        child: Container(
          color: HexColor(course.backgroundColor),
          child: Image.asset(
            'assets/' + course.unlockedIconUrl,
            width: 70,
            fit: BoxFit.cover,
          ),
        ),
        onTap: () async {
          // viewModel.currentUser
          final tokenStr = (await viewModel.currentUser.getIdToken()).token;
          print('onTap');
          http.post(
            'https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/startLearnSession',
            headers: { 'Authorization': 'Bearer ' + tokenStr },
            body: { 'courseId': course.id, 'questionsTotal': course.totalQuestions.toString() } // TODO: Bring to backend
          )
            .then((response) {
              print(response.body);
              // Navigator.pushNamed(context, '/learn-detail');
              _navigatorKey.currentState.pushNamed('/learn-detail');
            })
            .catchError((err) {
              print(err);
            });
        },
      )
    );
      // GestureDetector(
      //   child: Container(
      //     color: HexColor(course.backgroundColor),
      //     child: Image.asset(
      //       'assets/' + course.unlockedIconUrl,
      //       width: 70,
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      //   onTap: () {

      //   },
      // )
      //   :
      // Container(
      //   color: Color(0xffe5e5e5),
      //   child: Image.asset(
      //     'assets/' + course.lockedIconUrl,
      //     width: 70,
      //     fit: BoxFit.cover,
      //   ),
      // );
  }

  renderCourseGroup(BuildContext context, courseGroup) {
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
                            child: renderCourseImage(context, course),
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
                  SizedBox(height: 5),
                  Text(
                    course.name,
                    style: TextStyle(
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
          ),
          Container(
            child: Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  renderCourseGroup(context, courseGroup1),
                  renderCourseGroup(context, courseGroup2),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}