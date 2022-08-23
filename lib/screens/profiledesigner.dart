import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerdesign/models/post.dart';
import 'package:customerdesign/models/user.dart';
import 'package:customerdesign/providers/crud_provider.dart';
import 'package:customerdesign/screens/detail_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class designerScreen extends StatelessWidget {
  final uid = auth.FirebaseAuth.instance.currentUser!.uid;
  late Customer cus;
  late String clickedid;
  designerScreen({required this.cus, required this.clickedid});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile Post"),
          centerTitle: true,
          backgroundColor: Color(0xffB4CFB0),
        ),
        // drawer: drawer_widget(),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
                child: Container(
              width: MediaQuery.of(context).size.width,
              child: Consumer(
                builder: (context, ref, child) {
                  final postStream = ref.watch(postProvider);
                  return postStream.when(
                      data: (data) {
                        return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final dat = data[index];
                              return Card(
                                child: Column(
                                  children: [
                                    if (clickedid == dat.userId)
                                      Container(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  dat.title,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Get.to(() => DetailPage(
                                                      post: dat, user: cus));
                                                },
                                                onLongPress: () {
                                                  Get.defaultDialog(
                                                      title: "Download Post??",
                                                      content: Text(
                                                          "Click on Download !!!!"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Icon(
                                                                Icons.cancel)),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              ref
                                                                  .watch(
                                                                      crudProvider)
                                                                  .Download(
                                                                      dat.userImage,
                                                                      dat.title);

                                                              GFToast.showToast(
                                                                '${dat.title} has been Downloaded to Download Folder ✌🏻',
                                                                context,
                                                                toastPosition:
                                                                    GFToastPosition
                                                                        .BOTTOM,
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color:
                                                                      GFColors
                                                                          .DARK,
                                                                ),
                                                                backgroundColor:
                                                                    GFColors
                                                                        .LIGHT,
                                                              );

                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Icon(Icons
                                                                .download)),
                                                      ]);
                                                },
                                                child: CachedNetworkImage(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 500,
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
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '',
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
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // if (dat.userId != uid) //check this one
                                                      IconButton(
                                                          onPressed: () {
                                                            if (dat.likeData
                                                                .usernames
                                                                .contains(cus
                                                                    .cusomtername)) {
                                                              GFToast.showToast(
                                                                'Thanks for Response ✌🏻',
                                                                context,
                                                                toastPosition:
                                                                    GFToastPosition
                                                                        .BOTTOM,
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color:
                                                                      GFColors
                                                                          .DARK,
                                                                ),
                                                                backgroundColor:
                                                                    GFColors
                                                                        .LIGHT,
                                                              );
                                                            } else {
                                                              final likes = Like(
                                                                  like: dat
                                                                          .likeData
                                                                          .like +
                                                                      1,
                                                                  usernames: [
                                                                    ...dat
                                                                        .likeData
                                                                        .usernames,
                                                                    cus.cusomtername
                                                                  ]);
                                                              int sumlike = likes
                                                                  .like
                                                                  .bitLength;

                                                              ref
                                                                  .read(
                                                                      crudProvider)
                                                                  .addlike(
                                                                      likes,
                                                                      dat.id);
                                                            }
                                                          },
                                                          icon: Icon(
                                                            Icons.thumb_up,
                                                            color: Colors.black,
                                                          )),

                                                      Text(
                                                        "${dat.likeData.like}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
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
                                      ),
                                  ],
                                ),
                              );
                            });

                        // return GridView.builder(
                        //     gridDelegate:
                        //         SliverGridDelegateWithFixedCrossAxisCount(
                        //             crossAxisCount: 2, mainAxisSpacing: 4),
                        //     itemCount: data.length,
                        //     itemBuilder: (context, index) {
                        //       final dat = data[index];
                        //       return Card(
                        //         child: Container(
                        //           height: 100,
                        //           width: 100,
                        //           child: Column(
                        //             children: [
                        //               if (clickedid == dat.userId)
                        //                 CachedNetworkImage(
                        //                   width: 100,
                        //                   height: 100,
                        //                   placeholder: (context, String) {
                        //                     return Center(
                        //                       child: CircularProgressIndicator(
                        //                         color: Colors.pink,
                        //                       ),
                        //                     );
                        //                   },
                        //                   imageUrl: dat.userImage,
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     });
                      },
                      error: (err, stack) => Text("$err"),
                      loading: () => Text('wait'));
                },
              ),
            ))
          ],
        )),
      ),
    );
  }
}
