import 'package:firebase/screens/adddesigner.dart';
import 'package:firebase/screens/customerdesc.dart';
import 'package:firebase/widgets/designerallocate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class admin extends StatefulWidget {
  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, left: 15, bottom: 0, right: 15),
          child: Column(
            children: [
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              Get.to(() => adddesigner(),
                                  transition: Transition.cupertinoDialog);
                            });
                          },
                          child: Card(
                            elevation: 5,
                            child: Container(
                              height: 130,
                              width: 140,
                              child: Column(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: Lottie.asset(
                                      'assets/images/addpeople.json',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Text(
                                    '+ Designer',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              Get.to(() => customerDesc(),
                                  transition: Transition.cupertino);
                            });
                          },
                          child: Card(
                            elevation: 5,
                            child: Container(
                              height: 130,
                              width: 140,
                              child: Column(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 120,
                                    child: Lottie.asset(
                                      'assets/images/cusdes.json',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              Get.to(() => designerAllocate(),
                                  transition: Transition.cupertinoDialog);
                            });
                          },
                          child: Card(
                            elevation: 5,
                            child: Container(
                              height: 130,
                              width: 140,
                              child: Column(
                                children: [
                                  Container(
                                    height: 90,
                                    width: 100,
                                    child: Lottie.asset(
                                      'assets/images/asign.json',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Allocated👲🏻👲🏻',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
