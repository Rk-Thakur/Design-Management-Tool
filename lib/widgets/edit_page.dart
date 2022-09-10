import 'dart:io';
import 'package:firebase/models/post.dart';
import 'package:firebase/providers/crud_provider.dart';
import 'package:firebase/providers/image_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class EditPage extends StatelessWidget {
  final Post post;
  EditPage(this.post);

  final titleController = TextEditingController();
  final detailController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer(builder: (context, ref, child) {
      final image = ref.watch(imageProvider).image;
      return SafeArea(
        child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    GradientText(
                      'Edit  Post',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.blueGrey),
                      colors: [
                        const Color(0xffE5E3C9),
                        const Color(0xffB4CFB0),
                        const Color(0xff94B49F),
                        const Color(0xff789395),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        ref.read(imageProvider).getImage();
                      },
                      child: Container(
                          height: 350,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black)),
                          child: image == null
                              ? Container(
                                  height: 350,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      post.userImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ))
                              : Image.file(
                                  File(image.path),
                                  fit: BoxFit.cover,
                                )),
                    ),
                    SizedBox(
                      height: 20,
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
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 239, 235, 234),
                                width: 2.0),
                          ),
                          labelText: 'TITLE',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          hintText: 'TITLE'),
                    ),
                    SizedBox(
                      height: 20,
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
                      maxLines: 10,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      controller: detailController..text = post.description,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 239, 235, 234),
                                width: 2.0),
                          ),
                          labelText: 'DESCRIPTION',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          hintText: 'DESCRIPTION'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xffB4CFB0))),
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
                                      description: detailController.text.trim(),
                                      postId: post.id,
                                      image: null);
                            } else {
                              final response = await ref
                                  .read(crudProvider)
                                  .postUpdate(
                                      title: titleController.text.trim(),
                                      description: detailController.text.trim(),
                                      postId: post.id,
                                      image: image,
                                      imageId: post.imageId);
                              if (response == 'success') {
                                Navigator.of(context).pop();
                              }
                            }
                          }
                        },
                        child: Text(
                          'Edit Post',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )),
                  ],
                ),
              ),
            )),
      );
    }));
  }
}
