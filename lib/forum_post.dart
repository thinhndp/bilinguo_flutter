import 'package:flutter/material.dart';
import './utils/HexColor.dart';
import './models/Post.dart';
import './models/User.dart';
import './models/Topic.dart';
import './models/Comment.dart';
import './mock-data.dart';
import './utils/Helper.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//user when loading not done. Won't show
User dummyUser = User(
  uid: 'elementarymydear',
  displayName: 'Hilter',
  profilePicture: 'https://i.imgflip.com/3g5g2e.jpg',
  email: 'hitlera@uit.edu.vn'
);

class ForumPostWidget extends StatefulWidget {
  const ForumPostWidget({ this.post });
  final Post post;

  @override
  _ForumPostWidgetState createState() => _ForumPostWidgetState();
}

class _ForumPostWidgetState extends State<ForumPostWidget> {
  Post _post;
  List<Comment> _comments;
  bool _isUpdatingPostVote = false;
  List<bool> _isUpdatingCommentVote;
  bool _isPosting = false;
  // List<User> _users = [];
  // List<Topic> _topics = [];
  // Topic _topic = Topic(id: 'null', name: '?', backgroundColor: '#ffffff');
  // List<Post> _posts = [];
  // String _newComment = '';
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isUpdatingPostVote = false;
    _isPosting = false;
    // _post = widget.post;
    Post.getPostWithoutComments(widget.post.id)
    .then((post) {
      setState(() {
        _post = post;
      });
    })
    .catchError((err) {
      print(err);
    });

    Comment.fetchPostComments(widget.post.id)
    .then((comments) {
      setState(() {
        _comments = comments;
        _isUpdatingCommentVote = List<bool>.generate(_comments.length, (i) => false);
      });
    })
    .catchError((err) {
      print(err);
    });
    // Firestore.instance
    //   .collection('posts')
    //   .document(widget.post.id)
    //   .get()
    //   .then((DocumentSnapshot ds) {
    //     // use ds as a snapshot
    //     setState(() {
    //       _topic = Topic(
    //         id: ds.documentID,
    //         name: ds.data['name'],
    //         backgroundColor: ds.data['backgroundColor'],
    //       );
    //     });
    //     setState(() {
    //       _post = Post(
    //         id: ds.documentID,
    //         title: ds.data['title'],
    //         // authorUid: ds.data['authorUid'],
    //         // authorEmail: ds.data['authorEmail'],
    //         // topicId: ds.data['topicId'],
    //         content: ds.data['content'],
    //         upvoteCount: ds.data['upvoteCount'],
    //         downvoteCount: ds.data['downvoteCount'],
    //         postedTime: ds.data['postedTime'],
    //         upvoters: new List<String>.from(ds.data['upvoters']),
    //         downvoters: new List<String>.from(ds.data['downvoters']),
    //         commentCount: 0,
    //         comments: [],
    //       );
    //     });
    //     Firestore.instance
    //       .collection('posts')
    //       .document(ds.documentID)
    //       .collection('comments')
    //       .snapshots()
    //       .listen((data) =>
    //           data.documents.forEach((doc) => {
    //             setState(() {
    //               _post.comments.add(
    //                 Comment(
    //                   id: doc.documentID,
    //                   authorUid: doc['authorUid'],
    //                   authorEmail: doc['authorEmail'],
    //                   content: doc['content'],
    //                   upvoteCount: doc['upvoteCount'],
    //                   downvoteCount: doc['downvoteCount'],
    //                   postedTime: doc['postedTime'],
    //                   upvoters: new List<String>.from(doc['upvoters']),
    //                   downvoters: new List<String>.from(doc['downvoters']),
    //                 )
    //               );
    //               _post.commentCount += 1;
    //             })
    //           }));
    //   });

    // // _users = mockUsers; // TODO: API GET
    // _users = [];
    // Firestore.instance
    //   .collection('users')
    //   .snapshots()
    //   .listen((data) => data.documents.forEach((doc) => {
    //     // _topics.add(
    //     //   Topic(
    //     //     id: doc.documentID,
    //     //     name: doc['name'],
    //     //     backgroundColor: doc['backgroundColor'],
    //     //   )
    //     // )
    //     setState(() {
    //       _users.add(
    //         User(
    //           uid: doc['uid'],
    //           displayName: doc['displayName'],
    //           profilePicture: 'mock-users/anon.jpg',
    //           email: doc['email'],
    //         ));
    //     })
    //     // _topics.forEach((f) => print(f.name))
    //   }));

    
    // // _topics = mockTopics; // TODO: API GET
    // Firestore.instance
    //   .collection('topics')
    //   .document(widget.post.topic.id)
    //   .get()
    //   .then((DocumentSnapshot ds) {
    //     // use ds as a snapshot
    //     setState(() {
    //       _topic = Topic(
    //         id: ds.documentID,
    //         name: ds.data['name'],
    //         backgroundColor: ds.data['backgroundColor'],
    //       );
    //     });
    //   });
    // _posts = []; // TODO: API GET
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }


  // _getUserByUid(uid) {
  //   return _users.firstWhere((user) => user.uid == uid);
  // }

  // _getUserByEmail(email) {
  //   return _users.firstWhere((user) => user.email == email,
  //     orElse: () => User(uid: 'null', displayName: 'Anon', profilePicture: 'mock-users/anon.jpg'));
  // }

  // _getTopicById(topicId) {
  //   return _topics.firstWhere((topic) => topic.id == topicId);
  // }

  _getSortedCommentList(comments) {
    //sort by comment time
    var sortedComments = comments;
    sortedComments.sort((Comment comment1, Comment comment2) => comment2.postedTime.compareTo(comment1.postedTime));
    return sortedComments;
  }

  _isPostUpvotedByCurrentUser(post) {
    return post.upvoters.contains(currentUser.email);
  }
  _isPostDownvotedByCurrentUser(post) {

    return post.downvoters.contains(currentUser.email);
  }

  // _handleNewCommentChanged(comment) {
  //   setState(() {
  //     newComment = commentController.text.trim();
  //   });
  // }

  _handlePostNewComment(context) {
    if (commentController.text.trim() == '') {
      return;
    }
    print(commentController.text.trim());
    setState(() {
      _isPosting = true;
    });
    Comment.postNewComment(_post.id, currentUser.email, commentController.text.trim())
    .then((res) {
      Comment.fetchPostComments(_post.id)
      .then((comments) {
        setState(() {
          _comments = comments;
          _isPosting = false;
        });
      })
      .catchError((err) {
        print(err);
        setState(() {
          _isPosting = false;
        });
      });
    })
    .catchError((err) {
      print(err);
      setState(() {
        _isPosting = false;
      });
    });
    // var uuid = Uuid();
    // Comment newComment = new Comment(
    //   id: uuid.v4(),
    //   authorUid: currentUser.uid,
    //   content: commentController.text.trim(),
    //   upvoteCount: 0,
    //   downvoteCount: 0,
    //   postedTime: DateTime.now().toIso8601String(),
    //   upvoters: [],
    //   downvoters: [],
    // );
    // print(_posts.length);
    // var postIndex = _posts.indexWhere((post) => post.id == _post.id);
    // var post = _post;
    // post.comments.add(newComment);
    // mockPosts[postIndex] = post; //TODO: API POST
    // setState(() {
    //   _posts = mockPosts; //TODO: API GET
    //   _post = _posts[postIndex];
    // });
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text('Đăng bình luận thành công!'),
    //   backgroundColor: Color(0xff00C851),
    // ));
    Navigator.of(context).pop();
    commentController.clear();
    // var post = _post;
  }

  showCommentBottomSheet(context) {
    print(_post.id);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 300.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_downward),
                          tooltip: 'Quay về',
                          // color: HexColor("1cb0f6"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Text(
                          'Bình luận mới',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 16.0),
                      child: InkWell(
                        onTap: () => _handlePostNewComment(context),
                        child: Text(
                          'Đăng'.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: commentController.text.trim() == '' ? Color(0xFFDDDDDD) : Color(0xFF1CB0F6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(color: Color(0xffeeeeee), height: 2),
                Container(
                  padding: EdgeInsets.only(left: 14.0, right: 14.0, bottom: 14.0),
                  child: TextField(
                    // expands: true,
                    // onChanged: (comment) => _handleNewCommentChanged(comment),
                    controller: commentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration.collapsed(
                      border: InputBorder.none,
                      hintText: 'Nhập nội dung bài viết',
                    ),
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    onTap: () => {},
                  ),
                ),
                // TextField(
                //   // expands: true,
                //   // controller: postContentController,
                //   keyboardType: TextInputType.multiline,
                //   maxLines: null,
                //   decoration: InputDecoration.collapsed(
                //     border: InputBorder.none,
                //     hintText: 'Nhập nội dung bài viết',
                //   ),
                //   style: TextStyle(
                //     fontSize: 18.0,
                //   ),
                //   onTap: () => {},
                // ),
              ],
            ),
          )
        );
      },
    );
  }

  _handleVoteClick(type) {
    Scaffold.of(context).hideCurrentSnackBar();
    if (_isUpdatingPostVote == true) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Vote từ từ thôi bạn'),
        backgroundColor: Color(0xffff4444),
      ));
      return;
    }
    _isUpdatingPostVote = true;
    
    var post = _post;
    if (type == 'upvote') {
      if (_isPostUpvotedByCurrentUser(post)) {
        post.upvoters.removeWhere((upvoterEmail) => upvoterEmail == currentUser.email);
      }
      else {
        post.downvoters.removeWhere((downvoterEmail) => downvoterEmail == currentUser.email);
        post.upvoters.add(currentUser.email);
      }
    }
    else if (type == 'downvote') {
      if (_isPostDownvotedByCurrentUser(post)) {
        post.downvoters.removeWhere((downvoterEmail) => downvoterEmail == currentUser.email);
      }
      else {
        post.upvoters.removeWhere((upvoterEmail) => upvoterEmail == currentUser.email);
        post.downvoters.add(currentUser.email);
      }
    }
    post.upvoteCount = post.upvoters.length;
    post.downvoteCount = post.downvoters.length;
    setState(() {
      _post = post;
    });

    Post.votePost(currentUser.email, post.id, type)
    .then((res) {
      Post.getPostWithoutComments(post.id)
      .then((p) {
        _isUpdatingPostVote = false;
        setState(() {
          _post = p;
        });
      });
    })
    .catchError((err) {
      print(err);
    });
  }

  _handleCommentVoteClick(comment, type) {
    Scaffold.of(context).hideCurrentSnackBar();
    var commentIndex = _comments.indexWhere((c) => c.id == comment.id);
    if (_isUpdatingCommentVote[commentIndex] == true) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Vote từ từ thôi bạn'),
        backgroundColor: Color(0xffff4444),
      ));
      return;
    }
    _isUpdatingCommentVote[commentIndex] = true;
    
    var comments = _comments;
    if (type == 'upvote') {
      if (_isPostUpvotedByCurrentUser(comment)) {
        comments[commentIndex].upvoters.removeWhere((upvoterEmail) => upvoterEmail == currentUser.email);
      }
      else {
        comments[commentIndex].downvoters.removeWhere((downvoterEmail) => downvoterEmail == currentUser.email);
        comments[commentIndex].upvoters.add(currentUser.email);
      }
    }
    else if (type == 'downvote') {
      if (_isPostDownvotedByCurrentUser(comment)) {
        comments[commentIndex].downvoters.removeWhere((downvoterEmail) => downvoterEmail == currentUser.email);
      }
      else {
        comments[commentIndex].upvoters.removeWhere((upvoterEmail) => upvoterEmail == currentUser.email);
        comments[commentIndex].downvoters.add(currentUser.email);
      }
    }
    comments[commentIndex].upvoteCount = comments[commentIndex].upvoters.length;
    comments[commentIndex].downvoteCount = comments[commentIndex].downvoters.length;
    setState(() {
      _comments[commentIndex] = comments[commentIndex];
    });
    // print(commentIndex);

    Comment.voteComment(currentUser.email, _post.id, comment.id, type)
    .then((res) {
      Comment.getComment(_post.id, comment.id)
      .then((comment) {
        var index = _comments.indexWhere((c) => c.id == comment.id);
        // print(index);
        _isUpdatingCommentVote[commentIndex] = false;
        setState(() {
          _comments[index] = comment;
        });
      });
    })
    .catchError((err) {
      print(err);
    });
    // // print(voteType);
    // var comments = _post.comments;
    // var commentIndex = comments.indexWhere((_comment) => _comment.id == comment.id);
    // var postIndex = _posts.indexWhere((post) => post.id == _post.id);
    // if (voteType == 'upvote') {
    //   if (_isPostUpvotedByCurrentUser(comment)) {
    //     comments[commentIndex].upvoters.removeWhere((upvoterUid) => upvoterUid == currentUser.uid);
    //   }
    //   else {
    //     comments[commentIndex].downvoters.removeWhere((downvoterUid) => downvoterUid == currentUser.uid);
    //     comments[commentIndex].upvoters.add(currentUser.uid);
    //   }
    // }
    // else if (voteType == 'downvote') {
    //   if (_isPostDownvotedByCurrentUser(comment)) {
    //     comments[commentIndex].downvoters.removeWhere((downvoterUid) => downvoterUid == currentUser.uid);
    //   }
    //   else {
    //     comments[commentIndex].upvoters.removeWhere((upvoterUid) => upvoterUid == currentUser.uid);
    //     comments[commentIndex].downvoters.add(currentUser.uid);
    //   }
    // }
    // comments[commentIndex].upvoteCount = comments[commentIndex].upvoters.length;
    // comments[commentIndex].downvoteCount = comments[commentIndex].downvoters.length;
    // _post.comments = [ ...comments ];
    // // mockPosts[postIndex] = _post; //TODO: API POST
    // // setState(() {
    // //   _posts = mockPosts; //TODO: API GET
    // //   _post = _posts[postIndex];
    // // });
  }

  Widget _buildComment(comment) {
    // final _currentUserId = 'user1'; //
    final _postAuthor = comment != null ? comment.author : dummyUser;
    return Container(
        margin: EdgeInsets.only(top: 14.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.0)],
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black26,
          //     blurRadius: 0.0,
          //     offset: Offset(0.0, 1),
          //     spreadRadius: 3.0,
          //   )
          // ],
          
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
                          Helper.getFormattedPostedTime(comment.postedTime),
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
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              comment.content,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
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
                      onTap: () => _handleCommentVoteClick(comment, 'upvote'),
                      child: Icon(
                        Icons.thumb_up,
                        color: _isPostUpvotedByCurrentUser(comment) ? Color(0xff1CB0F6) : Color(0xff777777),
                      ),
                    ),
                    // Icon(
                    //   Icons.thumb_up,
                    //   color: isPostUpvotedByCurrentUser(_currentUserId, post) ? Color(0xff1CB0F6) : Color(0xff777777),
                    // ),
                    SizedBox(width: 3.0,),
                    Text(
                      comment.upvoteCount.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: _isPostUpvotedByCurrentUser(comment) ? Color(0xff1CB0F6) : Color(0xff777777),
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    InkWell(
                      onTap: () => _handleCommentVoteClick(comment, 'downvote'),
                      child: Icon(
                        Icons.thumb_down,
                        color: _isPostDownvotedByCurrentUser(comment) ? Color(0xffF6621C) : Color(0xff777777),
                      ),
                    ),
                    SizedBox(width: 3.0,),
                    Text(
                      comment.downvoteCount.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: _isPostDownvotedByCurrentUser(comment) ? Color(0xffF6621C) : Color(0xff777777),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
  }

  Widget _buildCommentsSection() {
    return Container(
      padding: EdgeInsets.only(left: 14.0, right: 14.0, bottom: 14.0),
      child: (_comments != null)
      ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ..._getSortedCommentList(_comments).map<Widget>((comment) => (_buildComment(comment))).toList(),
        ],
      )
      : Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }


  Widget _buildPost(post) {
    // final _currentUserId = 'user1'; //
    final _postAuthor = post != null ? post.author: dummyUser;
    return Container(
        // margin: EdgeInsets.only(top: 20.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2.0,
              offset: Offset(0.0, 2),
              // spreadRadius: 25.0,
            )
          ]
        ),
        child: (_post != null)
        ? Column(
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
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              post.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Color(0xff333333),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              post.content,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
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
                      onTap: () => _handleVoteClick('upvote'),
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
                      onTap: () => _handleVoteClick('downvote'),
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
                    color: HexColor(post.topic.backgroundColor)
                    // color: Color(0xff25C18A),
                  ),
                  child: Center(
                    child: Text(
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
        )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator()
            ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // return ListView(
    //   shrinkWrap: true,
    //   children: <Widget>[
    //     _buildPost(_post),
    //     _buildCommentsSection(),
    //   ],
    // );
    return Stack(
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildPost(_post),
            _buildCommentsSection(),
          ]
        ),
        Container(
          alignment: AlignmentDirectional.bottomEnd,
          padding: EdgeInsets.all(20.0),
          child: FloatingActionButton(
            onPressed: () => showCommentBottomSheet(context),
            backgroundColor: HexColor('1cb0f6'),
            child: Icon(Icons.comment),
          ),
        ),
        if (_isPosting) (
          Stack(
            children: <Widget>[
              Opacity(
                opacity: 0.6,
                child: ModalBarrier(dismissible: false, color: Colors.white),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          )
        ),
      ],
    );
  }
}

class ForumPostScreen extends StatelessWidget {
  const ForumPostScreen({ this.post, this.backToForumHome });
  final VoidCallback backToForumHome;
  final Post post;

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
              "Bài viết",
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
    return Container(
      color: Color(0xffD0F5FF),
      child: Column(
        children: <Widget>[
          _buildHeader(),
          // ForumWidget(),
          Expanded(
            child: Container(
              // padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: ForumPostWidget(
                post: post,
              ),
            ),
          ),
        ],
      ),
    );
  }
}