class Helper {
  static String getFormattedPostedTime(ISOPostedTime) {
    var now = new DateTime.now();
    var postedTime = DateTime.parse(ISOPostedTime);
    if (now.difference(postedTime).inDays != 0) {
      return (now.difference(postedTime).inDays).toString() + ' ngày trước';
    }
    if (now.difference(postedTime).inHours != 0) {
      return (now.difference(postedTime).inHours).toString() + ' giờ trước';
    }
    return (now.difference(postedTime).inMinutes).toString() + ' phút trước';
  }
}