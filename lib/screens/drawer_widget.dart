import 'package:customerdesign/providers/auth_provider.dart';
import 'package:customerdesign/providers/crud_provider.dart';
import 'package:customerdesign/providers/login_provider.dart';
import 'package:customerdesign/screens/allocatedDesigner.dart';
import 'package:customerdesign/screens/description_screen.dart';
import 'package:customerdesign/screens/designcollection.dart';
import 'package:customerdesign/screens/main_screens.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class drawer_widget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userStream);
    return SafeArea(
      child: user.when(
          data: (data) {
            return Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    padding: EdgeInsets.only(top: 120),
                    decoration: BoxDecoration(
                        color: Colors.black45,
                        image: DecorationImage(
                            opacity: .5,
                            image: NetworkImage(data.customerImage),
                            fit: BoxFit.cover)),
                    child: Text(
                      data.customeremail,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(() => HomeScreen(),
                          transition: Transition.cupertino);
                    },
                    leading: Icon(
                      Icons.person_pin,
                      size: 40,
                    ),
                    title: Text("Home"),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Get.to(() => Home(), transition: Transition.fadeIn);
                    },
                    title: Text("Design Details"),
                    leading: Icon(
                      Icons.add_business,
                      size: 40,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Get.to(() => allocatedDesigner(),
                          transition: Transition.cupertinoDialog);
                    },
                    title: Text("Designer Allocation"),
                    leading: Icon(
                      Icons.add_business,
                      size: 40,
                    ),
                  ),
                  Divider(),
                  // ListTile(
                  //   onTap: () {
                  //     Get.to(() => allocatedDesigner(),
                  //         transition: Transition.cupertinoDialog);
                  //   },
                  //   title: Text("Gallery"),
                  //   leading: Icon(
                  //     Icons.add_business,
                  //     size: 40,
                  //   ),
                  // ),
                  // Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(logSignProvider).LogOut();
                      ref.refresh(loadingProvider.notifier);
                      // ref.refresh(loadingProvider);
                    },
                    leading: Icon(
                      Icons.exit_to_app,
                      size: 40,
                    ),
                    title: Text("Logout"),
                  ),
                ],
              ),
            );
          },
          error: (err, stack) => Text('$err'),
          loading: () => Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )),
    );
  }
}
