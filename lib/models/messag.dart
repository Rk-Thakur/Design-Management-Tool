class message {
  late final String text;
  late final String username;
  late final String imageUrl;
  late final String userId;

  message(
      {required this.text,
      required this.username,
      required this.imageUrl,
      required this.userId});

  factory message.fromJson(Map<String, dynamic> json) {
    return message(
        text: json['message'],
        username: json['username'],
        imageUrl: json['imageUrl'],
        userId: json['userId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': this.imageUrl,
      'username': this.username,
      'message': this.text,
      'userId': this.userId
      // 'createdAt': this.createat
    };
  }
}
