import 'package:bilinguo_flutter/models/Achievement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'mock-data.dart';
// import 'utils/HexColor.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LearnDetailScreen extends StatefulWidget {
  @override
  _LearnDetailScreenState createState() => _LearnDetailScreenState();
}

class _LearnDetailScreenState extends State<LearnDetailScreen> {
  final List<String> _wordChoices = ['the', 'a', 'woman', 'boy', 'girl', 'a', 'witcher', 'geralt'];

  List<int> _selectedIndexList = [];

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
                  percent: 0.1,
                  backgroundColor: Colors.grey[350],
                  progressColor: Colors.orange[400],
                ),
                SizedBox(height: 15,),
                Text('Chọn câu đúng', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24),),
                SizedBox(height: 15,),
                Text('Một người phụ nữ', style: TextStyle(color: Colors.black87, fontSize: 20)),
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
                // Wrap(
                //   alignment: WrapAlignment.center,
                //   children: <Widget>[
                //     _renderWordPiece('the'),_renderWordPiece('a'),_renderWordPiece('woman'),_renderWordPiece('boy'),_renderWordPiece('girl'),_renderWordPiece('a'),_renderWordPiece('woman'),_renderWordPiece('boy'),_renderWordPiece('girl'),
                //   ],
                // ),
                SizedBox(height: 75,),
                Container (
                  padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)
                    ),
                    elevation: 4,
                    padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                    onPressed: () {

                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text(
                        'Kiểm tra'.toUpperCase(),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}