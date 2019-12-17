class Achievement {
  String imgURL;
  String title;
  String description;
  int level;
  int currentProgress;
  int totalProgress; // TODO: this totalProgress should depend on level

  Achievement({ String imgURL, String title, String description, int level, int currentProgress, int totalProgress }) {
    this.imgURL = imgURL;
    this.title = title;
    this.description = description;
    this.level = level;
    this.currentProgress = currentProgress;
    this.totalProgress = totalProgress;
  }
}