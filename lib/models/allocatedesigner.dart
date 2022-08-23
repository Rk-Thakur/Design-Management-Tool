class allocatedesignermodel {
  late String designername;
  late String designtitle;
  late String id;

  allocatedesignermodel(
      {required this.designtitle,
      required this.designername,
      required this.id});

  // factory allocatedesignermodel.fromJson(Map<String, dynamic> json) {
  //   return allocatedesignermodel(
  //     designDescription: json['designDescription'],
  //     designername: json['designername'],
  //   );
  // }
}
