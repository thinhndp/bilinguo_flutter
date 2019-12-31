class User {
  String token;
  String uid;
  String email;
  String displayName;
  String profilePicture;
  double fortune;
  List<dynamic> inventory;

  User({String token, String uid, String email, String displayName, String profilePicture, double fortune, List<dynamic> inventory}) {
    this.token = token;
    this.uid = uid;
    this.email = email;
    this.displayName = displayName;
    this.profilePicture = profilePicture;
    this.fortune = fortune;
    this.inventory = inventory != null ? List.from(inventory) : [] ;
  }
}