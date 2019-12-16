class Course {
  String id;
  String name;
  String unlockedIconUrl;
  String lockedIconUrl;
  String backgroundColor;
  int levelReached;
  bool isUnlocked;
  int levelProgress;

  Course(String id, String name, String unlockedIconUrl, String lockedIconUrl,
      String backgroundColor, int levelReached, bool isUnlocked,
      int levelProgress,) {
    this.id = id;
    this.name = name;
    this.unlockedIconUrl = unlockedIconUrl;
    this.lockedIconUrl = lockedIconUrl;
    this.backgroundColor = backgroundColor;
    this.levelReached = levelReached;
    this.isUnlocked = isUnlocked;
    this.levelProgress = levelProgress;
  }
}