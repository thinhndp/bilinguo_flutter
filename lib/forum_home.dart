import 'package:flutter/material.dart';
import './utils/HexColor.dart';
// import 'mock-data.dart';
import 'utils/HexColor.dart';
import './models/Post.dart';
import './models/Topic.dart';
import './models/User.dart';
import './utils/Helper.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:bilinguo_flutter/models/AppState.dart';

class ForumWidget extends StatefulWidget {
  const ForumWidget({ this.onPostTap, this.viewModel });
  final ForumPostCallback onPostTap;
  final ViewModel viewModel;
  
  @override
  _ForumWidgetState createState() => _ForumWidgetState();
}

class _ForumWidgetState extends State<ForumWidget> {
  String _chosenTopicId = '';
  List<Post> _posts;
  List<Topic> _topics;
  List<bool> _isUpdatingVote;
  User _currentUser;

  @override
  void initState() {
    super.initState();
    _chosenTopicId = '';
    _currentUser = widget.viewModel.currentUser;

    Topic.fetchTopics().then((topics) {
      setState(() {
        _topics = topics;
      });
    })
    .catchError((err) {
      print(err);
    });

    Post.fetchPosts().then((posts) {
      setState(() {
        _posts = posts;
        _isUpdatingVote = List<bool>.generate(_posts.length, (i) => false);
      });
    })
    .catchError((err) {
      print(err);
    });
  }
  
  _getFilteredPosts() {
    var filteredPosts;
    if (_chosenTopicId == '') {
      filteredPosts = _posts;
    }
    else {
      filteredPosts = (_posts.where((post) => post.topic.id == _chosenTopicId)).toList();
    }
    filteredPosts.sort((Post post1, Post post2) => post2.postedTime.compareTo(post1.postedTime));
    return filteredPosts;
    // return _posts;
  }

  _handleTopicClick(topicId) {
    // print(topicId);
    setState(() {
      _chosenTopicId = topicId;
    });
  }

  _handleVoteClick(post, type) {
    Scaffold.of(context).hideCurrentSnackBar();
    var postIndex = _posts.indexWhere((p) => p.id == post.id);
    if (_isUpdatingVote[postIndex] == true) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Vote từ từ thôi bạn'),
        backgroundColor: Color(0xffff4444),
      ));
      return;
    }
    _isUpdatingVote[postIndex] = true;
    
    var posts = _posts;
    if (type == 'upvote') {
      if (_isPostUpvotedByCurrentUser(post)) {
        posts[postIndex].upvoters.removeWhere((upvoterEmail) => upvoterEmail == _currentUser.email);
      }
      else {
        posts[postIndex].downvoters.removeWhere((downvoterEmail) => downvoterEmail == _currentUser.email);
        posts[postIndex].upvoters.add(_currentUser.email);
      }
    }
    else if (type == 'downvote') {
      if (_isPostDownvotedByCurrentUser(post)) {
        posts[postIndex].downvoters.removeWhere((downvoterEmail) => downvoterEmail == _currentUser.email);
      }
      else {
        posts[postIndex].upvoters.removeWhere((upvoterEmail) => upvoterEmail == _currentUser.email);
        posts[postIndex].downvoters.add(_currentUser.email);
      }
    }
    posts[postIndex].upvoteCount = posts[postIndex].upvoters.length;
    posts[postIndex].downvoteCount = posts[postIndex].downvoters.length;
    setState(() {
      _posts[postIndex] = posts[postIndex];
    });
    print(postIndex);

    Post.votePost(_currentUser.email, post.id, type)
    .then((res) {
      Post.getPostWithoutComments(post.id)
      .then((post) {
        var index = _posts.indexWhere((p) => p.id == post.id);
        print(index);
        _isUpdatingVote[postIndex] = false;
        setState(() {
          _posts[index] = post;
        });
      });
    })
    .catchError((err) {
      print(err);
    });
  }

  _handlePostTap(post) {
    widget.onPostTap(post);
  }

  Widget _buildTopicAll() {
    //This is the 'All' filter

    final _width = _chosenTopicId == '' ? 150.0 : 133.0;
    final _marginVertical = _chosenTopicId == '' ? 0.0 : 5.375;
    final _fontSize = _chosenTopicId == '' ? 24.0 : 20.0;
    final _defaultColor = '#2c3e50';
    return Material(
        type: MaterialType.transparency,
        child: AnimatedContainer(
          margin: EdgeInsets.only(right: 10.0, bottom: _marginVertical, top: _marginVertical),
          width: _width,
          duration: Duration(milliseconds: 100),
          child: Ink(
            width: _width,
            // height: 83.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: HexColor(_defaultColor).withOpacity(_chosenTopicId == '' ? 1 : 0.5),
            ),
            child: InkWell(
              onTap: () => _handleTopicClick(''),
              child: Center(
                child: Text(
                  '#Tất cả',
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
          // height: _chosenTopicId == topic.id ? 93.75 : 83.0,
          // width: 133.0,
          // height: 83.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: HexColor(topic.backgroundColor).withOpacity(_chosenTopicId == topic.id ? 1 : 0.5),
            
          ),
          child: InkWell(
            // splashColor: Colors.white,
            // splashColor: HexColor(topic.backgroundColor),
            onTap: () => _handleTopicClick(topic.id),
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

  Widget _buildTopicList(topics) {
    return (_topics != null)
      ? ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          _buildTopicAll(),
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

  Widget _buildPopularTopics() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('Chủ đề phổ biến', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold )),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            // height: 83.0,
            height: 93.75,
            child: _buildTopicList(_topics),
          ),
        ],
      ),
    );
  }

  _isPostUpvotedByCurrentUser(post) {
    return post.upvoters.contains(_currentUser.email);
  }
  _isPostDownvotedByCurrentUser(post) {
    return post.downvoters.contains(_currentUser.email);
  }

  Widget _buildPost(post) {
    final _postAuthor = post.author;
    return GestureDetector(
      onTap: () => _handlePostTap(post),
      child: Container(
        margin: EdgeInsets.only(top: 20.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.0)]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(_postAuthor.profilePicture),
                      radius: 24.0,
                    ),
                    SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _postAuthor.displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          Helper.getFormattedPostedTime(post.postedTime),
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
                    Icon(
                      Icons.comment,
                      color: Color(0xff777777),
                    ),
                    SizedBox(width: 3,),
                    Text(
                      post.commentCount.toString(),
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
                    InkWell(
                      onTap: () => _handleVoteClick(post, 'upvote'),
                      child: Icon(
                        Icons.thumb_up,
                        color: _isPostUpvotedByCurrentUser(post) ? Color(0xff1CB0F6) : Color(0xff777777),
                      ),
                    ),
                    // Icon(
                    //   Icons.thumb_up,
                    //   color: isPostUpvotedByCurrentUser(_currentUserId, post) ? Color(0xff1CB0F6) : Color(0xff777777),
                    // ),
                    SizedBox(width: 3.0,),
                    Text(
                      post.upvoteCount.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: _isPostUpvotedByCurrentUser(post) ? Color(0xff1CB0F6) : Color(0xff777777),
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    InkWell(
                      onTap: () => _handleVoteClick(post, 'downvote'),
                      child: Icon(
                        Icons.thumb_down,
                        color: _isPostDownvotedByCurrentUser(post) ? Color(0xffF6621C) : Color(0xff777777),
                      ),
                    ),
                    SizedBox(width: 3.0,),
                    Text(
                      post.downvoteCount.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: _isPostDownvotedByCurrentUser(post) ? Color(0xffF6621C) : Color(0xff777777),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    // color: HexColor(_getTopicById(post.topicId).backgroundColor)
                    color: HexColor(post.topic.backgroundColor)
                    // color: Color(0xff25C18A),
                  ),
                  child: Center(
                    child: Text(
                      // (_getTopicById(post.topicId).name).toUpperCase(),
                      (post.topic.name).toUpperCase(),
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
      ),
    );
  }

  Widget _buildPopularPosts() {
    return (_posts != null) 
      ? Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Bài đăng phổ biến', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold )),
            ..._getFilteredPosts().map<Widget>((post) => (_buildPost(post))).toList(),
          ],
        ),
      )
      : Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Bài đăng phổ biến', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold )),
            SizedBox(height: 40.0,),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
      shrinkWrap: true,
      children: <Widget>[
        // Hero(
        //   tag: 'topic-list',
        //   child: _buildPopularTopics(),
        // ),
        _buildPopularTopics(),
        SizedBox(height: 20.0,),
        _buildPopularPosts(),
      ],
    );
  }
}

class ForumHomeScreen extends StatelessWidget {
  const ForumHomeScreen({ this.onNewPostTap, this.onPostTap });
  final VoidCallback onNewPostTap;
  final ForumPostCallback onPostTap;

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
              // color: HexColor("1cb0f6"),
              color: Colors.white,
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody(viewModel) {
    return Column(
        children: <Widget>[
          _buildHeader(),
          // ForumWidget(),
          Container(
            child: Expanded(
              child: Stack(
                children: <Widget>[
                  ForumWidget(
                    onPostTap: onPostTap,
                    viewModel: viewModel
                  ),
                  Container(
                    alignment: AlignmentDirectional.bottomEnd,
                    padding: EdgeInsets.all(20.0),
                    child: FloatingActionButton(
                      onPressed: () { onNewPostTap(); },
                      backgroundColor: HexColor('1cb0f6'),
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: (Store<AppState> store) => ViewModel.create(store),
      builder: (context, ViewModel viewModel) => _buildBody(viewModel)
    );
  }
}

typedef ForumPostCallback = void Function(Post post);