import 'dart:io';

import 'package:firebase/providers/auth_provider.dart';
import 'package:firebase/providers/image_provider.dart';
import 'package:firebase/providers/login_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

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
                      child: Text(
                        isLogin ? 'Login Form' : 'Sign Up Form',
                        style: TextStyle(fontSize: 25),
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
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Email",
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.mail,
                            color: HexColor("#2396B2"),
                          ),
                        ),
                      ),
                      // decoration: InputDecoration(hintText: 'Email'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
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
                  Container(
                    height: 60,
                    margin: EdgeInsets.only(
                        top: 20, left: 40, right: 40, bottom: 10),
                    width: double.infinity,
                    child: FlatButton(
                      color: HexColor("#2396B2"),
                      onPressed: () async {
                        _form.currentState!.save();
                        ref.read(loadingProvider.notifier).toogle();
                        FocusScope.of(context).unfocus();
                        if (isLogin) {
                          final response = ref.read(logSignProvider).Login(
                              email: mailController.text.trim(),
                              password: passController.text.trim());

                          if (response != 'success') {
                            ref.read(loadingProvider.notifier).toogle();

                            Get.showSnackbar(
                              GetSnackBar(
                                title: 'Got some error',
                                duration: Duration(seconds: 1),
                                message: 'Check the password',
                              ),
                            );
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
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Is Loading plese wait',
                                  style: TextStyle(fontSize: 15),
                                ),
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ],
                            )
                          : Text('Submit'),
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
