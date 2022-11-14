import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiklik_sports/Classes/user.dart';

class WorkBench extends StatefulWidget {
  @override
  State<WorkBench> createState() => _WorkBenchState();
}

class _WorkBenchState extends State<WorkBench> {
  UserData userData = UserData();

  Future Upload() async {
    final data = userData.toJson();

    DocumentReference ref =
        FirebaseFirestore.instance.collection("users").doc("uid");

    log("Set UserData Successfully with Data: ${ref.toString()}");
    await ref.set(data);
  }

  Future Download() async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection("users").doc("uid");

    DocumentSnapshot<Object?> snapshot = await ref.get();

    Map<String, dynamic> snapshotData = snapshot.data() as Map<String, dynamic>;

    setState(() {
      userData = UserData.fromJson(snapshotData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(userData.toJson().toString()),
          ElevatedButton(
            onPressed: Upload,
            child: const Text("Upload"),
          ),
          ElevatedButton(
            onPressed: Download,
            child: const Text("Download"),
          ),
        ],
      ),
    );
  }
}
