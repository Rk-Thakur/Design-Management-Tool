import 'dart:io';

import 'package:firebase/providers/auth_provider.dart';
import 'package:firebase/providers/image_provider.dart';
import 'package:firebase/providers/login_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class AuthScreen extends StatelessWidget {
  final userNameController = TextEditingController();
  final mailController = TextEditingController();
  final passController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Consumer(builder: (context, ref, child) {
        final isLogin = ref.watch(loginProvider);
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
                  Image.asset(
                    "assets/images/login.png",
                    height: 300,
                    width: double.infinity,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: GradientText(
                        'DMT',
                        gradientType: GradientType.linear,
                        style: TextStyle(
                          fontSize: 40,
                          letterSpacing: 3,
                        ),
                        colors: [
                          Colors.blue,
                          Colors.red,
                          Colors.teal,
                          Colors.amber
                        ],
                      )),
                  SizedBox(
                    height: 25,
                  ),
                  if (!isLogin)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: userNameController,
                        decoration: InputDecoration(hintText: 'Username'),
                      ),
                    ),
                  if (!isLogin)
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email Field is required";
                        }
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 239, 235, 234),
                              width: 2.0),
                        ),
                        labelText: "Email",
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: HexColor("#2396B2"),
                        ),
                      ),
                      // decoration: InputDecoration(hintText: 'Email'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: passController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password field is required';
                        }
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 239, 235, 234),
                              width: 2.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: HexColor("#2396B2"),
                        ),
                        labelText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: HexColor("#2396B2"),
                          ),
                        ),
                      ),
                      // decoration: InputDecoration(hintText: 'Password'),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      _form.currentState!.save();
                      ref.read(loadingProvider.notifier).toogle();
                      FocusScope.of(context).unfocus();
                      _form.currentState!.validate();
                      if (isLogin) {
                        final response = ref.read(logSignProvider).Login(
                            email: mailController.text.trim(),
                            password: passController.text.trim());

                        if (response != 'success') {
                          ref.read(loadingProvider.notifier).toogle();

                          // Get.showSnackbar(
                          //   GetSnackBar(
                          //     title: 'Got some error',
                          //     duration: Duration(seconds: 1),
                          //     message: 'Check the password',
                          //   ),
                          // );
                        }
                      } else {
                        if (db.image == null) {
                          Get.defaultDialog(
                              title: 'please provide an image',
                              content: Text('image must be select'));
                        } else {
                          ref.read(logSignProvider).signUp(
                              userName: userNameController.text.trim(),
                              email: mailController.text.trim(),
                              password: passController.text.trim(),
                              image: db.image!);
                        }
                      }
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.only(
                          top: 20, left: 40, right: 40, bottom: 10),
                      decoration: BoxDecoration(
                          color: HexColor("#2396B2"),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black26)),
                      width: double.infinity,
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Is Loading please wait',
                                  style: TextStyle(fontSize: 15),
                                ),
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ],
                            )
                          : Center(
                              child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
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
