import 'dart:io';
import 'package:firebase/providers/crud_provider.dart';
import 'package:firebase/providers/image_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class CreatePage extends StatelessWidget {
  final titleController = TextEditingController();
  final detailController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer(builder: (context, ref, child) {
      final image = ref.watch(imageProvider).image;
      final user = ref.watch(userStream);
      return SafeArea(
          child: user.when(
              data: (data) {
                return Form(
                    key: _form,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            GradientText(
                              'Create Post',
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
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: TextFormField(
                                controller: titleController,
                                textCapitalization:
                                    TextCapitalization.sentences,
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
                                          color: Color.fromARGB(
                                              255, 239, 235, 234),
                                          width: 2.0),
                                    ),
                                    labelText: 'TITLE',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    hintText: 'TITLE'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: TextFormField(
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
                                controller: detailController,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 239, 235, 234),
                                          width: 2.0),
                                    ),
                                    labelText: 'DESCRIPTION',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    hintText: 'DESCRIPTION'),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: InkWell(
                                onTap: () {
                                  ref.read(imageProvider).getImage();
                                },
                                child: Container(
                                    height: 350,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: image == null
                                        ? Center(child: Text('Select an image'))
                                        : Image.file(
                                            File(image.path),
                                            fit: BoxFit.cover,
                                          )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color(0xffB4CFB0))),
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
                                                title:
                                                    titleController.text.trim(),
                                                description: detailController
                                                    .text
                                                    .trim(),
                                                image: image,
                                                whose_image: data.userImage,
                                                whose_name: data.username,
                                                userId: uid);
                                        AwesomeNotifications()
                                            .createNotification(
                                          content: NotificationContent(
                                            id: 1,
                                            channelKey: 'post',
                                            title:
                                                titleController.text.toString(),
                                            body: detailController.text
                                                .toString(),
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
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ));
              },
              error: (err, stack) => Text("$err"),
              loading: () => Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffB4CFB0),
                    ),
                  )));
    }));
  }
}
