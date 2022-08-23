import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerdesign/providers/crud_provider.dart';
import 'package:customerdesign/screens/allocatedDesigner.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../providers/auth_provider.dart';

class Seetting extends StatefulWidget {
  @override
  State<Seetting> createState() => _SeettingState();
}

class _SeettingState extends State<Seetting> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Consumer(builder: (context, ref, child) {
        final user = ref.watch(userStream);
        return Center(
            child: user.when(
                data: (data) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                GFAvatar(
                                  size: GFSize.MEDIUM,
                                  radius: 50,
                                  backgroundImage: CachedNetworkImageProvider(
                                      data.customerImage),
                                ),
                                Text(
                                  data.cusomtername,
                                  style: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 3,
                                    fontWeight: FontWeight.bold,
                                    height: 2,
                                  ),
                                ),
                                Text(
                                  data.customeremail,
                                  style: TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w400,
                                    height: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: double.infinity,
                            height: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => allocatedDesigner(),
                                        transition: Transition.cupertinoDialog);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xffB4CFB0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.paintbrush,
                                            size: 28,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Designer Allocation",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      ref.read(logSignProvider).LogOut();
                                      // ref.refresh(loadingProvider.notifier);
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xffB4CFB0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.logout,
                                            size: 28,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Logout",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                error: (err, stack) => Text("${err}"),
                loading: () => Center(
                        child: CircularProgressIndicator(
                      color: Color(0xffe26a2c),
                    ))));
      })),
    );
  }
}
