import 'package:customerdesign/models/designer.dart';
import 'package:customerdesign/providers/auth_provider.dart';
import 'package:customerdesign/providers/crud_provider.dart';
import 'package:customerdesign/screens/designerprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:get/get.dart';

class allocatedDesigner extends StatelessWidget {
  final uid = auth.FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Allocated Designer")),
      body: Consumer(builder: (context, ref, child) {
        final allocateStream = ref.watch(allocateProvider);
        final userStream = ref.watch(userProvider);
        final design = ref.watch(designProvider);
        final customerStream = ref.watch(customerProvider);
        return Container(
            child: customerStream.when(
                data: (cus) {
                  return allocateStream.when(
                    data: (da) {
                      return design.when(
                          data: (data) {
                            return ListView.builder(
                              itemCount: da.length,
                              itemBuilder: (context, index) {
                                return Card(
                                    child: Column(
                                  children: [
                                    if (uid == da[index].customerId)
                                      // if (cus[index].cusomtername ==
                                      //         data[index].username &&
                                      //     data[index].designDescription ==
                                      //         da[index].designDescription)
                                      // if (uid == da[index].customerId)
                                      Container(
                                          child: ListTile(
                                        onTap: () {
                                          Get.to(() => designerprofile(
                                              name: da[index].designername));
                                          // print(user.userId);
                                        },
                                        title: Text(
                                          da[index]
                                              .designtitle, //allocated design descrilptiono
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // subtitle:
                                        //     Text(da[index].designername),
                                        subtitle: Text(da[index]
                                            .designername
                                            .toUpperCase()),
                                      )),
                                  ],
                                ));
                              },
                            );
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
                    ),
                  );
                },
                error: (err, stack) => Text("$err"),
                loading: () => Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    )));
      }),
    );
  }
}
