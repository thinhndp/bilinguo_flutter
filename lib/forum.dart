import 'package:flutter/material.dart';
import 'utils/HexColor.dart';

class ForumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 57,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: new BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                color: Colors.black12,
                blurRadius: 2.0,
              ),],
              border: Border(bottom: BorderSide(color: Colors.grey[300], width: 2)),
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    "Thảo luận",
                    style: TextStyle(
                      color: HexColor("1cb0f6"),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.search),
                    tooltip: 'Tìm kiếm bài viết',
                    color: HexColor("1cb0f6"),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}