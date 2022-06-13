import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/providers/crud_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class chatRoom extends StatelessWidget {
  // final User user;
  // chatRoom({required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Consumer(
        builder: ((context, ref, child) {
          final chats = ref.watch(chatProvider);
          final user = ref.watch(userProvider);
          return user.when(
              data: (dat) {
                return chats.when(
                    data: (data) {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final dat = data[index];
                          final time =
                              DateTime.now().subtract(Duration(minutes: 15));
                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.abc),
                              title: Text(
                                dat.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              subtitle: Text(
                                timeago.format(time),
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
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
    );
  }
}
