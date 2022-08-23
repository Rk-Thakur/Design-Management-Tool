import 'package:customerdesign/providers/auth_provider.dart';
import 'package:customerdesign/providers/crud_provider.dart';
import 'package:customerdesign/screens/description_screen.dart';
import 'package:customerdesign/screens/drawer_widget.dart';
import 'package:customerdesign/widgets/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class HomeScreen extends StatelessWidget {
  final uid = auth.FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final design = ref.watch(designProvider);
      final customerStream = ref.watch(customerProvider);

      return Scaffold(
        appBar: AppBar(
          title: Text("Description"),
          centerTitle: true,
          backgroundColor: Color(0xffB4CFB0),
        ),
        // drawer: drawer_widget(),
        body: Container(
            child: customerStream.when(
                data: (data) {
                  return design.when(
                      data: (datas) {
                        return ListView.builder(
                            itemCount: datas.length,
                            itemBuilder: (context, index) {
                              final dat = datas[index];
                              return InkWell(
                                onLongPress: () async {
                                  final response = ref
                                      .read(logSignProvider)
                                      .removedescription(postId: dat.id);
                                  if (response == 'success') {
                                    print("deleted ${dat.id}");
                                  }
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (uid == dat.userId)
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Title:',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[600],
                                                ),
                                              )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            dat.designtitle,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Design Description:',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600],
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            dat.designDescription,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Price:',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600],
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            dat.price.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        //   Center(
                                        //     child: Text(
                                        //       dat.designtitle,
                                        //       textAlign: TextAlign.center,
                                        //       style: TextStyle(
                                        //         fontSize: 20,
                                        //         fontWeight: FontWeight.bold,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // Center(
                                        //   child: Text(
                                        //     dat.designDescription,
                                        //     textAlign: TextAlign.center,
                                        //     style: TextStyle(
                                        //       fontSize: 20,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //   ),
                                        // ),
                                        // Center(
                                        //   child: Text(
                                        //     dat.price.toString(),
                                        //     textAlign: TextAlign.center,
                                        //     style: TextStyle(
                                        //       fontSize: 20,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //   ),
                                        // ),
                                        // SizedBox(
                                        //   height: 10,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      error: (err, stack) => Text("$err"),
                      loading: () => Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            ),
                          ));
                },
                error: (err, stack) => Text("$err"),
                loading: () => Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ))),
      );
    });
  }
}
