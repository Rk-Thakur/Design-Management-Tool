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
                height: 220,
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
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      user.username,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      user.email,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
