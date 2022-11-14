import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hiklik_sports/Classes/user.dart';
import 'package:hiklik_sports/Pages/Auth/auth_widget.dart';
import 'package:hiklik_sports/Pages/Setup/setup_widget.dart';
import 'package:hiklik_sports/config.dart';
import 'package:hiklik_sports/sports_widget.dart';
import 'package:page_transition/page_transition.dart';

class SetupPageA extends StatefulWidget {
  const SetupPageA({super.key});

  @override
  State<SetupPageA> createState() => _SetupPageAState();
}

class _SetupPageAState extends State<SetupPageA> {
  static bool needFetch = true;

  final _key = GlobalKey<FormState>();

  Future toNext() async {
    if (_key.currentState!.validate()) {
      Navigator.of(context).push(
        PageTransition(
          childCurrent: widget,
          child: setupPages[1],
          type: PageTransitionType.rightToLeftJoined,
          curve: Curves.easeInOutQuart,
          duration: const Duration(milliseconds: 400),
          reverseDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  static Future<UserData> getUserData(String uid) async {
    var data = UserData();

    DocumentReference ref =
        FirebaseFirestore.instance.collection("users").doc(uid);

    try {
      DocumentSnapshot<Object?> snapshot = await ref.get();

      Map<String, dynamic> snapshotData =
          snapshot.data() as Map<String, dynamic>;

      log("Get UserData Successfully with Data: ${ref.toString()}");

      data = UserData.fromJson(snapshotData);
    } catch (e) {
      log("Get UserData Failed");
    }

    return data;
  }

  Future fetchData() async {
    currentUserData = await getUserData(uid);
    log(uid);
    UserDataController.fromUserData(currentUserData);
    setState(() {});
  }

  @override
  void initState() {
    if (needFetch) {
      needFetch = false;
      fetchData();
    }
    super.initState();
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
                    Text(
                      "Account Setup",
                      textAlign: TextAlign.center,
                      style: textH1,
                    ),
                    const SizedBox(
                      height: 64,
                    ),
                    TextFormField(
                      controller: UserDataController.textController1,
                      decoration: AuthTextFieldDecoration("Name*"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value == "") return "Must not be empty.";
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: UserDataController.textController2,
                      decoration: AuthTextFieldDecoration("Domicile*"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value == "") return "Must not be empty.";
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: UserDataController.textController3,
                      decoration: AuthTextFieldDecoration("Phone*"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value == "") return "Must not be empty.";
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: UserDataController.textController4,
                      decoration: AuthTextFieldDecoration("Birth Date*"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value == "") return "Must not be empty.";
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DropdownButtonFormField2(
                      value: (UserDataController.textController5.text != "")
                          ? UserDataController.textController5.text
                          : null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      isExpanded: true,
                      hint: const Text(
                        "Select sports",
                        style: TextStyle(fontSize: 14),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 32,
                      buttonHeight: 64,
                      buttonPadding: const EdgeInsets.only(left: 16, right: 16),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      items: sportList
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select list.';
                        }
                      },
                      onChanged: (value) {
                        UserDataController.textController5.text =
                            value.toString();
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DropdownButtonFormField2(
                      value: (UserDataController.textController6.text != "")
                          ? UserDataController.textController6.text
                          : null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      isExpanded: true,
                      hint: const Text(
                        "Select occupation",
                        style: TextStyle(fontSize: 14),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 32,
                      buttonHeight: 64,
                      buttonPadding: const EdgeInsets.only(left: 16, right: 16),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      items: roleList
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select list.';
                        }
                      },
                      onChanged: (value) {
                        UserDataController.textController6.text =
                            value.toString();
                      },
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    ElevatedButton(
                      onPressed: toNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColors[3],
                        minimumSize: const Size.fromHeight(48),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                        ),
                      ),
                      child: const Text('Next'),
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
