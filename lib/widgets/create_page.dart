import 'dart:io';
import 'package:firebase/providers/crud_provider.dart';
import 'package:firebase/providers/image_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:image_picker/image_picker.dart';

class CreatePage extends StatelessWidget {
  final titleController = TextEditingController();
  final detailController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('create page'),
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
                        TextFormField(
                          controller: titleController,
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
                          controller: detailController,
                          decoration: InputDecoration(hintText: 'description'),
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
                                  ? Center(child: Text('select an image'))
                                  : Image.file(
                                      File(image.path),
                                      fit: BoxFit.cover,
                                    )),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              _form.currentState!.save();
                              FocusScope.of(context).unfocus();
                              if (_form.currentState!.validate()) {
                                if (image == null) {
                                  Get.dialog(AlertDialog(
                                    title: Text('please select an image'),
                                    actions: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.close),
                                      )
                                    ],
                                  ));
                                } else {
                                  final response = await ref
                                      .read(crudProvider)
                                      .postAdd(
                                          title: titleController.text.trim(),
                                          description:
                                              detailController.text.trim(),
                                          image: image,
                                          userId: uid);
                                  AwesomeNotifications().createNotification(
                                    content: NotificationContent(
                                      id: 1,
                                      channelKey: 'post',
                                      title: titleController.text.toString(),
                                      body: detailController.text.toString(),
                                      roundedBigPicture: true,
                                    ),
                                  );
                                  if (response == 'success') {
                                    Navigator.of(context).pop();
                                    // Notify(
                                    //     // title: titleController.text.trim(),
                                    //     // description:
                                    //     //     detailController.text.trim(),
                                    //     // image: image
                                    //     );
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
