import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerdesign/models/comment.dart';
import 'package:customerdesign/models/designer.dart';
import 'package:customerdesign/models/post.dart';
import 'package:customerdesign/providers/crud_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

class DetailPage extends StatelessWidget {
  final commentController = TextEditingController();
  final Post post;
  final Customer user;
  final _form = GlobalKey<FormState>();
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
              return ListView(
                children: [
                  Container(
                      height: 200,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        placeholder: (context, url) {
                          return CircularProgressIndicator();
                        },
                        imageUrl: post.userImage,
                      )),
                  Column(
                    children: [
                      Text(
                        post.title,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Hurricane',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post.description,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Hurricane',
                            fontWeight: FontWeight.bold),
                      ),
                      Column(
                        children: [
                          TextFormField(
                            controller: commentController,
                            maxLines: 4,
                            decoration: InputDecoration(
                                hintText: 'Add some comments',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                onPressed: () async {
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  final newComment = Comments(
                                      imageUrl: user.customerImage,
                                      username: user.cusomtername,
                                      comment: commentController.text.trim());

                                  post.comments.add(newComment);
                                  await ref
                                      .read(crudProvider)
                                      .addComment(post.comments, post.id);
                                  commentController.clear();
                                },
                                child: Text("submit")),
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
                                                leading:
                                                    Image.network(e.imageUrl),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
