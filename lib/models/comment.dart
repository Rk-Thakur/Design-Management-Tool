class Comments {
  late String imageUrl;
  late String username;
  late String comment;

  Comments(
      {required this.imageUrl, required this.username, required this.comment});

  factory Comments.fromJson(Map<String, dynamic> json) {
    //aaunay
    return Comments(
        imageUrl: json['imageUrl'],
        username: json['username'],
        comment: json['comment']);
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': this.imageUrl,
      'username': this.username,
      'comment': this.comment
    };
  }
}
