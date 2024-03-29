class design_details {
  late String designDescription;
  late int price;
  late String userImage;
  late String username;
  late String userId;
  late String designtitle;

  design_details(
      {required this.designDescription,
      required this.price,
      required this.username,
      required this.userImage,
      required this.userId,
      required this.designtitle});

  factory design_details.fromJson(Map<String, dynamic> json) {
    return design_details(
        username: json['username'],
        designDescription: json['designDescription'],
        userImage: json['userImage'],
        price: json['price'],
        userId: json['userId'],
        designtitle: json['designtitle']);
  }
}
