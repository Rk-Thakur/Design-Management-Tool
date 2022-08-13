import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase/models/post.dart';
import 'package:firebase/providers/crud_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../models/user.dart';

class details_screen extends StatelessWidget {
  late User user;
  late String name;
  late String clickedid;
  details_screen({
    required this.user,
    required this.name,
    required this.clickedid,
  });
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 210,
                decoration: BoxDecoration(
                  color: Color(0xffE5E3C9),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Consumer(builder: (context, ref, child) {
                              final postStream = ref.watch(postProvider);
                              return postStream.when(
                                  data: (data) {
                                    return Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 45.0,
                                          child: ClipOval(
                                            child: Image.network(
                                              user.userImage,
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          user.username,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    );
                                  },
                                  error: (err, stack) => Text('$err'),
                                  loading: () => Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.purple,
                                        ),
                                      ));
                            }),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    user.email,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    user.position,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
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
                                                CachedNetworkImage(
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
                                                SizedBox(
                                                  height: 50,
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                });
                            // return SingleChildScrollView(
                            //   child: Column(
                            //     children: [
                            //       GridView.builder(
                            //         itemCount: data.length,
                            //         gridDelegate:
                            //             SliverGridDelegateWithFixedCrossAxisCount(
                            //                 crossAxisCount: 3,
                            //                 crossAxisSpacing: 16,
                            //                 mainAxisSpacing: 16),
                            //         physics: ClampingScrollPhysics(),
                            //         scrollDirection: Axis.vertical,
                            //         itemBuilder: (context, index) {
                            //           final dat = data[index];
                            //           return Container(
                            //               height: 200,
                            //               width: double.infinity,
                            //               child: ClipRRect(
                            //                 borderRadius:
                            //                     BorderRadius.circular(10),
                            //                 child: CachedNetworkImage(
                            //                   placeholder: (context, String) {
                            //                     return Center(
                            //                       child:
                            //                           CircularProgressIndicator(
                            //                         color: Colors.pink,
                            //                       ),
                            //                     );
                            //                   },
                            //                   imageUrl: dat.userImage,
                            //                   fit: BoxFit.fill,
                            //                 ),
                            //               ));
                            //         },
                            //       ),
                            //     ],
                            //   ),
                            // );
                          },
                          error: (err, stack) => Text("$err"),
                          loading: () => Text('wait'));
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
