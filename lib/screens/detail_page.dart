import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase/models/comment.dart';
import 'package:firebase/models/post.dart';
import 'package:firebase/providers/crud_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../models/user.dart';

class DetailPage extends StatelessWidget {
  final commentController = TextEditingController();
  final Post post;
  final User user;
  final _form = GlobalKey<FormState>();
  final uid = auth.FirebaseAuth.instance.currentUser!.uid;

  DetailPage({required this.post, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _form,
          child: Consumer(
            builder: (context, ref, child) {
              final posts = ref.watch(postProvider);
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: [
                    Card(
                      elevation: 10,
                      child: Container(
                        height: 500,
                        width: double.infinity,
                        // child: CachedNetworkImage(
                        //   fit: BoxFit.fill,
                        //   width: double.infinity,
                        //   height: 600,
                        //   placeholder: (context, url) {
                        //     return CircularProgressIndicator();
                        //   },
                        //   imageUrl: post.userImage,
                        // ),
                        child: GFImageOverlay(
                          height: 600,
                          width: double.infinity,
                          image: NetworkImage(post.userImage),
                          colorFilter: new ColorFilter.mode(
                              Color.fromARGB(255, 247, 245, 245)
                                  .withOpacity(0.3),
                              BlendMode.darken),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Title",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            post.title,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Hurricane',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Description",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            post.description,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Hurricane',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            TextFormField(
                              controller: commentController,
                              maxLines: 4,
                              keyboardType: TextInputType.multiline,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Comments Please!!!!';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 239, 235, 234),
                                      width: 2.0),
                                ),
                                labelText: 'Add Comments',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  color: Color(0xffB4CFB0),
                                  onPressed: () async {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    if (_form.currentState!.validate()) {
                                      final newComment = Comments(
                                          imageUrl: user.userImage,
                                          username: user.username,
                                          comment:
                                              commentController.text.trim());

                                      post.comments.add(newComment);
                                      await ref
                                          .read(crudProvider)
                                          .addComment(post.comments, post.id);
                                      commentController.clear();
                                    }
                                  },
                                  icon: Icon(Icons.message)),
                            ),
                            posts.when(
                                data: (data) {
                                  return ListView(
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      children: post.comments
                                          .map((e) => Card(
                                                child: ListTile(
                                                  title: Text(e.comment),
                                                  subtitle: Text(e.username),
                                                  leading: CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            e.imageUrl),
                                                  ),
                                                ),
                                              ))
                                          .toList());
                                },
                                error: (err, stack) => Text("$err"),
                                loading: () => Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.purple,
                                      ),
                                    )),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
