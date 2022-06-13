import 'package:firebase/providers/crud_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class designerAllocate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Allocate Designer List"),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final allocateStream = ref.watch(allocateProvider);
          final userStream = ref.watch(userProvider);
          final design = ref.watch(designProvider);
          final customerStream = ref.watch(customerProvider);

          // return Container(
          //     child: userStream.when(
          //         data: (dat) {
          //           return allocateStream.when(
          //               data: (da) {
          //                 return design.when(
          //                     data: (data) {
          //                       return Container(
          //                         child: ListView.builder(
          //                             itemCount: dat.length,
          //                             itemBuilder: (context, index) {
          //                               return Card(

          //                                   // child: ListTile(
          //                                   //   title: Text(
          //                                   //     da[index].designDescription,
          //                                   //     style: TextStyle(
          //                                   //       fontSize: 20,
          //                                   //       fontWeight: FontWeight.bold,
          //                                   //     ),
          //                                   //   ),
          //                                   //   // subtitle:
          //                                   //   //     Text(da[index].designername),
          //                                   //   subtitle:
          //                                   //       Text("User Description: "),
          //                                   //   leading: Column(
          //                                   //     children: [
          //                                   //       CircleAvatar(
          //                                   //         backgroundImage: NetworkImage(
          //                                   //             dat[index].userImage),
          //                                   //       ),
          //                                   //       Text(dat[index].username),
          //                                   //     ],
          //                                   //   ),
          //                                   //   // trailing: Column(
          //                                   //   //   children: [
          //                                   //   //     CircleAvatar(
          //                                   //   //         backgroundImage:
          //                                   //   //             NetworkImage(data[index]
          //                                   //   //                 .userImage)),
          //                                   //   //     Text(data[index].username)
          //                                   //   //   ],
          //                                   //   // ),
          //                                   // ),
          //                                   );
          //                             }),
          //                       );
          //                     },
          //                     error: (err, stack) => Text("$err"),
          //                     loading: () => Center(
          //                           child: CircularProgressIndicator(
          //                             color: Colors.red,
          //                           ),
          //                         ));
          //               },
          //               error: (err, stack) => Text("$err"),
          //               loading: () => Center(
          //                     child: CircularProgressIndicator(
          //                       color: Colors.red,
          //                     ),
          //                   ));
          //         },
          //         error: (err, stack) => Text("$err"),
          //         loading: () => Center(
          //               child: CircularProgressIndicator(
          //                 color: Colors.red,
          //               ),
          //             )));

          return Container(
              child: allocateStream.when(
                  data: (data) {
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(data[index].designDescription),
                                  subtitle: Text(
                                      data[index].designername.toUpperCase()),
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
