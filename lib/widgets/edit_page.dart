import 'dart:io';
import 'package:firebase/models/post.dart';
import 'package:firebase/providers/crud_provider.dart';
import 'package:firebase/providers/image_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPage extends StatelessWidget {
  final Post post;
  EditPage(this.post);

  final titleController = TextEditingController();
  final detailController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit page'),
          backgroundColor: Colors.purple,
        ),
        body: Consumer(builder: (context, ref, child) {
          final image = ref.watch(imageProvider).image;
          return Form(
              key: _form,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Container(
                    height: 460,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Create Form',
                          style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 2,
                              color: Colors.blueGrey),
                        ),
                        InkWell(
                          onTap: () {
                            ref.read(imageProvider).getImage();
                          },
                          child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: image == null
                                  ? Image.network(post.userImage)
                                  : Image.file(
                                      File(image.path),
                                      fit: BoxFit.cover,
                                    )),
                        ),
                        TextFormField(
                          controller: titleController..text = post.title,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'title is required';
                            }
                            if (val.length > 40) {
                              return 'maximum title length is 40';
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: 'title'),
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'description is required';
                            }
                            if (val.length > 200) {
                              return 'maximum character length is 200';
                            }
                            return null;
                          },
                          controller: detailController..text = post.description,
                          decoration: InputDecoration(hintText: 'description'),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              _form.currentState!.save();
                              SystemChannels.textInput
                                  .invokeMapMethod('TextInput.hide');
                              if (_form.currentState!.validate()) {
                                if (image == null) {
                                  final response = await ref
                                      .read(crudProvider)
                                      .postUpdate(
                                          title: titleController.text.trim(),
                                          description:
                                              detailController.text.trim(),
                                          postId: post.id,
                                          image: null);
                                } else {
                                  final response = await ref
                                      .read(crudProvider)
                                      .postUpdate(
                                          title: titleController.text.trim(),
                                          description:
                                              detailController.text.trim(),
                                          postId: post.id,
                                          image: image,
                                          imageId: post.imageId);
                                  if (response == 'success') {
                                    Navigator.of(context).pop();
                                  }
                                }
                              }
                            },
                            child: Text('Submit')),
                      ],
                    ),
                  ),
                ),
              ));
        }));
  }
}
