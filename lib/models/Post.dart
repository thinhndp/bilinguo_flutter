import 'User.dart';

class Post {
  String id;
  String title;
  String authorUid;
  String topicId;
  String content;
  int upvoteCount;
  int downvoteCount;
  String postedTime; //TODO: calculate time passed since created
  List<String> upvoters;
  List<String> downvoters;
  int commentCount; //TODO: change to array

  Post({String id, String title, String authorUid, String topicId, String content,
      int upvoteCount, int downvoteCount, String postedTime, List<String>upvoters,
      List<String> downvoters, int commentCount}) {
    this.id = id;
    this.title = title;
    this.authorUid = authorUid;
    this.topicId = topicId;
    this.content = content;
    this.upvoteCount = upvoteCount;
    this.downvoteCount = downvoteCount;
    this.postedTime = postedTime;
    this.upvoters = upvoters;
    this.downvoters = downvoters;
    this.commentCount = commentCount;
  }
}