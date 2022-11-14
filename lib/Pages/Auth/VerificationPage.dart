import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiklik_sports/Pages/Setup/SetupPageA.dart';
import 'package:hiklik_sports/config.dart';
import 'package:hiklik_sports/sports_widget.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  static Future sendLink(BuildContext context) async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    // ignore: use_build_context_synchronously
    scaffoldMessage(context, "Verification link has been sent");
  }

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool _submitting = false;

  void toBack() {
    FirebaseAuth.instance.currentUser!.reload();
    Navigator.of(context).pop();
  }

  Future sendLinkButton() async {
    setState(() {
      _submitting = true;
    });
    VerificationPage.sendLink(context);
    setState(() {
      _submitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Image.asset(
                    "assets/icon-sports.png",
                    height: 128,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Account Verification",
                    textAlign: TextAlign.center,
                    style: textH1,
                  ),
                  Text(
                    "Check your Email",
                    textAlign: TextAlign.center,
                    style: textH3,
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  Text(
                    "Email has been sent to ${FirebaseAuth.instance.currentUser!.email}",
                    textAlign: TextAlign.center,
                    style: textH3,
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  ElevatedButton(
                    onPressed: sendLinkButton,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors[3],
                      minimumSize: const Size.fromHeight(48),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      ),
                    ),
                    child: _submitting
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text('Click to send link'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: toBack,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: appColors[3],
                      backgroundColor: appColors[1],
                      minimumSize: const Size.fromHeight(48),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      ),
                    ),
                    child: const Text("Back"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  late User user;
  late Timer timer;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      checkEmailVerified();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    user = FirebaseAuth.instance.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: ((context) => const SetupPageA())), ModalRoute.withName('/AuthTree'));
    }
  }
}
