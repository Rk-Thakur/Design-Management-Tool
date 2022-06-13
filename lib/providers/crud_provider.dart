import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerdesign/models/allocatedesigner.dart';
import 'package:customerdesign/models/comment.dart';
import 'package:customerdesign/models/design.dart';
import 'package:customerdesign/models/designer.dart';
import 'package:customerdesign/models/post.dart';
import 'package:customerdesign/models/user.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

final crudProvider = Provider.autoDispose((ref) => CrudProvider());

final postProvider =
    StreamProvider.autoDispose((ref) => CrudProvider().getData());

final userProvider =
    StreamProvider.autoDispose((ref) => CrudProvider().geUserData());

final allocateProvider =
    StreamProvider.autoDispose((ref) => CrudProvider().getallocate());

class CrudProvider {
  CollectionReference dbPosts = FirebaseFirestore.instance.collection('posts');

  CollectionReference dbCustomer =
      FirebaseFirestore.instance.collection('customers');
  CollectionReference dballacoteddesigner =
      FirebaseFirestore.instance.collection('allocateddesigner');

  CollectionReference dbUsers = FirebaseFirestore.instance.collection('users');

  Stream<List<Post>> getData() {
    return dbPosts.snapshots().map((event) => getPostsData(event));
  }

  List<Post> getPostsData(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      final json = e.data() as Map<String, dynamic>;
      return Post(
          imageId: json['imageId'] ?? 'not available',
          id: e.id,
          userId: json['userId'] ?? 'not noll',
          description: json['description'] ?? 'noot null',
          title: json['title'] ?? 'notnull',
          userImage: json['imageUrl'] ?? 'not nuyll',
          likeData: Like.fromJson(json['likes']),
          comments: (json['comments'] as List)
              .map((e) => Comments.fromJson(e as Map<String, dynamic>))
              .toList());
    }).toList();
  }

  Stream<List<User>> geUserData() {
    return dbUsers.snapshots().map((event) => UserData(event));
  }

  List<User> UserData(QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .map((e) => User.fromJson((e.data() as Map<String, dynamic>)))
        .toList();
  }

  Stream<List<allocatedesignermodel>> getallocate() {
    return dballacoteddesigner
        .snapshots()
        .map((event) => getdesignerallocation(event));
  }

  List<allocatedesignermodel> getdesignerallocation(
      QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      final json = e.data() as Map<String, dynamic>;
      return allocatedesignermodel(
          designDescription: json['designDescription'],
          designername: json['designername'],
          customerId: json['customerId']);
    }).toList();
  }

  Stream<Customer> getSingleUser() {
    final uid = auth.FirebaseAuth.instance.currentUser!.uid;
    final users = dbCustomer.where('customerId', isEqualTo: uid).snapshots();
    return users.map((event) => singleUser(event));
  }

  Customer singleUser(QuerySnapshot querySnapshot) {
    return Customer.fromJson(
        querySnapshot.docs[0].data() as Map<String, dynamic>);
  }

  Stream<List<Customer>> getCustomerData() {
    return dbCustomer.snapshots().map((event) => CustomerData(event));
  }

  List<Customer> CustomerData(QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .map((e) => Customer.fromJson((e.data() as Map<String, dynamic>)))
        .toList();
  }

  Future<void> addlike(Like like, String postId) async {
    try {
      final response = await dbPosts.doc(postId).update({
        'likes': like.toJson(),
      });
    } on FirebaseException catch (e) {}
  }

  Future<void> addComment(List<Comments> comment, String postId) async {
    try {
      final response = await dbPosts.doc(postId).update({
        'comments': comment.map((e) => e.toJson()).toList(),
      });
    } on FirebaseException catch (e) {}
  }
}

final userStream =
    StreamProvider.autoDispose(((ref) => CrudProvider().getSingleUser()));
