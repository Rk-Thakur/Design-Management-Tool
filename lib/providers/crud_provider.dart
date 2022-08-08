import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase/models/allocatedesigner.dart';
import 'package:firebase/models/comment.dart';
import 'package:firebase/models/customer.dart';
import 'package:firebase/models/design.dart';
import 'package:firebase/models/messag.dart';
import 'package:firebase/models/post.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:path_provider/path_provider.dart';

final crudProvider = Provider.autoDispose((ref) => CrudProvider());
final postProvider =
    StreamProvider.autoDispose((ref) => CrudProvider().getData());

final allocateProvider =
    StreamProvider.autoDispose((ref) => CrudProvider().getallocate());

final designProvider = StreamProvider.autoDispose(
    (ref) => CrudProvider().getCustomerDesignDetails());

final chatProvider =
    StreamProvider.autoDispose((ref) => CrudProvider().getMessage());

final userProvider =
    StreamProvider.autoDispose((ref) => CrudProvider().geUserData());

final customerProvider =
    StreamProvider.autoDispose((ref) => CrudProvider().getCustomerData());

class CrudProvider {
  CollectionReference dbPosts = FirebaseFirestore.instance.collection('posts');
  CollectionReference dbUsers = FirebaseFirestore.instance.collection('users');
  CollectionReference dbChats = FirebaseFirestore.instance.collection('chats');
  CollectionReference dbCustomer =
      FirebaseFirestore.instance.collection('customers');
  CollectionReference dbCustomerDesign =
      FirebaseFirestore.instance.collection('customersdesigndescription');
  CollectionReference dballacoteddesigner =
      FirebaseFirestore.instance.collection('allocateddesigner');

  Future<String> allocateDesigner(
      {required String designtitle,
      required String designername,
      required String customerId
      // required String designerId
      }) async {
    try {
      await dballacoteddesigner.add({
        'designtitle': designtitle,
        'designername': designername,
        'customerId': customerId
        // 'designerId': designerId
      });
      return 'success';
    } on FirebaseException catch (e) {
      return '${e.message}';
    }
  }

  Future<String> messageAdd(
      {required String message,
      required String userId,
      // required String username,
      required String imageUrl,
      required String username}) async {
    try {
      await dbChats.add({
        'message': message,
        'createdAt': Timestamp.now(),
        'userId': userId,
        'username': username,
        'imageUrl': imageUrl
      });
      return 'success';
    } on FirebaseException catch (e) {
      return '${e.message}';
    }
  }

  Future<String> postAdd(
      {required String title,
      required String description,
      required XFile image,
      required String whose_image,
      required String whose_name,
      required String userId}) async {
    try {
      final imageId = DateTime.now().toString();
      final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
      final imageFile = File(image.path);
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();

      await dbPosts.add({
        'title': title,
        'imageUrl': url,
        'description': description,
        'userId': userId,
        'whose_image': whose_image,
        'imageId': imageId,
        'whose_name': whose_name,
        'likes': {
          'like': 0,
          'usernames': [],
        },
        'comments': []
      });
      return 'success';
    } on FirebaseException catch (err) {
      return '${err.message}';
    }
  }

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
          whose: json['whose_image'] ?? 'not null',
          whosename: json['whose_name'] ?? 'not null',
          userImage: json['imageUrl'] ?? 'not nuyll',
          likeData: Like.fromJson(json['likes']),
          comments: (json['comments'] as List)
              .map((e) => Comments.fromJson(e as Map<String, dynamic>))
              .toList());
    }).toList();
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
          designtitle: json['designtitle'], designername: json['designername']);
    }).toList();
  }

  Stream<List<design_details>> getCustomerDesignDetails() {
    return dbCustomerDesign.snapshots().map((event) => getDesignDetails(event));
  }

  List<design_details> getDesignDetails(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      final json = e.data() as Map<String, dynamic>;
      return design_details(
          designDescription: json['designDescription'] ?? 'not null',
          price: json['price'] ?? 'not price',
          username: json['username'] ?? 'not null',
          userImage: json['userImage'] ?? 'not null',
          userId: json['userId'] ?? 'not null',
          designtitle: json['designtitle'] ?? 'not null');
    }).toList();
  }

  Stream<List<message>> getMessage() {
    return dbChats
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => getMessageData(event));
  }

  List<message> getMessageData(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      final json = e.data() as Map<String, dynamic>;
      return message(
        text: json['message'] ?? 'skdjf',
        username: json['username'] ?? 'ksadjfkl',
        imageUrl: json['imageUrl'] ?? 'kasjdf',
        userId: json['userId'] ?? 'ksdfa',
      );
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

  Stream<List<Customer>> getCustomerData() {
    return dbCustomer.snapshots().map((event) => CustomerData(event));
  }

  List<Customer> CustomerData(QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .map((e) => Customer.fromJson((e.data() as Map<String, dynamic>)))
        .toList();
  }

  Future<String> postUpdate(
      {required String title,
      required String description,
      XFile? image,
      required String postId,
      String? imageId}) async {
    try {
      if (image == null) {
        await dbPosts.doc(postId).update({
          'title': title,
          'description': description,
        });
      } else {
        final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
        await ref.delete();
        final imageFile = File(image.path);
        final newImageId = DateTime.now().toString();
        final ref1 = FirebaseStorage.instance.ref().child('postImage/$imageId');
        await ref1.putFile(imageFile);
        final url = await ref.getDownloadURL();

        await dbPosts.doc(postId).update({
          'title': title,
          'imageUrl': url,
          'description': description,
          'imageId': imageId
        });
      }
      return 'success';
    } on FirebaseException catch (err) {
      return '${err.message}';
    }
  }

  Future<String> postRemove(
      {required String postId, required String imageId}) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
      await ref.delete();
      await dbPosts.doc(postId).delete();
      return 'sucess';
    } on FirebaseException catch (e) {
      return '${e.message}';
    }
  }

  Future Download(String url, String title) async {
    try {
      //new Approach
      var id = await ImageDownloader.downloadImage(url);
      if (id != null) {
        print('Image is saved ${id}');
      }
      return 'success';
    } catch (e) {
      print(e);
    }
  }

  Stream<User> getSingleUser() {
    final uid = auth.FirebaseAuth.instance.currentUser!.uid;
    final users = dbUsers.where('userId', isEqualTo: uid).snapshots();
    return users.map((event) => singleUser(event));
  }

  User singleUser(QuerySnapshot querySnapshot) {
    return User.fromJson(querySnapshot.docs[0].data() as Map<String, dynamic>);
  }

  Stream<Post> getSingleUserPost() {
    final uid = auth.FirebaseAuth.instance.currentUser!.uid;
    final users = dbPosts.where('userId', isEqualTo: uid).snapshots();
    return users.map((event) => getUserPost(event));
  }

  Post getUserPost(QuerySnapshot querySnapshot) {
    final data = querySnapshot.docs[0].data() as Map<String, dynamic>;
    return Post(
        description: data['description'],
        title: data['title'],
        userImage: data['userImage'],
        userId: data['userId'],
        whose: data['whose_image'],
        whosename: data['whose_name'],
        imageId: data['imageId'],
        id: querySnapshot.docs[0].id,
        likeData: data['likedata'],
        comments: data['comments']);
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
