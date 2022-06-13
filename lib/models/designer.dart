class User {
  final String userImage;
  late final String userId;
  final String username;
  final String email;

  User(
      {required this.username,
      required this.userId,
      required this.userImage,
      required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['username'],
        userId: json['userId'],
        userImage: json['userImage'],
        email: json['email']);
  }
}
