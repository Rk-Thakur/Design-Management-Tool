import 'package:customerdesign/models/user.dart';
import 'package:customerdesign/providers/auth_provider.dart';
import 'package:customerdesign/providers/crud_provider.dart';
import 'package:customerdesign/providers/login_provider.dart';
import 'package:customerdesign/screens/drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final designDescription = TextEditingController();
  final designAmount = TextEditingController();
  final designtitle = TextEditingController();
  late final Customer customer;
  final _form = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          drawer: drawer_widget(),
          body: Container(
            padding: EdgeInsets.all(32),
            child: Consumer(
              builder: (context, ref, child) {
                final description = ref.watch(logSignProvider);
                final user = ref.watch(userStream);
                return user.when(
                    data: (data) {
                      return Form(
                          key: _form,
                          child: Container(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/details.png',
                                    height: 300,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Design \n Description!!',
                                        style: TextStyle(
                                          letterSpacing: 2,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff132a4d),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: designtitle,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Title is required';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 15),
                                          hintText: 'Title',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: designDescription,
                                      maxLines: 10,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Description is required';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 15),
                                          hintText: 'Description',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: designAmount,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Price is required';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Price',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xff83BD75))),
                                      onPressed: () async {
                                        _form.currentState!.save();
                                        FocusScope.of(context).unfocus();
                                        if (_form.currentState!.validate()) {
                                          final respnose = await ref
                                              .read(logSignProvider)
                                              .addDesignDescrption(
                                                  username: data.cusomtername
                                                      .toString(),
                                                  designdescription:
                                                      designDescription.text,
                                                  price: int.parse(
                                                      designAmount.text),
                                                  userId: data.customerId,
                                                  userImage: data.customerImage,
                                                  title: designtitle.text);
                                          if (respnose == 'success') {
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                      child: Icon(Icons.add)),
                                ],
                              ),
                            ),
                          ));
                    },
                    error: (err, stack) => Text("$err"),
                    loading: () => Center(
                          child: CircularProgressIndicator(
                            color: Colors.pink,
                          ),
                        ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
