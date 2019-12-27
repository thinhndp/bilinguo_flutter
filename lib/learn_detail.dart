import 'package:bilinguo_flutter/models/Achievement.dart';
import 'package:bilinguo_flutter/models/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'mock-data.dart';
// import 'utils/HexColor.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LearnDetailScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> _navigatorKey;
  final ViewModel _viewModel;

  LearnDetailScreen(this._navigatorKey, this._viewModel);

  @override
  _LearnDetailScreenState createState() => _LearnDetailScreenState();
}

class _LearnDetailScreenState extends State<LearnDetailScreen> {
  var _question = null; // TODO: create class
  var _questionsAnswered = 0;
  var _questionsAnsweredCorrect = 0;
  var _questionsTotal = 5;

  // eng-vie-sentence-ordering
  List<dynamic> _wordChoices = [];
  List<int> _selectedIndexList = [];

  // Check answer
  String _answerStatus = 'unchecked'; // 'correct', 'incorrect', 'unchecked'
  var _isDone = false; // Last question => done learn
  String _correctAnswer = '';

  @override
  initState() {
    super.initState();
    
    _initQuestion();
  }

  _initQuestion() {
    print('_initQuestion');
    widget._viewModel.currentUser.getIdToken()
      .then((tokenRes) {

        print('get duoc token');
        http.post(
          'https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/setQuestionOfCurrentLearnSession',
          headers: { 'Authorization': 'Bearer ' + tokenRes.token },
        )
          .then((response) {
            print('complete');
            final learnSession = json.decode(response.body);
            print(learnSession);
            setState(() {
              _questionsAnswered = learnSession['questionsAnswered'];
              _questionsAnsweredCorrect = learnSession['questionsAnsweredCorrect'];
              _questionsTotal = learnSession['questionsTotal'];
            });
            _setQuestion(learnSession['question']);
          })
          .catchError((err) {
            print('error');
            print(err);
          });
      })
      .catchError((err) {
        print('error');
        print(err);
      });
  }

  _setQuestion(questionData) {
    print(questionData);
    setState(() {
      _question = questionData;
      _answerStatus = 'unchecked';
      _correctAnswer = '';
      _wordChoices = _question['choices'];
      _selectedIndexList = [];
    });
    
  }

  _checkAnswer() {
    var answer = '';

    if (_question['type'] == 'eng-vie-sentence-ordering') {
      final selectedWords = _selectedIndexList.map((selectedIndex) {
        return _wordChoices[selectedIndex];
      });
      answer = selectedWords.join(' ');
    } // Check type. For each type, there is a different way to set answer

    print(answer);

    widget._viewModel.currentUser.getIdToken()
      .then((tokenRes) {

        http.post(
          'https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/checkSessionQuestionAnswer',
          headers: { 'Authorization': 'Bearer ' + tokenRes.token },
          body: { 'answer': answer },
        )
          .then((response) {
            print('complete');
            final responseJSON = json.decode(response.body);
            print(responseJSON);
            setState(() {
              _isDone = responseJSON['isDone'];
            });
            if (responseJSON['isCorrect'] == true) {
              setState(() {
                _answerStatus = 'correct';
              });
            } else if (responseJSON['isCorrect'] == false) {
              setState(() {
                _answerStatus = 'incorrect';
                _correctAnswer = responseJSON['correctAnswer'];
              });
            } else {
              print('co gi do khong on');
            }
          })
          .catchError((err) {
            print('error');
            print(err);
          });
      })
      .catchError((err) {
        print('error');
        print(err);
      });
  }

  Widget _renderSelectingWordPiece(int wordChoiceIndex) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 2),
            left: BorderSide(color: Colors.grey, width: 2),
            right: BorderSide(color: Colors.grey, width: 2),
            bottom: BorderSide(color: Colors.grey, width: 4),
          ),
          // borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        child: Text(_wordChoices[wordChoiceIndex], style: TextStyle(color: Colors.black87)),
      ),
      onTap: () {
        final newList = _selectedIndexList;
        newList.remove(wordChoiceIndex);
        setState(() {
          _selectedIndexList = newList;
        });
      },
    );
  }

  List<Widget> _renderSelectingWordPieces() {
    List<Widget> widgetList = new List<Widget>();

    for (var i = 0; i < _selectedIndexList.length; i++) {
      widgetList.add(_renderSelectingWordPiece(_selectedIndexList[i]));
    }

    return widgetList;
  }

  Widget _renderChoiceWordPiece(String word, int index) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: _selectedIndexList.contains(index) ? Colors.grey : Colors.transparent,
          border: Border(
            top: BorderSide(color: Colors.grey, width: 2),
            left: BorderSide(color: Colors.grey, width: 2),
            right: BorderSide(color: Colors.grey, width: 2),
            bottom: BorderSide(color: Colors.grey, width: 4),
          ),
          // borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        child: Text(
          word,
          style: TextStyle(color: _selectedIndexList.contains(index) ? Colors.grey : Colors.black87)
        ),
      ),
      onTap: () {
        if (!_selectedIndexList.contains(index)) {
          final newList = _selectedIndexList;
          newList.add(index);
          setState(() {
            _selectedIndexList = newList;
          });
        }
      },
    );
  }

  List<Widget> _renderChoiceWordPieces() {
    // return _wordChoices.map<Widget>((wordChoice) {
    //   return _renderChoiceWordPiece(wordChoice);
    // }).toList();

    List<Widget> widgetList = new List<Widget>();

    for (var i = 0; i < _wordChoices.length; i++) {
      widgetList.add(_renderChoiceWordPiece(_wordChoices[i], i));
    }

    return widgetList;
  }

  Widget _renderCheckButton() {
    if (_answerStatus == 'unchecked') {
      return RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)
        ),
        elevation: 4,
        padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
        onPressed: () {
          _checkAnswer();
        },
        color: Colors.green,
        textColor: Colors.white,
        child: Text(
            'KIỂM TRA',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)
        ),
      );
    }
    if (_answerStatus == 'correct') {
      return RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)
        ),
        elevation: 4,
        padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
        onPressed: () {
          if (_isDone == false) {
            // Start next question
            _initQuestion();
          } else if (_isDone == true) {
            // End exercise
            _showSummary();
            // widget._navigatorKey.currentState.pushNamed('/home');
          }
        },
        color: Colors.green[400],
        textColor: Colors.white,
        child: Text(
            _isDone == false ? 'TIẾP TỤC' : 'KẾT THÚC',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)
        ),
      );
    }
    if (_answerStatus == 'incorrect') {
      return RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)
        ),
        elevation: 4,
        padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
        onPressed: () {
          if (_isDone == false) {
            // Start next question
            _initQuestion();
          } else if (_isDone == true) {
            // End exercise
            _showSummary();
            // widget._navigatorKey.currentState.pushNamed('/home');
          }
        },
        color: Colors.red,
        textColor: Colors.white,
        child: Text(
            _isDone == false ? 'TIẾP TỤC' : 'KẾT THÚC',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)
        ),
      );
    }

    return null;
  }

  void _showSummary() {
    widget._viewModel.currentUser.getIdToken()
      .then((tokenRes) {

        http.get(
          'https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/getCurrentLearnSession',
          headers: { 'Authorization': 'Bearer ' + tokenRes.token },
        )
          .then((response) {
            print('complete');
            final responseJSON = json.decode(response.body);
            print(responseJSON);
            _showSummaryDialog(responseJSON['questionsAnsweredCorrect'], responseJSON['questionsTotal']);
          })
          .catchError((err) {
            print('error');
            print(err);
          });
      })
      .catchError((err) {
        print('error');
        print(err);
      });
  }

  void _showSummaryDialog(int questionsCorrect, int questionsTotal) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Summary"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Total Questions: ' + questionsTotal.toString()),
              Text('Correct Answers: ' + questionsCorrect.toString()),
            ],
          ),
          // content: Text('Total Questions: ' + questionsTotal.toString()),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text('Back to Home'),
              onPressed: () {
                // Navigator.of(context).pop();
                widget._navigatorKey.currentState.pushNamed('/home');
              },
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bilinguo',
      theme: ThemeData(
        fontFamily: 'Varela',
      ),
      home: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LinearPercentIndicator(
                  lineHeight: 18.0,
                  percent: _questionsAnswered / _questionsTotal,
                  backgroundColor: Colors.grey[350],
                  progressColor: Colors.orange[400],
                ),
                SizedBox(height: 15,),
                Text('Chọn câu đúng', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24),),
                SizedBox(height: 15,),
                Text(_question != null ? _question['questionStr'] : 'Câu hỏi', style: TextStyle(color: Colors.black87, fontSize: 20)),
                SizedBox(height: 75,),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 2, color: Colors.grey[400]))
                  ),
                  child: Wrap(
                    children: _renderSelectingWordPieces(),
                  )
                ),
                SizedBox(height: 50,),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: _renderChoiceWordPieces(),
                  ),
                ),
                SizedBox(height: 75,),
                Container(
                  padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                  width: double.infinity,
                  child: _renderCheckButton(),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.green[200],
                    child: Text(
                      _correctAnswer != '' ? 'Đáp án đúng: ' + _correctAnswer : '',
                      style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.bold),
                    )
                  )
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}