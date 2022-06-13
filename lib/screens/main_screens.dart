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
          backgroundColor: Color.fromARGB(255, 114, 203, 92),
        ),
        drawer: drawer_widget(),
        body: Container(
            child: customerStream.when(
                data: (data) {
                  return design.when(
                      data: (datas) {
                        return ListView.builder(
                            itemCount: datas.length,
                            itemBuilder: (context, index) {
                              final dat = datas[index];
                              return Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (uid == dat.userId)
                                      // InkWell(
                                      //   // onTap: () {
                                      //   //   Get.to(() => EditPage(dat),
                                      //   //       transition: Transition.topLevel);
                                      //   // },
                                      //   child: ListTile(
                                      //     leading: Image.network(dat.userImage),
                                      //     title: Text(dat.designDescription),
                                      //     trailing: Text(dat.price.toString()),
                                      //     // ),
                                      //   ),
                                      // ),
                                      Center(
                                        child: Text(
                                          dat.designDescription,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
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
