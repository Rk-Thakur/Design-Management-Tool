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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 600,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 120,
                        width: double.infinity,
                        child: CircleAvatar(
                          radius: 20.0,
                          child: ClipOval(
                            child: Image.network(
                              user.userImage,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        color: Colors.red,
                        height: 300,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 70),
                                  child: Column(
                                    children: [
                                      Text(
                                        "20",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Posts",
                                        style: TextStyle(
                                            letterSpacing: 1.5,
                                            color: Color.fromARGB(
                                                255, 47, 45, 45)),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 70),
                                  child: Column(
                                    children: [
                                      Text(
                                        "20",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Likes",
                                        style: TextStyle(
                                            letterSpacing: 1.5,
                                            color: Color.fromARGB(
                                                255, 47, 45, 45)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    user.email,
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
              Container(
                height: 400,
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
                                              CachedNetworkImage(
                                                placeholder: (context, String) {
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
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              });
                        },
                        error: (err, stack) => Text("$err"),
                        loading: () => Text('wait'));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
