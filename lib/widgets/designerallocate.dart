import 'package:firebase/providers/crud_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class designerAllocate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Designer Allocation"),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final allocateStream = ref.watch(allocateProvider);
          final userStream = ref.watch(userProvider);
          final design = ref.watch(designProvider);
          final customerStream = ref.watch(customerProvider);
          return Container(
              child: allocateStream.when(
                  data: (data) {
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final dat = data[index];
                          return Container(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    final response = ref
                                        .read(crudProvider)
                                        .removeallocation(allocationid: dat.id);
                                  },
                                  child: Card(
                                    elevation: 5,
                                    child: ListTile(
                                      title: Text(dat.designtitle),
                                      subtitle:
                                          Text(dat.designername.toUpperCase()),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  error: (err, stack) => Text("$err"),
                  loading: () => Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      )));
        },
      ),
    );
  }
}
