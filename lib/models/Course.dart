class Course {
  String id;
  String name;
  String unlockedIconUrl;
  String lockedIconUrl;
  String backgroundColor;
  int levelReached;
  bool isUnlocked;
  double levelProgress;
  int totalQuestions;

  Course(String id, String name, String unlockedIconUrl, String lockedIconUrl,
      String backgroundColor, int levelReached, bool isUnlocked,
      double levelProgress, int totalQuestions) {
    this.id = id;
    this.name = name;
    this.unlockedIconUrl = unlockedIconUrl;
    this.lockedIconUrl = lockedIconUrl;
    this.backgroundColor = backgroundColor;
    this.levelReached = levelReached;
    this.isUnlocked = isUnlocked;
    this.levelProgress = levelProgress;
    this.totalQuestions = totalQuestions;
  }
}