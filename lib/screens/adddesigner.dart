import 'dart:io';

import 'package:firebase/providers/auth_provider.dart';
import 'package:firebase/providers/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../providers/login_provider.dart';

class adddesigner extends StatelessWidget {
  TextEditingController usernameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController positionController = TextEditingController();

  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Designer"),
          centerTitle: true,
          leading: Icon(Icons.design_services),
        ),
        body: SafeArea(
          child: Consumer(builder: (context, ref, child) {
            final db = ref.watch(imageProvider);
            final isLoading = ref.watch(loadingProvider);
            return SingleChildScrollView(
              child: Form(
                key: _form,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(hintText: 'Username'),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          ref.read(imageProvider).getImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            height: 140,
                            child: db.image == null
                                ? Center(
                                    child: Text('please select an image'),
                                  )
                                : Image.file(
                                    File(db.image!.path),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller: mailController,
                          decoration: InputDecoration(hintText: 'Email'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller: passController,
                          obscureText: true,
                          decoration: InputDecoration(hintText: 'Password'),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller: positionController,
                          decoration: InputDecoration(hintText: 'Position'),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            _form.currentState!.save();
                            ref.read(loadingProvider.notifier).toogle();
                            FocusScope.of(context).unfocus();

                            if (db.image == null) {
                              Get.defaultDialog(
                                  title: 'please provide an image',
                                  content: Text('image must be select'));
                            } else {
                              final response = ref
                                  .read(logSignProvider)
                                  .signUpdesigner(
                                    userName: usernameController.text.trim(),
                                    email: mailController.text.trim(),
                                    password: passController.text.trim(),
                                    image: db.image!,
                                    position: positionController.text.trim(),
                                  );
                              if (response == 'adduser') {
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ));
  }
}
