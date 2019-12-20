import 'package:flutter/material.dart';
import 'utils/HexColor.dart';
import 'mock-data.dart';
import 'utils/HexColor.dart';

class ForumScreen extends StatelessWidget {
  Widget _buildHeader() {
    return Container(
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
    );
  }

  Widget _buildTopic(topic) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      width: 133.0,
      height: 83.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          colors: [
            HexColor(topic.backgroundColorGradientTop),
            HexColor(topic.backgroundColorGradientBottom),
          ],
        ),
      ),
      child: Center(
        child: Text(
          '#' + topic.name,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget _buildTopicList(topics) {
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: topics.map<Widget>((topic) => (
        _buildTopic(topic)
      )).toList(),
    );
  }

  Widget _buildPopularTopics() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Chủ đề phổ biến', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold )),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            height: 83.0,
            child: _buildTopicList(mockTopics),
          ),
        ],
      ),
    );
  }

  Widget _buildPost(post) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.0)]
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/mock-users/ricardo.jpg'),
                    radius: 24.0,
                  ),
                  SizedBox(width: 10.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        '1 hour(s) ago',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff999999),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.comment, color: Color(0xff777777),),
                  SizedBox(width: 3,),
                  Text(
                    '15',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff777777),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Text(
            post.title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
              color: Color(0xff333333),
            ),
          ),
          Divider(
            thickness: 2.0,
            color: Color(0xffeeeeee),
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.thumb_up, color: Color(0xff777777),),
                  SizedBox(width: 3.0,),
                  Text(
                    '62',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Color(0xff777777),
                    ),
                  ),
                  SizedBox(width: 10.0,),
                  Icon(Icons.thumb_down, color: Color(0xff777777),),
                  SizedBox(width: 3.0,),
                  Text(
                    '62',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Color(0xff777777),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Color(0xff25C18A),
                ),
                child: Center(
                  child: Text(
                    'Từ vựng'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularPosts() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Bài đăng phổ biến', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold )),
          _buildPost(mockPost[0]),
          _buildPost(mockPost[1]),
          _buildPost(mockPost[2]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _buildHeader(),
          Container(
            child: Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                shrinkWrap: true,
                children: <Widget>[
                  _buildPopularTopics(),
                  SizedBox(height: 20.0,),
                  _buildPopularPosts(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}