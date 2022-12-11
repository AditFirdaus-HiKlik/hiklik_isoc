// ignore_for_file: use_build_context_synchronously, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isoc/Classes/user.dart';
import 'package:isoc/Pages/Auth/auth_widget.dart';
import 'package:isoc/Pages/home/home_page.dart';
import 'package:isoc/app/app_config.dart';
import 'package:isoc/contents_api.dart';
import 'package:isoc/pages/auth_tree.dart';

class SetupPageC extends StatefulWidget {
  const SetupPageC({super.key});

  @override
  State<SetupPageC> createState() => _SetupPageCState();
}

class _SetupPageCState extends State<SetupPageC> {
  final _key = GlobalKey<FormState>();

  void toPrevious() {
    Navigator.of(context).pop();
  }

  Future toNext() async {
    if (_key.currentState!.validate()) {
      await submitData();
     Navigator.of(context)
      .pushAndRemoveUntil(
        MaterialPageRoute(
          builder: ((context) => const HomePage())
        ),
        ModalRoute.withName('/HomePage')
      );
    }
  }

  Future submitData() async {
    currentUserData = UserDataController.getUserData();

    final data = currentUserData.toJson();

    DocumentReference ref = db.collection("users").doc(uid);

    await ref.set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: UserDataController.textController8,
                      decoration: AuthTextFieldDecoration("Line"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: UserDataController.textController9,
                      decoration: AuthTextFieldDecoration("Instagram"),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: toPrevious,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColors[1],
                              minimumSize: const Size.fromHeight(48),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32)),
                              ),
                            ),
                            child: Text(
                              'Previous',
                              style: TextStyle(
                                color: appColors[3],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: toNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColors[3],
                              minimumSize: const Size.fromHeight(48),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32)),
                              ),
                            ),
                            child: const Text('Next'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
