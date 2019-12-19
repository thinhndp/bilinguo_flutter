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
  Set<User> upvoter;
  Set<User> downvoter;

  Post(String id, String title, String authorUid, String topicId, String content,
      int upvoteCount, int downvoteCount, String postedTime, Set<User>upvoter,
      Set<User> downvoter) {
    this.id = id;
    this.title = title;
    this.authorUid = authorUid;
    this.topicId = topicId;
    this.content = content;
    this.upvoteCount = upvoteCount;
    this.downvoteCount = downvoteCount;
    this.postedTime = postedTime;
    this.upvoter = upvoter;
    this.downvoter = downvoter;
  }
}