import 'package:bilinguo_flutter/common_widgets/my_button.dart';
import 'package:bilinguo_flutter/models/Achievement.dart';
import 'package:bilinguo_flutter/models/AppState.dart';
import 'package:bilinguo_flutter/utils/Helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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
  bool _isLoadingContent = false;
  bool _isLoadingCheckButton = false;
  var _question; // TODO: create class
  var _questionsAnswered = 0;
  // var _questionsAnsweredCorrect = 0;
  var _questionsTotal = 5;
  DateTime _testDateTime = new DateTime(2019, 9, 22);

  // vie-eng-vocab-picking
  List<dynamic> _vocabChoices = [];
  int _selectedVocabIndex = -1;

  // eng-vie-sentence-picking
  List<dynamic> _sentenceChoices = [];
  int _selectedSentenceIndex = -1;

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

    setState(() {
      _isLoadingContent = true;
    });

    http.post(
      'https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/setQuestionOfCurrentLearnSession',
      headers: { 'Authorization': 'Bearer ' + widget._viewModel.currentUser.token },
    )
      .then((response) {
        print('complete');
        final learnSession = json.decode(response.body);
        print(learnSession);
        setState(() {
          _answerStatus = 'unchecked';
          _correctAnswer = '';
          _questionsAnswered = learnSession['questionsAnswered'];
          _questionsTotal = learnSession['questionsTotal'];
        });
        _setQuestion(learnSession['question']);

        setState(() {
          _isLoadingContent = false;
        });
      })
      .catchError((err) {
        print('error');
        print(err);
        
        setState(() {
          _isLoadingContent = false;
        });
      });
  }

  _setQuestion(questionData) {
    print(questionData);

    setState(() {
      _question = questionData;
    });

    if (questionData['type'] == 'vie-eng-vocab-picking') {
      setState(() {
        _vocabChoices = questionData['choices'];
        _selectedVocabIndex = -1;
      });
    }

    if (questionData['type'] == 'eng-vie-sentence-picking') {
      setState(() {
        _sentenceChoices = questionData['choices'];
        _selectedSentenceIndex = -1;
      });
    }

    if (questionData['type'] == 'eng-vie-sentence-ordering') {
      setState(() {
        _wordChoices = questionData['choices'];
        _selectedIndexList = [];
      });
    }
    
  }

  _checkAnswer() {
    var answer = '';

    if (_question['type'] == 'vie-eng-vocab-picking') {
      answer = _vocabChoices[_selectedVocabIndex]['text'];
    }

    if (_question['type'] == 'eng-vie-sentence-picking') {
      answer = _sentenceChoices[_selectedSentenceIndex].toString();
    }

    if (_question['type'] == 'eng-vie-sentence-ordering') {
      final selectedWords = _selectedIndexList.map((selectedIndex) {
        return _wordChoices[selectedIndex];
      });
      answer = selectedWords.join(' ');
    } // Check type. For each type, there is a different way to set answer

    print(answer);

    setState(() {
      _isLoadingCheckButton = true;
    });

    http.post(
      'https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/checkSessionQuestionAnswer',
      headers: { 'Authorization': 'Bearer ' + widget._viewModel.currentUser.token },
      body: { 'answer': answer },
    )
      .then((response) {
        print('complete');
        final responseJSON = json.decode(response.body);
        print(responseJSON);
        setState(() {
          _isDone = responseJSON['isDone'];
          // _isDone = true;
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

        setState(() {
          _isLoadingCheckButton = false;
        });
      })
      .catchError((err) {
        print('error');
        print(err);

        setState(() {
          _isLoadingCheckButton = false;
        });
      });
  }

  void _showSummary() {
    setState(() {
      _isLoadingCheckButton = true;
    });

    http.get(
      'https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/getCurrentLearnSession',
      headers: { 'Authorization': 'Bearer ' + widget._viewModel.currentUser.token },
    )
      .then((response) {
        print('complete');
        final responseJSON = json.decode(response.body);
        print(responseJSON);
        _showSummaryDialog(
          responseJSON['questionsAnsweredCorrect'],
          responseJSON['questionsTotal'],
          DateTime.parse(responseJSON['startAt'])
        );

        setState(() {
          _isLoadingCheckButton = false;
        });
      })
      .catchError((err) {
        print('error');
        print(err);
        
        setState(() {
          _isLoadingCheckButton = false;
        });
      });
  }

  void _showSummaryDialog(int questionsCorrect, int questionsTotal, DateTime startAt) {
    double accuracy = questionsTotal != 0 ? questionsCorrect / questionsTotal : 0;
    DateTime now = new DateTime.now();
    Duration completionTime = now.difference(startAt);

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
              Center(
                child: Column(
                  children: <Widget>[
                    CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 15.0,
                      percent: accuracy,
                      center: Text(
                        '${accuracy * 100}%',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.green[600],
                        ),
                      ),
                      progressColor: Colors.green[400],
                      animation: true,
                    ),
                    Text(
                      'Excellent',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.green[600],
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Divider(
                color: Colors.grey[600],
                height: 2.0,
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Correct Answers:', style: TextStyle(color: Colors.black87),),
                  Text(
                    questionsCorrect.toString() + '/' + questionsTotal.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Completion Time:', style: TextStyle(color: Colors.black87),),
                  Text(
                    Helper.printDuration(completionTime),
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            // buttons at the bottom of the dialog
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

  Widget _buildHeader() {
    String getQuestionHeader() {
      if (_question == null) {
        return '';
      }

      if (_question['type'] == 'vie-eng-vocab-picking') {
        return 'Chọn từ đúng';
      }
      
      if (_question['type'] == 'eng-vie-sentence-picking') {
        return 'Chọn câu đúng';
      }
      
      if (_question['type'] == 'eng-vie-sentence-ordering') {
        return 'Sắp xếp lại câu';
      }

      return '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LinearPercentIndicator(
          lineHeight: 18.0,
          percent: _questionsAnswered / _questionsTotal,
          backgroundColor: Colors.grey[350],
          progressColor: Colors.blue[300],
          animation: true,
          animateFromLastPercent: true,
          animationDuration: 200,
        ),
        SizedBox(height: 15,),
        Text(getQuestionHeader(), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24),),
        SizedBox(height: 15,),
        Text(_question != null ? _question['questionStr'] : '', style: TextStyle(color: Colors.black87, fontSize: 20)),
      ],
    );
  }

  // vie-eng-vocab-picking
  List<Widget> _renderVocabChoices() {
    List<Widget> widgetList = [];

    for (var i = 0; i < _vocabChoices.length; i++) {
      final isSelected = (i == _selectedVocabIndex);

      final illustration = _vocabChoices[i]['illustration'];
      final text = _vocabChoices[i]['text'];

      widgetList.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedVocabIndex = i;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: 140,
            width: 120,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.lightBlue[100] : Colors.white,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey[400], width: 2
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: isSelected ? Colors.blue : Colors.grey[400],
                  offset: Offset(0, 2),
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Image.asset(
                    'assets/exercise-images/' + illustration,
                    width: 75,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(text),
                )
              ],
            ),
          ),
        )
      );
    }

    return widgetList;
  }

  // eng-vie-sentence-picking
  List<Widget> _renderSentenceChoices() {
    List<Widget> widgetList = [];

    for (var i = 0; i < _sentenceChoices.length; i++) {
      final isSelected = (i == _selectedSentenceIndex);

      widgetList.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedSentenceIndex = i;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: double.infinity,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.lightBlue[100] : Colors.white,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey[400], width: 2
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: isSelected ? Colors.blue : Colors.grey[400],
                  offset: Offset(0, 2),
                )
              ]
            ),
            child: Center(
              child: Text(
                Helper.capitalizeString(_sentenceChoices[i].toString()),
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey[800],
                  fontSize: 16,
                ),
              )
            ),
          ),
        )
      );
    }

    return widgetList;
  }
  
  // eng-vie-sentence-ordering
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

  Widget _buildContent() {
    if (_question['type'] == 'vie-eng-vocab-picking') {
      return Center(
        child: Wrap(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          alignment: WrapAlignment.center,
          children: _renderVocabChoices(),
        )
      );
    }

    if (_question['type'] == 'eng-vie-sentence-picking') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _renderSentenceChoices(),
      );
    }

    if (_question['type'] == 'eng-vie-sentence-ordering') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
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
          SizedBox(height: 25,),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: _renderChoiceWordPieces(),
            ),
          ),
        ],
      );
    }

    return SizedBox(width: 0, height: 0,);
  }

  Color _getCheckSectionColor() {
    if (_answerStatus == 'correct') {
      return Colors.green[200];
    }

    if (_answerStatus == 'incorrect') {
      return Colors.red[200];
    }

    return Colors.transparent;
  }

  Widget _renderCheckBtn() {
    if (_answerStatus == 'correct') {
      return MyButton(
        btnColor: Colors.green[500],
        textColor: Colors.white,
        isLoading: _isLoadingCheckButton == true || _isLoadingContent == true,
        onBtnPressed: () {
          if (_isDone == false) {
            // Start next question
            _initQuestion();
          } else if (_isDone == true) {
            // End exercise
            _showSummary();
          }
        },
        child: Text(
          _isDone == false ? 'TIẾP TỤC' : 'KẾT THÚC',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)
        )
      );
    }
    if (_answerStatus == 'incorrect') {
      return MyButton(
        btnColor: Colors.red,
        textColor: Colors.white,
        isLoading: _isLoadingCheckButton == true || _isLoadingContent == true,
        onBtnPressed: () {
          if (_isDone == false) {
            // Start next question
            _initQuestion();
          } else if (_isDone == true) {
            // End exercise
            _showSummary();
          }
        },
        child: Text(
          _isDone == false ? 'TIẾP TỤC' : 'KẾT THÚC',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)
        )
      );
    }

    return MyButton(
      btnColor: Colors.green[400],
      textColor: Colors.white,
      isLoading: _isLoadingCheckButton == true || _isLoadingContent == true,
      onBtnPressed: () {
        _checkAnswer();
      },
      child: Text(
        'KIỂM TRA',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)
      )
    );
  }

  Widget _renderAnswerStatusText() {
    if (_answerStatus == 'correct') {
      return Text(
        'Chính xác',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green[600],
          fontSize: 24,
        )
      );
    }

    if (_answerStatus == 'incorrect') {
      return Text(
        'Sai rồi',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red[700],
          fontSize: 24,
        )
      );
    }

    return Text('');
  }

  Widget _buildCheckSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 10, right: 10),
            color: _getCheckSectionColor(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 16,),
                Container(
                  // padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                  width: double.infinity,
                  child: _renderCheckBtn(),
                ),
                SizedBox(height: 16,),
                _renderAnswerStatusText(),
                SizedBox(height: 10,),
                Text(
                  _correctAnswer != '' ? 'Đáp án đúng: ' + _correctAnswer : '',
                  style: TextStyle(color: Colors.red[600], fontWeight: FontWeight.bold),
                )
              ],
            )
          )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bilinguo Exercise',
      theme: ThemeData(
        fontFamily: 'Varela',
      ),
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: _buildHeader(),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: _isLoadingContent == false ?
                    Center(
                      child: _buildContent()
                    )
                    :
                    Center(
                      child: CircularProgressIndicator()
                    ),
                ),
              ),
              Expanded(
                flex: 2,
                child: _buildCheckSection(),
              ),
            ],
          ),
        )
      )
    );
  }
}