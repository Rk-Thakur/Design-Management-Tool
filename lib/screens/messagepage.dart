import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase/providers/crud_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class messagepage extends ConsumerWidget {
  // final User user;
  // messagepage(this.user);

  final textController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context, ref) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Public group"),
            leading: Icon(Icons.message),
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(child: Consumer(
                  builder: ((context, ref, child) {
                    final chats = ref.watch(chatProvider);
                    final user = ref.watch(userStream);
                    final chat = ref.watch(crudProvider);

                    return user.when(
                        data: (dat) {
                          return chats.when(
                              data: (data) {
                                return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    final dat = data[index];
                                    final time = DateTime.now()
                                        .subtract(Duration(minutes: 1));

                                    return Row(
                                      mainAxisAlignment: uid == dat.userId
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: uid == dat.userId
                                                ? Theme.of(context).accentColor
                                                : Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          width: 200,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 16),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          child: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            dat.imageUrl),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    dat.username,
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                child: Column(
                                                  children: [
                                                    AutoSizeText(
                                                      dat.text,
                                                      style: TextStyle(
                                                        color: uid == dat.userId
                                                            ? Colors.white
                                                            : Colors.purple,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                      ),
                                                      maxLines: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              error: (err, stack) => Text("$err"),
                              loading: () => Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.pink,
                                    ),
                                  ));
                        },
                        error: (err, stack) => Text("$err"),
                        loading: () => Center(
                              child: CircularProgressIndicator(
                                color: Colors.pink,
                              ),
                            ));
                  }),
                )),
                Consumer(
                  builder: (context, ref, child) {
                    final chat = ref.watch(crudProvider);
                    final user = ref.watch(userStream);
                    return user.when(
                        data: (data) {
                          return Container(
                            margin: EdgeInsets.only(top: 8),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: textController,
                                    decoration: InputDecoration(
                                        labelText: 'Send a message'),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      if (textController.text.isNotEmpty) {
                                        final response = ref
                                            .read(crudProvider)
                                            .messageAdd(
                                                message:
                                                    textController.text.trim(),
                                                userId: uid,
                                                username: data.username,
                                                imageUrl: data.userImage

                                                // username:
                                                );
                                        //notifications
                                        AwesomeNotifications()
                                            .createNotification(
                                          content: NotificationContent(
                                            id: 1,
                                            channelKey: 'post',
                                            title: data.username,
                                            body:
                                                textController.text.toString(),

                                            // bigPicture: data.userImage,
                                            // notificationLayout:
                                            //     NotificationLayout.BigPicture,
                                          ),
                                        );
                                        textController.clear();
                                      }
                                    },
                                    icon: Icon(Icons.send))
                              ],
                            ),
                          );
                        },
                        error: (err, stack) => Text("$err"),
                        loading: () => Center(
                              child: CircularProgressIndicator(
                                color: Colors.pink,
                              ),
                            ));
                  },
                ),
              ],
            ),
          )),
    );
  }
}
