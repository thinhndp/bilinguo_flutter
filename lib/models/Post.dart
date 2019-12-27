
import 'User.dart';
import 'Comment.dart';

class Post {
  String id;
  String title;
  String authorUid;
  String authorEmail;
  String topicId;
  String content;
  int upvoteCount;
  int downvoteCount;
  String postedTime;
  List<String> upvoters;
  List<String> downvoters;
  int commentCount;
  List<Comment> comments;

  Post({String id, String title, String authorUid, String authorEmail, String topicId, String content,
      int upvoteCount, int downvoteCount, String postedTime, List<String>upvoters,
      List<String> downvoters, int commentCount, List<Comment> comments}) {
    this.id = id;
    this.title = title;
    this.authorUid = authorUid;
    this.authorEmail = authorEmail;
    this.topicId = topicId;
    this.content = content;
    this.upvoteCount = upvoteCount;
    this.downvoteCount = downvoteCount;
    this.postedTime = postedTime;
    this.upvoters = upvoters;
    this.downvoters = downvoters;
    this.commentCount = commentCount;
    this.comments = comments;
  }
}