import 'package:firebase/providers/auth_provider.dart';
import 'package:firebase/providers/crud_provider.dart';
import 'package:firebase/providers/login_provider.dart';
import 'package:firebase/screens/adddesigner.dart';
import 'package:firebase/screens/customerdesc.dart';
import 'package:firebase/widgets/create_page.dart';
import 'package:firebase/widgets/designerallocate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../models/user.dart';

class drawer_widget extends ConsumerWidget {
  late User user;
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
                            image: NetworkImage(data.userImage),
                            fit: BoxFit.cover)),
                    child: Text(
                      data.email,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person_pin,
                      size: 40,
                    ),
                    title: Text("Home"),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => CreatePage(), transition: Transition.fadeIn);
                    },
                    title: Text("Create Post"),
                    leading: Icon(
                      Icons.add_business,
                      size: 40,
                    ),
                  ),
                  data.userId == "55xjWTFUjUVL3kBgOqCUL1u7eyr1"
                      ? Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Get.to(() => adddesigner(),
                                    transition: Transition.downToUp);
                              },
                              leading: Icon(
                                Icons.verified_user_rounded,
                                size: 40,
                              ),
                              title: Text("Add Designer"),
                            ),
                            ListTile(
                              onTap: () {
                                Get.to(() => customerDesc(),
                                    transition: Transition.downToUp);
                              },
                              leading: Icon(
                                Icons.dashboard_customize_rounded,
                                size: 40,
                              ),
                              title: Text("Customer Description"),
                            ),
                            ListTile(
                              onTap: () {
                                Get.to(() => designerAllocate(),
                                    transition: Transition.downToUp);
                              },
                              leading: Icon(
                                Icons.design_services,
                                size: 40,
                              ),
                              title: Text("Allocated Designer"),
                            ),
                          ],
                        )
                      : Divider(),
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
                  )
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
