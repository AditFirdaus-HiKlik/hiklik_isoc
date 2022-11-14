
// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiklik_sports/Pages/Auth/SignInPage.dart';
import 'package:hiklik_sports/Pages/Auth/VerificationPage.dart';
import 'package:hiklik_sports/Pages/Home/HomePage.dart';
import 'package:page_transition/page_transition.dart';

class AuthTree extends StatefulWidget {
  const AuthTree({super.key});

  @override
  State<AuthTree> createState() => _AuthTreeState();
}

class _AuthTreeState extends State<AuthTree> {
  void toHomePage() {
    Navigator.of(context).push(
      PageTransition(
        childCurrent: widget,
        child: const VerificationPage(),
        type: PageTransitionType.topToBottomJoined,
        curve: Curves.easeInOutQuart,
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (FirebaseAuth.instance.currentUser != null) {
          User? user = snapshot.data;
          bool verified = user!.emailVerified;

          if (verified) {
            return const HomePage();
          } else {
            return const VerificationPage();
          }

        } else {
          return const SignInPage();
        }
      },
    );
  }
}
