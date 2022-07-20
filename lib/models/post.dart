import 'package:firebase/models/comment.dart';

class Like {
  late int like;
  late List<String> usernames;
  Like({required this.like, required this.usernames});
  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
        like: json['like'],
        usernames: (json['usernames'] as List)
            .map((e) => (e as String))
            .toList()); //taking single users
  }

  Map<String, dynamic> toJson() {
    return {'like': this.like, 'usernames': this.usernames};
  }
}

class Post {
  late String id;
  late String imageId;
  late String userImage;
  late String userId;
  late String title;
  late String description;
  late Like likeData;
  late String whose;
  late String whosename;
  late List<Comments> comments;

  Post(
      {required this.imageId,
      required this.id,
      required this.userId,
      required this.description,
      required this.title,
      required this.userImage,
      required this.whose,
      required this.whosename,
      required this.likeData,
      required this.comments});
}
