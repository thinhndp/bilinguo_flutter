
import 'User.dart';
import 'Comment.dart';
import 'Topic.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Post {
  String id;
  String title;
  // String authorUid;
  // String authorEmail;
  User author;
  // String topicId;
  Topic topic;
  String content;
  int upvoteCount;
  int downvoteCount;
  String postedTime;
  List<String> upvoters;
  List<String> downvoters;
  int commentCount;
  List<Comment> comments;

  // Post({String id, String title, String authorUid, String authorEmail, String topicId, String content,
  //     int upvoteCount, int downvoteCount, String postedTime, List<String>upvoters,
  //     List<String> downvoters, int commentCount, List<Comment> comments}) {
  //   this.id = id;
  //   this.title = title;
  //   this.authorUid = authorUid;
  //   this.authorEmail = authorEmail;
  //   this.topicId = topicId;
  //   this.content = content;
  //   this.upvoteCount = upvoteCount;
  //   this.downvoteCount = downvoteCount;
  //   this.postedTime = postedTime;
  //   this.upvoters = upvoters;
  //   this.downvoters = downvoters;
  //   this.commentCount = commentCount;
  //   this.comments = comments;
  // }

  Post({String id, String title, User author, Topic topic, String content,
      int upvoteCount, int downvoteCount, String postedTime, List<String>upvoters,
      List<String> downvoters, int commentCount, List<Comment> comments}) {
    this.id = id;
    this.title = title;
    this.author = author;
    this.topic = topic;
    this.content = content;
    this.upvoteCount = upvoteCount;
    this.downvoteCount = downvoteCount;
    this.postedTime = postedTime;
    this.upvoters = upvoters;
    this.downvoters = downvoters;
    this.commentCount = commentCount;
    this.comments = comments;
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      author: User.fromJson(json['author']),
      topic: Topic.fromJson(json['topic']),
      content: json['content'],
      upvoteCount: json['upvoteCount'],
      downvoteCount: json['downvoteCount'],
      postedTime: json['postedTime'],
      upvoters: List<String>.from(json['upvoters']),
      downvoters: List<String>.from(json['downvoters']),
      commentCount: json['commentCount'],
      comments: []
    );
  }

  // TODO: Move to another file
  static Future<List<Post>> fetchPosts() async {
    try {
      final res = await http.get('https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/getPosts');
      List<Post> posts = json.decode(res.body).map<Post>((model) => Post.fromJson(model)).toList();
      return posts;
    }
    catch (err) {
      print('oof fetch posts ' + err.toString());
    }
  }

  static Future<Post> getPostWithoutComments(postId) async {
    try {
      const url = 'https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/getPostWithoutComments/';
      final res = await http.get(url + postId);
      Post post = Post.fromJson(json.decode(res.body));
      return post;
    }
    catch (err) {
      print('oof get post w/o comments ' + err.toString());
    }
  }

  static Future votePost(userEmail, postId, type) async {
    try {
      const url = "https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/votePost";
      await http.post(url, body: {'userEmail': userEmail, 'postId': postId, 'type': type});
    }
    catch (err) {
      print('oof vote post ' + err.toString());
    }
  }
}