import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerdesign/models/designer.dart';
import 'package:customerdesign/models/post.dart';
import 'package:customerdesign/models/user.dart';
import 'package:customerdesign/providers/crud_provider.dart';
import 'package:customerdesign/screens/detail_page.dart';
import 'package:customerdesign/screens/drawer_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

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
        ),
        drawer: drawer_widget(),
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
                                            Text(
                                              dat.title,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.to(() => DetailPage(
                                                    post: dat, user: cus));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onLongPress: () {
                                                    Get.defaultDialog(
                                                        title:
                                                            "Download Post??",
                                                        content: Text(
                                                            "Click on Download !!!!"),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Icon(Icons
                                                                  .cancel)),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                var tempDir =
                                                                    await getTemporaryDirectory();
                                                                String
                                                                    fullpath =
                                                                    tempDir.path +
                                                                        "/${dat.title}";
                                                                print('Full Path' +
                                                                    "${fullpath}");

                                                                ref
                                                                    .watch(
                                                                        crudProvider)
                                                                    .Download(
                                                                        Dio(),
                                                                        dat.userImage,
                                                                        fullpath);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Icon(Icons
                                                                  .download)),
                                                        ]);
                                                  },
                                                  child: CachedNetworkImage(
                                                    width:
                                                        MediaQuery.of(context)
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
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .hideCurrentMaterialBanner();
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(SnackBar(
                                                                      duration: Duration(
                                                                          seconds:
                                                                              1),
                                                                      content: Text(
                                                                          "already like thois post")));
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
