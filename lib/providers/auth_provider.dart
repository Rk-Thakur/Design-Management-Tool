import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final authProvider = StreamProvider.autoDispose(
    (ref) => FirebaseAuth.instance.authStateChanges());

final logSignProvider = Provider.autoDispose((ref) => LoginSignUpProvider());

class LoginSignUpProvider {
  CollectionReference dbUser = FirebaseFirestore.instance.collection('users');

  Future<String> signUp(
      {required String email,
      required String password,
      required String userName,
      required XFile image}) async {
    try {
      final imageFile = File(image.path);
      final imageId = DateTime.now().toString();
      final ref = FirebaseStorage.instance.ref().child('userImage/$imageId');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      final responseUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await dbUser.add({
        'username': userName,
        'email': email,
        'userImage': url,
        'userId': responseUser.user!.uid
      });

      return 'success';
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  Future<String> signUpdesigner(
      {required String email,
      required String password,
      required String userName,
      required XFile image,
      required String position}) async {
    try {
      final imageFile = File(image.path);
      final imageId = DateTime.now().toString();
      final ref =
          FirebaseStorage.instance.ref().child('designerImage/$imageId');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      final responseUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await dbUser.add({
        'username': userName,
        'email': email,
        'userImage': url,
        'userId': responseUser.user!.uid,
        'position': position
      });

      return 'adduser';
    } on FirebaseException catch (err) {
      print(err);
      return '${err.message}';
    }
  }

  Future<String> Login(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } on FirebaseException catch (err) {
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
}
