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
          body: Container(
        child: Column(
          children: [
            Expanded(child: Consumer(
              builder: ((context, ref, child) {
                final chats = ref.watch(chatProvider);
                final user = ref.watch(userStream);

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
                                    InkWell(
                                      onLongPress: () async {
                                        final response = await ref
                                            .read(crudProvider)
                                            .removemessage(messageId: dat.id);

                                        if (response == 'success') {
                                          print('not deleted');
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: uid == dat.userId
                                              ? Color(0xffB4CFB0)
                                              : Color(0xffE5E3C9),
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
                                                  backgroundImage: NetworkImage(
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
                                minLines: 1,
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                controller: textController,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 239, 235, 234),
                                            width: 2.0)),
                                    labelText: 'Send a message',
                                    hintText: 'Send a Message',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  if (textController.text.isNotEmpty) {
                                    final response = ref
                                        .read(crudProvider)
                                        .messageAdd(
                                            message: textController.text.trim(),
                                            userId: uid,
                                            username: data.username,
                                            imageUrl: data.userImage

                                            // username:
                                            );
                                    //notifications
                                    // AwesomeNotifications().createNotification(
                                    //   content: NotificationContent(
                                    //     id: 1,
                                    //     channelKey: 'post',
                                    //     title: data.username,
                                    //     body: textController.text.toString(),

                                    //     // bigPicture: data.userImage,
                                    //     // notificationLayout:
                                    //     //     NotificationLayout.BigPicture,
                                    //   ),
                                    // );
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
