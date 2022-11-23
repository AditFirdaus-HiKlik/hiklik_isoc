import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiklik_sports/Pages/home/home_page.dart';
import 'package:hiklik_sports/pages/auth/sign_in_page.dart';

class AuthTree extends StatefulWidget {
  const AuthTree({super.key});

  @override
  State<AuthTree> createState() => _AuthTreeState();
}

class _AuthTreeState extends State<AuthTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
        bool verified = user.emailVerified;

        if (verified) {
          log("Auth success", name: "auth_tree.dart");
          return const HomePage();
        } else {
          log("Auth need [Email Verification]", name: "auth_tree.dart");
          return const SignInPage();
        }
        } else {
          log("User not found: $user", name: "auth_tree.dart");
          return const SignInPage();
        }
      },
    );
  }
}
