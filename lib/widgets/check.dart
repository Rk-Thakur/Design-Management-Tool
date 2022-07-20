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
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../main.dart';
import '../models/user.dart';

class check extends StatefulWidget {
  @override
  State<check> createState() => _checkState();
}

class _checkState extends State<check> {
  final uid = auth.FirebaseAuth.instance.currentUser!.uid;

  late User user;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
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
            key: _globalKey,
            drawer: drawer_widget(),
            body: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _globalKey.currentState!.openDrawer();
                                    });
                                  },
                                  child: Icon(
                                    Icons.menu,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                GradientText(
                                  'DMT',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                  ),
                                  colors: [
                                    Colors.blue,
                                    Colors.red,
                                    Colors.teal,
                                  ],
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: (() {
                                Get.to(() => messagepage(),
                                    transition: Transition.zoom);
                              }),
                              child: Icon(
                                Icons.message,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 198, 196, 196),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      height: 115,
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
                                  return Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 400,
                                        child: Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.to(
                                                    () => DetailPage(
                                                          post: dat,
                                                          user: user,
                                                        ),
                                                    transition:
                                                        Transition.leftToRight);
                                              },
                                              child: Container(
                                                height: 400,
                                                width: double.infinity,
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
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 15,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                dat.whose),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        'Name',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 98,
                                                  ),
                                                  Icon(
                                                    Icons.menu,
                                                    size: 20,
                                                    color: Colors.white,
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
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    Get.to(
                                                                        () => EditPage(
                                                                            dat),
                                                                        transition:
                                                                            Transition.leftToRight);
                                                                  },
                                                                  child: Icon(
                                                                      Icons
                                                                          .edit)),
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    await ref.read(crudProvider).postRemove(
                                                                        postId: dat
                                                                            .id,
                                                                        imageId:
                                                                            dat.imageId);
                                                                  },
                                                                  child: Icon(Icons
                                                                      .delete)),
                                                            ]);
                                                        // Get.to(() => EditPage(dat));
                                                      },
                                                      icon:
                                                          Icon(Icons.more_vert),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  width: 200,
                                                  height: 35,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            if (dat.likeData
                                                                    .like !=
                                                                0)
                                                              Text(
                                                                '${dat.likeData.like != 0}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            if (dat.userId !=
                                                                uid)
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (dat
                                                                        .likeData
                                                                        .usernames
                                                                        .contains(
                                                                            user.username)) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .hideCurrentMaterialBanner();
                                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                          duration: Duration(
                                                                              seconds:
                                                                                  1),
                                                                          content:
                                                                              Text("Already Liked!!")));
                                                                    } else {
                                                                      final likes = Like(
                                                                          like: dat.likeData.like +
                                                                              1,
                                                                          usernames: [
                                                                            ...dat.likeData.usernames,
                                                                            user.username
                                                                          ]);
                                                                      int sumlike = likes
                                                                          .like
                                                                          .bitLength;

                                                                      ref.read(crudProvider).addlike(
                                                                          likes,
                                                                          dat.id);
                                                                    }
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .thumb_up)),
                                                          ],
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              Get.to(
                                                                  () =>
                                                                      DetailPage(
                                                                        post:
                                                                            dat,
                                                                        user:
                                                                            user,
                                                                      ),
                                                                  transition:
                                                                      Transition
                                                                          .leftToRight);
                                                            },
                                                            icon: Icon(
                                                                Icons.comment)),
                                                        Icon(Icons.comment),
                                                      ],
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          134, 246, 244, 244),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
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
          ),
        );

        // drawer: DrawerWidget(),
      },
    );
  }
}
