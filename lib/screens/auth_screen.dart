import 'dart:io';

import 'package:customerdesign/providers/login_provider.dart';
import 'package:customerdesign/screens/drawer_widget.dart';
import 'package:customerdesign/screens/forgetpassword.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../providers/auth_provider.dart';
import '../providers/image_provider.dart';

class AuthScreen extends StatelessWidget {
  final customerNameController = TextEditingController();
  final customermailController = TextEditingController();
  final customerpassController = TextEditingController();
  late final emailError;

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // backgroundColor: Color(0xffE9EFC0),
          drawer: drawer_widget(),
          body: Consumer(builder: (context, ref, child) {
            final isLogin = ref.watch(loginProvider);
            final db = ref.watch(imageProvider);
            final isLoading = ref.watch(loadingProvider);
            return SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _form,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        isLogin
                            ? 'assets/images/login.png'
                            : 'assets/images/signup.png',
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            isLogin ? 'Login ' : 'Sign Up Form',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff132a4d),
                            ),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      if (!isLogin)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            controller: customerNameController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 78, 206, 46),
                                      width: 2.0),
                                ),
                                labelText: "Username",
                                prefixIcon: Icon(
                                  FontAwesomeIcons.user,
                                  size: 15,
                                ),
                                hintText: 'Username',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
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
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: db.image == null
                                  ? Center(
                                      // child: Text('Please Select an image'),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.fileImage,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            "Please Select Image",
                                            style: TextStyle(
                                              fontSize: 15,
                                              height: 4,
                                              color: Colors.grey,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Image.file(
                                      File(db.image!.path),
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                          controller: customermailController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 78, 206, 46),
                                  width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: "Email",
                            prefixIcon: Icon(
                              FontAwesomeIcons.at,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is Required!!';
                            }
                            return null;
                          },
                          controller: customerpassController,
                          obscureText: true,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 78, 206, 46),
                                  width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: 'Password',
                            prefixIcon: Icon(
                              FontAwesomeIcons.lock,
                              size: 15,
                            ),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (isLogin)
                        InkWell(
                          onTap: () {
                            Get.to(() => forgetPassword());
                          },
                          child: Text(
                            'Forget Password?',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Color.fromARGB(255, 78, 206, 46),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xff83BD75))),
                            onPressed: () async {
                              _form.currentState!.save();
                              ref.read(loadingProvider.notifier).toogle();
                              FocusScope.of(context).unfocus();
                              _form.currentState!.validate();
                              if (isLogin) {
                                final response = ref
                                    .read(logSignProvider)
                                    .Login(
                                        email:
                                            customermailController.text.trim(),
                                        password:
                                            customerpassController.text.trim());

                                if (response != 'success') {
                                  ref.read(loadingProvider.notifier).toogle();

                                  Get.showSnackbar(GetSnackBar(
                                    title: 'Got some error',
                                    duration: Duration(seconds: 1),
                                    message: 'Please Confirm Your Id Password',
                                  ));
                                }
                              } else {
                                if (db.image == null) {
                                  Get.defaultDialog(
                                      title: 'Please Provide a Image',
                                      content: Text('Image must be Select'));
                                } else {
                                  ref.read(logSignProvider).signUp(
                                      customerName:
                                          customerNameController.text.trim(),
                                      email: customermailController.text.trim(),
                                      password:
                                          customerpassController.text.trim(),
                                      image: db.image!);
                                }
                              }
                            },
                            child: isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Is Loading Please Wait!!',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(isLogin
                                ? 'New to Logistics?'
                                : 'Joined Us Before?'),
                            TextButton(
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 78, 206, 46))),
                                onPressed: () {
                                  ref.read(loginProvider.notifier).toogle();
                                },
                                child: Text(isLogin ? 'SignUp' : 'Login')),
                            // TextButton(
                            //   onPressed: () {
                            //     if (customermailController.text.isNotEmpty) {
                            //       ref.read(logSignProvider).ResetPassword(
                            //           customermailController.text.trim());
                            //     } else {
                            //       Get.showSnackbar(GetSnackBar(
                            //         title: 'Email not provided',
                            //         duration: Duration(seconds: 1),
                            //         message: 'Please Provide the email',
                            //       ));
                            //     }
                            //   },
                            //   child: Text(isLogin ? 'Forget' : ''),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          })),
    );
  }
}
