import 'package:customerdesign/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class designdescCollection extends StatelessWidget {
  const designdescCollection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final designStream = ref.watch(designProvider);
        return Scaffold(
          appBar: AppBar(
            title: Text("design Details"),
            centerTitle: true,
          ),
          body: SafeArea(
              child: Container(
            child: designStream.when(
                data: (data) {
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final dat = data[index];
                        return Card(
                          child: Column(children: [
                            Text(dat.designDescription),
                            // Text(int.parse(dat.price.toInt()))
                          ]),
                        );
                      });
                },
                error: (err, stack) => Text("$err"),
                loading: () => Center(
                      child: CircularProgressIndicator(color: Colors.purple),
                    )),
          )),
        );
      },
    );
  }
}
