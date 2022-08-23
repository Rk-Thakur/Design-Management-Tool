import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerdesign/models/design.dart';
import 'package:customerdesign/models/user.dart';
import 'package:customerdesign/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

final authProvider = StreamProvider.autoDispose(
    (ref) => FirebaseAuth.instance.authStateChanges());

final designProvider = StreamProvider.autoDispose(
    (ref) => LoginSignUpProvider().getCustomerDesignDetails());

final logSignProvider = Provider.autoDispose((ref) => LoginSignUpProvider());

final customerProvider = StreamProvider.autoDispose(
    (ref) => LoginSignUpProvider().getCustomerData());

class LoginSignUpProvider {
  CollectionReference dbCustomer =
      FirebaseFirestore.instance.collection('customers');
  CollectionReference dbCustomerDesign =
      FirebaseFirestore.instance.collection('customersdesigndescription');

  Stream<List<Customer>> getCustomerData() {
    return dbCustomer.snapshots().map((event) => CustomerData(event));
  }

  List<Customer> CustomerData(QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .map((e) => Customer.fromJson((e.data() as Map<String, dynamic>)))
        .toList();
  }

  Future<String> signUp(
      {required String email,
      required String password,
      required String customerName,
      required XFile image}) async {
    try {
      final imageFile = File(image.path);
      final imageId = DateTime.now().toString();
      final ref = FirebaseStorage.instance.ref().child('userImage/$imageId');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      final responseUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await dbCustomer.add({
        'customername': customerName,
        'customeremail': email,
        'customerImage': url,
        'customerId': responseUser.user!.uid
      });

      return 'success';
    } on FirebaseException catch (err) {
      print('orchid');
      return '';
    }
  }

  Future<String> Login(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } on FirebaseException catch (err) {
      // print('no login');
      return '${err.message}';
    }
  }

  Future<String> LogOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return 'success';
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  Future<void> ResetPassword(String email) async {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    Get.showSnackbar(GetSnackBar(
      title: 'Link sent to your link',
      duration: Duration(seconds: 3),
      message: 'Please check the mail',
    ));
    // Get.to(AuthScreen());
  }

  Future<String> updatedesignDescription({
    required String? description,
    required int? price,
    required String designId,
    required String? username,
  }) async {
    try {
      await dbCustomerDesign.doc(designId).update({
        'designDescription': description,
        'price': price,
      });
      return 'success';
    } on FirebaseException catch (e) {
      return '${e.message}';
    }
  }

  Stream<List<design_details>> getCustomerDesignDetails() {
    return dbCustomerDesign.snapshots().map((event) => getDesignDetails(event));
  }

  List<design_details> getDesignDetails(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      final json = e.data() as Map<String, dynamic>;
      return design_details(
        id: e.id,
        designDescription: json['designDescription'] ?? 'not null',
        price: json['price'] ?? 'not price',
        username: json['username'] ?? 'not null',
        userImage: json['userImage'] ?? 'not null',
        userId: json['userId'] ?? 'not null',
        designId: json['designId'] ?? 'not null',
        designtitle: json['designtitle'] ?? 'not null',
      );
    }).toList();
  }

  Future<String> addDesignDescrption({
    required String username,
    required String designdescription,
    required int price,
    required String userId,
    required String userImage,
    required String title,
  }) async {
    try {
      final designId = DateTime.now().toString();
      await dbCustomerDesign.add({
        'username': username,
        'designDescription': designdescription,
        'price': price,
        'userId': userId,
        'userImage': userImage,
        'designId': designId,
        'designtitle': title
      });
      return 'success';
    } on FirebaseException catch (e) {
      return '${e}' + "oorchid";
    }
  }

  Future<String> removedescription({required String postId}) async {
    try {
      await dbCustomerDesign.doc(postId).delete();
      return 'success';
    } on FirebaseException catch (e) {
      return "${e.message}";
    }
  }
}
