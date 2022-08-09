import 'package:firebase/providers/auth_provider.dart';
import 'package:firebase/screens/auth_screen.dart';
import 'package:firebase/screens/homescreen.dart';
import 'package:firebase/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final auth = ref.watch(authProvider);
      return auth.when(
          data: (data) {
            if (data == null) {
              return AuthScreen();
            } else {
              return home_screen();
            }
          },
          error: (err, stack) => Text('$err'),
          loading: () => Center(
                child: CircularProgressIndicator(),
              ));
    });
  }
}
