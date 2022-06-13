import 'package:customerdesign/models/design.dart';
import 'package:customerdesign/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPage extends StatelessWidget {
  late design_details editdesign;
  EditPage(this.editdesign);
  final designDescription = TextEditingController();
  final designAmount = TextEditingController();
  final _form = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Design"),
        centerTitle: true,
      ),
      body: Consumer(builder: (context, ref, child) {
        return Form(
            key: _form,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Edit Design Description',
                    style: TextStyle(
                        fontSize: 20, letterSpacing: 2, color: Colors.blueGrey),
                  ),
                  TextFormField(
                    controller: designDescription
                      ..text = editdesign.designDescription,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Description is required';
                      }

                      return null;
                    },
                    decoration: InputDecoration(hintText: 'Description'),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: designAmount
                      ..text = editdesign.price.toString(),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Price is required';
                      }

                      return null;
                    },
                    decoration: InputDecoration(hintText: 'Price'),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        _form.currentState!.save();
                        SystemChannels.textInput
                            .invokeMapMethod('TextInput.hide');
                        if (_form.currentState!.validate()) {
                          final response = await ref
                              .read(logSignProvider)
                              .updatedesignDescription(
                                  description: designDescription.text.trim(),
                                  price: int.parse(designAmount.text),
                                  designId: editdesign.designId,
                                  username: editdesign.username);
                          print(designDescription.text.toString());
                          if (response == 'success') {
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: Icon(Icons.add)),
                ],
              ),
            ));
      }),
    );
  }
}
