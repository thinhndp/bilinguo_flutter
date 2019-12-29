
import 'User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Comment {
  String id;
  // String authorUid;
  // String authorEmail;
  User author;
  String content;
  int upvoteCount;
  int downvoteCount;
  String postedTime;
  List<String> upvoters;
  List<String> downvoters;

  Comment({String id, User author, String content, int upvoteCount, int downvoteCount,
    String postedTime, List<String>upvoters, List<String> downvoters}) {
    this.id = id;
    // this.authorUid = authorUid;
    // this.authorEmail = authorEmail;
    this.author = author;
    this.content = content;
    this.upvoteCount = upvoteCount;
    this.downvoteCount = downvoteCount;
    this.postedTime = postedTime;
    this.upvoters = upvoters;
    this.downvoters = downvoters;
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      author: User.fromJson(json['author']),
      content: json['content'],
      upvoteCount: json['upvoteCount'],
      downvoteCount: json['downvoteCount'],
      postedTime: json['postedTime'],
      upvoters: List<String>.from(json['upvoters']),
      downvoters: List<String>.from(json['downvoters']),
    );
  }

  static Future<List<Comment>> fetchPostComments(postId) async {
    try {
      const url = "https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/getPostComments/";
      final res = await http.get(url + postId);
      // print(url + postId);
      List<Comment> comments = json.decode(res.body).map<Comment>((model) => Comment.fromJson(model)).toList();
      // print(comments.length);
      return comments;
    }
    catch (err) {
      print('oof get post comments ' + err.toString());
    }
  }

  static Future voteComment(userEmail, postId, commentId, type) async {
    try {
      const url = "https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/voteComment";
      await http.post(url, body: { 'userEmail': userEmail, 'postId': postId, 'commentId': commentId,'type': type });
    }
    catch (err) {
      print('oof vote comment ' + err.toString());
    }
  }

  static Future<Comment> getComment(postId, commentId) async {
    try {
      const url = "https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/getComment";
      final res = await http.get(url + '?postId=' + postId + '&commentId=' + commentId);
      Comment comment = Comment.fromJson(json.decode(res.body));
      return comment;
    }
    catch (err) {
      print('oof get comment ' + err.toString());
    }
  }

  static Future postNewComment(postId, authorEmail, content) async {
    try {
      const url = "https://us-central1-fb-cloud-functions-demo-4de69.cloudfunctions.net/postNewComment/";
      await http.post(url + postId, body: { 'authorEmail': authorEmail, 'content': content });
    }
    catch (err) {
      print('oof post new comment ' + err.toString());
    }
  }
}