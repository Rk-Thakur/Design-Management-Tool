import 'dart:io';

import 'package:firebase/providers/auth_provider.dart';
import 'package:firebase/providers/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../providers/login_provider.dart';

class adddesigner extends StatelessWidget {
  TextEditingController usernameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController positionController = TextEditingController();

  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Consumer(builder: (context, ref, child) {
        final db = ref.watch(imageProvider);
        final isLoading = ref.watch(loadingProvider);
        return SingleChildScrollView(
          child: Form(
            key: _form,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  GradientText(
                    'Add Designer',
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
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 239, 235, 234),
                                  width: 2.0)),
                          labelText: 'Username',
                          hintText: 'Enter Full Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ref.read(imageProvider).getImage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                        ),
                        height: 190,
                        child: db.image == null
                            ? Center(
                                child: Text('please select an image'),
                              )
                            : Image.file(
                                File(db.image!.path),
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: mailController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 239, 235, 234),
                                  width: 2.0)),
                          labelText: 'Email',
                          hintText: 'Enter Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: passController,
                      obscureText: true,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 239, 235, 234),
                                  width: 2.0)),
                          labelText: 'Password',
                          hintText: 'Enter Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: positionController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 239, 235, 234),
                                  width: 2.0)),
                          labelText: 'Position',
                          hintText: 'Position',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 45,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xffB4CFB0))),
                      onPressed: () async {
                        _form.currentState!.save();
                        ref.read(loadingProvider.notifier).toogle();
                        FocusScope.of(context).unfocus();

                        if (db.image == null) {
                          Get.defaultDialog(
                              title: 'please provide an image',
                              content: Text('image must be select'));
                        } else {
                          final response =
                              ref.read(logSignProvider).signUpdesigner(
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
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
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
