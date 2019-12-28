import 'package:flutter/material.dart';
import './utils/HexColor.dart';
import './mock-data.dart';
import './models/Topic.dart';
import './models/Post.dart';
import 'package:uuid/uuid.dart';

class ForumNewPostWidget extends StatefulWidget {
  const ForumNewPostWidget({ this.onPosted });
  final VoidCallback onPosted;


  @override
  _ForumNewPostWidgetState createState() => _ForumNewPostWidgetState();
}

class _ForumNewPostWidgetState extends State<ForumNewPostWidget> {
  String _chosenTopicId = '';
  List<Topic> _topics;
  final postTitleController = TextEditingController();
  final postContentController = TextEditingController();
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    // _topics = mockTopics; //TODO: API GET
    Topic.fetchTopics()
    .then((topics) {
      setState(() {
        _topics = topics;
      });
    })
    .catchError((err) {
      print(err.toString());
    });
    _isPosting = false;
  }

  @override
  void dispose() {
    postTitleController.dispose();
    postContentController.dispose();
    super.dispose();
  }

  _handlePostButtonPressed() {
    if (postTitleController.text.trim() == '') {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Vui lòng nhập tiêu đề bài viết'),
        backgroundColor: Color(0xffff4444),
      ));
    }
    else if (postContentController.text.trim() == '') {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Vui lòng nhập nội dung bài viết'),
        backgroundColor: Color(0xffff4444),
      ));
    }
    else if (_chosenTopicId == '') {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Vui lòng chọn chủ đề bài viết'),
        backgroundColor: Color(0xffff4444),
      ));
    }
    else {
      // var uuid = Uuid();
      setState(() {
        _isPosting = true;
      });
      Post.postNewPost(currentUser.email, _chosenTopicId, postTitleController.text.trim(), postContentController.text.trim())
      .then((res) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Đăng bài thành công!'),
          backgroundColor: Color(0xff00C851),
        ));
        // _isPosting = false;
        // setState(() {
        //   _isPosting = false;
        // });
        widget.onPosted();
      })
      .catchError((err) {
        // _isPosting = false;
        // setState(() {
        //   _isPosting = false;
        // });
        print(err);
      });
      // Post newPost = new Post(
      //   id: uuid.v4(),
      //   title: postTitleController.text.trim(),
      //   authorUid: currentUser.uid,
      //   topicId: _chosenTopicId,
      //   content: postContentController.text.trim(),
      //   upvoteCount: 0,
      //   downvoteCount: 0,
      //   postedTime: DateTime.now().toIso8601String(),
      //   upvoters: [],
      //   downvoters: [],
      //   commentCount: 0,
      // );
      // mockPosts.add(newPost);
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text('Đăng bài thành công!'),
      //   backgroundColor: Color(0xff00C851),
      // ));
      // print(newPost.title);
      // widget.onPosted();
    }
  }

  _handleTopicPressed(topicId) {
    // print(postContentController.text);
    Scaffold.of(context).hideCurrentSnackBar();
    setState(() {
      _chosenTopicId = topicId;
    });
  }

  _handleInputTap() {
    Scaffold.of(context).hideCurrentSnackBar();
    // print('tap');
  }
 
  Widget _buildTopic(topic) {
    final _width = _chosenTopicId == topic.id ? 150.0 : 133.0;
    final _marginVertical = _chosenTopicId == topic.id ? 0.0 : 5.375;
    final _fontSize = _chosenTopicId == topic.id ? 24.0 : 20.0;
    return Material(
      type: MaterialType.transparency,
      child: AnimatedContainer(
        margin: EdgeInsets.only(right: 10.0, top: _marginVertical, bottom: _marginVertical),
        width: _width,
        duration: Duration(milliseconds: 100),
        child: Ink(
          width: _width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: HexColor(topic.backgroundColor).withOpacity(_chosenTopicId == topic.id ? 1 : 0.5),
          ),
          child: InkWell(
            onTap: () => _handleTopicPressed(topic.id),
            child: Center(
              child: Text(
                '#' + topic.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: _fontSize,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        )
      ),
    );
  }

  Widget _buildTopics(topics) {
    return (_topics != null)
      ? ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          ...topics.map<Widget>((topic) => (
            _buildTopic(topic)
          )).toList()
        ],
      )
      : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator()
        ],
      );
  }

  Widget _buildTopicsSection() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('Chọn chủ đề bài viết', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold )),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            // height: 83.0,
            height: 93.75,
            child: _buildTopics(_topics),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenBody() {
    return Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Column(
        children: <Widget>[
          Container(
            // height: 50.0,
            padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
            margin: EdgeInsets.only(bottom: 14.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.0)]
            ),
            child: TextField(
              controller: postTitleController,
              decoration: InputDecoration.collapsed(
                border: InputBorder.none,
                hintText: 'Nhập tiêu đề bài viết'
              ),
              style: TextStyle(
                fontSize: 18.0,
              ),
              onTap: () => _handleInputTap(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              margin: EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.0)]
              ),
              child: TextField(
                // expands: true,
                controller: postContentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: 'Nhập nội dung bài viết',
                ),
                style: TextStyle(
                  fontSize: 18.0,
                ),
                onTap: () => _handleInputTap(),
              ),
            ),
          ),
          _buildTopicsSection(),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)
                  ),
                  elevation: 4,
                  padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                  onPressed: () => _handlePostButtonPressed(),
                  color: Color(0xFF1CB0F6),
                  textColor: Colors.white,
                  child: Text(
                    'Đăng bài'.toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
            );
  }

  @override
  Widget build(BuildContext context) {
    return (!_isPosting) 
      ? _buildScreenBody()
      : Stack(
        children: <Widget>[
          _buildScreenBody(),
          Center(
            child: CircularProgressIndicator(),
          ),
          Opacity(
            opacity: 0.3,
            child: ModalBarrier(dismissible: false, color: Colors.grey),
          ),
        ],
      );
  }
}

class ForumNewPostScreen extends StatelessWidget {
  const ForumNewPostScreen({ this.backToForumHome });
  final VoidCallback backToForumHome;

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
          Container(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: 'Quay về',
              color: HexColor("1cb0f6"),
              onPressed: () => backToForumHome(),
            ),
          ),
          Center(
            child: Text(
              "Bài viết mới",
              style: TextStyle(
                color: HexColor("1cb0f6"),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          _buildHeader(),
          // ForumWidget(),
          Expanded(
            child: ForumNewPostWidget(
                onPosted: () => backToForumHome()
              ),
          ),
          // Container(
          //   padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          //   child: ForumNewPostWidget(),
          // ),
        ],
      );
  }
}
