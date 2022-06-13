import 'dart:async';

import 'package:firebase/screens/main_screen.dart';
import 'package:firebase/screens/status_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.black));
// notification format
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'post',
      channelDescription: 'Post description',
      channelName: 'Added Post',
      ledColor: Colors.white,
      playSound: true,
      enableLights: true,
      enableVibration: true,
    ),
  ]);
  runApp(ProviderScope(child: myapp()));
}

class myapp extends StatelessWidget {
  const myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: StatusCheck(),
    );
  }
}
