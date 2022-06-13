import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/post.dart';
import 'package:firebase/providers/crud_provider.dart';
import 'package:firebase/screens/detail_page.dart';
import 'package:firebase/screens/details_screen.dart';
import 'package:firebase/screens/messagepage.dart';
import 'package:firebase/widgets/drawer_widget.dart';
import 'package:firebase/widgets/edit_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../models/user.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final uid = auth.FirebaseAuth.instance.currentUser!.uid;

  late User user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sumlike;
    return Consumer(
      builder: (context, ref, child) {
        final postStream = ref.watch(postProvider);
        final userStream = ref.watch(userProvider);
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purple,
              title: Text('Main Screen'),
              actions: [
                InkWell(
                  onTap: (() {
                    Get.to(() => messagepage(), transition: Transition.zoom);
                  }),
                  child: Icon(
                    Icons.message,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            drawer: drawer_widget(),
            body: Container(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 198, 196, 196),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    height: 125,
                    child: userStream.when(
                        data: (data) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: ((context, index) {
                                  user = data.firstWhere(
                                      (element) => element.userId == uid);
                                  final dat = data[index];
                                  return Container(
                                    decoration: BoxDecoration(),
                                    margin: EdgeInsets.only(right: 10),
                                    child: InkWell(
                                      onLongPress: (() {
                                        setState(() {
                                          if (user.userId ==
                                              "55xjWTFUjUVL3kBgOqCUL1u7eyr1") {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(dat.userId)
                                                .delete();
                                            print(dat.userId + "deleted");
                                          }
                                        });
                                      }),
                                      onTap: (() {
                                        Get.to(
                                            () => details_screen(
                                                  user: dat,
                                                  name: dat.username,
                                                  clickedid: dat.userId,
                                                ),
                                            transition: Transition.fade);
                                      }),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 33,
                                            backgroundImage:
                                                NetworkImage(dat.userImage),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            dat.username,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                          );
                        },
                        error: (err, stack) => Text("$err"),
                        loading: () => Center(
                              child: CircularProgressIndicator(
                                color: Colors.pink,
                              ),
                            )),
                  ),
                  Expanded(
                    child: Container(
                      child: postStream.when(
                          data: (data) {
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final dat = data[index];
                                return Card(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              dat.title,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (uid == dat.userId)
                                              IconButton(
                                                onPressed: () {
                                                  Get.defaultDialog(
                                                      title:
                                                          "Update Or Remove Post",
                                                      content: Text(
                                                          'Customize Post'),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Get.to(
                                                                  () =>
                                                                      EditPage(
                                                                          dat),
                                                                  transition:
                                                                      Transition
                                                                          .leftToRight);
                                                            },
                                                            child: Icon(
                                                                Icons.edit)),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              await ref
                                                                  .read(
                                                                      crudProvider)
                                                                  .postRemove(
                                                                      postId: dat
                                                                          .id,
                                                                      imageId: dat
                                                                          .imageId);
                                                            },
                                                            child: Icon(
                                                                Icons.delete)),
                                                      ]);
                                                  // Get.to(() => EditPage(dat));
                                                },
                                                icon: Icon(Icons.more_horiz),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Card(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 200,
                                                width: double.infinity,
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.to(
                                                        () => DetailPage(
                                                              post: dat,
                                                              user: user,
                                                            ),
                                                        transition: Transition
                                                            .leftToRight);
                                                  },
                                                  child: CachedNetworkImage(
                                                    placeholder:
                                                        (context, String) {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.pink,
                                                        ),
                                                      );
                                                    },
                                                    imageUrl: dat.userImage,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              dat.description,
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            width: 70,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                if (dat.userId != uid)
                                                  IconButton(
                                                      onPressed: () {
                                                        if (dat
                                                            .likeData.usernames
                                                            .contains(user
                                                                .username)) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .hideCurrentMaterialBanner();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(SnackBar(
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                  content: Text(
                                                                      "already like thois post")));
                                                        } else {
                                                          final likes = Like(
                                                              like: dat.likeData
                                                                      .like +
                                                                  1,
                                                              usernames: [
                                                                ...dat.likeData
                                                                    .usernames,
                                                                user.username
                                                              ]);
                                                          int sumlike = likes
                                                              .like.bitLength;

                                                          ref
                                                              .read(
                                                                  crudProvider)
                                                              .addlike(likes,
                                                                  dat.id);
                                                        }
                                                      },
                                                      icon:
                                                          Icon(Icons.thumb_up)),
                                                if (dat.likeData.like != 0)
                                                  Text("${dat.likeData.like}"),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          error: (err, stack) => Text("$err"),
                          loading: () => Container()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // drawer: DrawerWidget(),
      },
    );
  }
}
