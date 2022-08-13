import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/customerdescdetails.dart';
import 'package:firebase/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase/providers/auth_provider.dart';
import 'package:firebase/providers/crud_provider.dart';
import 'package:firebase/providers/login_provider.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:get/get.dart';

class customerDesc extends StatefulWidget {
  @override
  State<customerDesc> createState() => _customerDescState();
}

class _customerDescState extends State<customerDesc> {
  var customer;
  var id;
  var designer;
  // final uid = auth.FirebaseAuth.instance.currentUser!.uid;

  var setDefaultMake = true, setDefaultMakeModel = true;
  var setDefaultDesign = true, setDefaultDesignModel = true;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final customerStream = ref.watch(customerProvider);
      final design = ref.watch(designProvider);
      final userStream = ref.watch(userProvider);

      return SafeArea(
        child: Scaffold(
          body: Container(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 198, 196, 196),
                      borderRadius: BorderRadius.circular(10)),
                  height: 120,
                  child: customerStream.when(
                      data: (data) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final dat = data[index];
                                return Container(
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 33,
                                        backgroundImage:
                                            NetworkImage(dat.customerImage),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        dat.cusomtername,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        );
                      },
                      error: (err, stack) => Text("$err"),
                      loading: () => Center(
                            child: CircularProgressIndicator(
                              color: Colors.pink,
                            ),
                          )),
                ),
              ),
              Expanded(
                  child: Container(
                child: design.when(
                    data: (data) {
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final dat = data[index];
                            id = dat.userId;

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  Get.to(
                                      () => customerdescdetails(
                                            userImage: dat.userImage,
                                            designtitle: dat.designtitle,
                                            price: dat.price.toString(),
                                            username: dat.username,
                                            description: dat.designDescription,
                                          ),
                                      transition: Transition.fade);
                                });
                              },
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(dat.userImage)),
                                  title: Text(dat.designtitle),
                                  trailing: Text(dat.price.toString()),
                                  subtitle: Text(dat.username),
                                ),
                              ),
                            );
                          });
                    },
                    error: (err, stack) => Text("$err"),
                    loading: () => Center(
                          child: CircularProgressIndicator(
                            color: Colors.pink,
                          ),
                        )),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffB4CFB0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: design.when(
                        data: (data) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Customer Description',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection(
                                            "customersdesigndescription")
                                        .orderBy('designDescription')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) return Container();
                                      return DropdownButton(
                                        isExpanded: false,
                                        value: customer,
                                        items: snapshot.data?.docs.map((value) {
                                          return DropdownMenuItem(
                                            value: value.get('designtitle'),
                                            child: Text(
                                                '${value.get('designtitle')}'),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          debugPrint(
                                              'selected onchange: $value');
                                          setState(
                                            () {
                                              debugPrint(
                                                  'make selected: $value');
                                              // Selected value will be stored
                                              customer = value;
                                              // Default dropdown value won't be displayed anymore
                                              setDefaultMake = false;
                                              // Set makeModel to true to display first car from list
                                              setDefaultMakeModel = true;
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Designer',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("users")
                                        .orderBy('userId')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot>
                                            snapshots) {
                                      if (!snapshots.hasData)
                                        return Container();
                                      return DropdownButton(
                                        isExpanded: false,
                                        value: designer,
                                        items:
                                            snapshots.data?.docs.map((value) {
                                          return DropdownMenuItem(
                                            value: value.get('username'),
                                            child: Text(
                                                '${value.get('username')}'),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          debugPrint(
                                              'selected onchange: $value');
                                          setState(
                                            () {
                                              debugPrint(
                                                  'make selected: $value');
                                              designer = value;
                                              setDefaultDesign = false;
                                              setDefaultDesignModel = true;
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color(0xff789395))),
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    final response = await ref
                                        .read(crudProvider)
                                        .allocateDesigner(
                                            designtitle: customer,
                                            designername: designer,
                                            customerId: id
                                            // designerId: uid,
                                            );
                                    if (response == 'success') {
                                      Get.showSnackbar(
                                        GetSnackBar(
                                          title: 'Designer Allocated',
                                          duration: Duration(seconds: 1),
                                          message: 'Choose the Next One',
                                        ),
                                      );
                                    }
                                  },
                                  child: Icon(Icons.add))
                            ],
                          );
                        },
                        error: (err, stack) => Text('${err}'),
                        loading: () => Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            ))),
              ),
            ]),
          ),
        ),
      );
    });
  }
}
