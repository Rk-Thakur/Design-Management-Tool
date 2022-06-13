import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerdesign/models/designer.dart';
import 'package:customerdesign/providers/auth_provider.dart';
import 'package:customerdesign/screens/profiledesigner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../providers/crud_provider.dart';

class designerprofile extends StatelessWidget {
  late String name;
  designerprofile({required this.name});
  var id;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Consumer(builder: (context, ref, child) {
        final allocateStream = ref.watch(allocateProvider);
        final userStream = ref.watch(userProvider);
        final design = ref.watch(designProvider);
        final customerStream = ref.watch(customerProvider);
        final postStream = ref.watch(postProvider);
        return customerStream.when(
            data: (dat) {
              return userStream.when(
                  data: (data) {
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (name == data[index].username)
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(66, 48, 23, 23),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(
                                                () => designerScreen(
                                                    cus: dat[index],
                                                    clickedid:
                                                        data[index].userId),
                                                transition:
                                                    Transition.downToUp);
                                          },
                                          child: Card(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 90,
                                                  backgroundImage: NetworkImage(
                                                      data[index].userImage),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  data[index]
                                                      .username
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  data[index].email,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                // Expanded(
                                //     child: Column(
                                //   children: [],
                                // ))
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
            error: (err, stack) => Text("${stack}"),
            loading: () => Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ));
      })),
    );
  }
}
