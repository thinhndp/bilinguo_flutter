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

  static String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static String capitalizeString(String string) {
    return '${string[0].toUpperCase()}${string.substring(1)}';
  }
}