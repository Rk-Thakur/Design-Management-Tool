import 'package:customerdesign/providers/auth_provider.dart';
import 'package:customerdesign/screens/auth_screen.dart';
import 'package:customerdesign/screens/main_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusCheck extends StatelessWidget {
  const StatusCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final auth = ref.watch(authProvider);
        return auth.when(
            data: (data) {
              if (data == null) {
                return AuthScreen();
              } else {
                return HomeScreen();
              }
            },
            error: (err, stack) => Text("$err"),
            loading: () => Center(
                  child: CircularProgressIndicator(),
                ));
      },
    );
  }
}
