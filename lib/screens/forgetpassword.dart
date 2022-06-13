import 'package:customerdesign/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../providers/login_provider.dart';

class forgetPassword extends StatelessWidget {
  final customerNameController = TextEditingController();
  final customermailController = TextEditingController();
  final customerpassController = TextEditingController();

  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // backgroundColor: Color(0xffE9EFC0),
          body: Consumer(builder: (context, ref, child) {
        return SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _form,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/forget.png',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Forgot \nPassword?',
                        style: TextStyle(
                          letterSpacing: 2,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff132a4d),
                        ),
                      )),
                  SizedBox(
                    height: 15,
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
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      " Don't worry! It happens. Please enter the\n address associated with your account.",
                      style: TextStyle(
                        letterSpacing: 1.0,
                        height: 1.5,
                        fontSize: 14,
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
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xff83BD75))),
                        onPressed: () async {
                          _form.currentState!.save();
                          FocusScope.of(context).unfocus();
                          _form.currentState!.validate();
                          if (customermailController.text.isNotEmpty) {
                            ref.read(logSignProvider).ResetPassword(
                                customermailController.text.trim());
                          } else {
                            Get.showSnackbar(GetSnackBar(
                              title: 'Email not provided',
                              duration: Duration(seconds: 1),
                              message: 'Please Provide the email',
                            ));
                          }
                        },
                        child: Text(
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
                ],
              ),
            ),
          ),
        );
      })),
    );
  }
}
