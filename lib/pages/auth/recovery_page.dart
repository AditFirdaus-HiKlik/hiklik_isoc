// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiklik_sports/Pages/Auth/auth_widget.dart';
import 'package:hiklik_sports/app/app_config.dart';
import 'package:hiklik_sports/sports_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class RecoveryPage extends StatefulWidget {
  const RecoveryPage({super.key});

  @override
  State<RecoveryPage> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  final _key = GlobalKey<FormState>();

  bool _submitting = false;
  String errorMessage = "";

  final TextEditingController _textController1 = TextEditingController();

  Future tryRecover() async {
    if (_key.currentState!.validate()) {
      setState(() {
        _submitting = true;
      });

      final String email = _textController1.text;

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email,
        );

        setState(() {
          _submitting = false;
        });

        scaffoldMessage(context, "Password reset link has been sent");

        toBack();
      } on FirebaseAuthException catch (e) {
        errorMessage = e.message!;

        scaffoldMessage(context, e.message!);

        setState(() {
          _submitting = false;
        });
      }
    }
  }

  void toBack() {
    log("Navigate To: Back()", name: "recovery_page.dart");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Form(
                key: _key,
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
                      AppLocalizations.of(context)!.recovery_header,
                      textAlign: TextAlign.center,
                      style: textH1,
                    ),
                    Text(
                      AppLocalizations.of(context)!.recovery_header_description,
                      textAlign: TextAlign.center,
                      style: textH3,
                    ),
                    const SizedBox(
                      height: 64,
                    ),
                    TextFormField(
                      controller: _textController1,
                      decoration: AuthTextFieldDecoration("Email"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value == "") return "Must not be empty.";
                        if (value != null && !value.contains("@")) {
                          return "Must be an email.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      onPressed: tryRecover,
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
                          : Text(AppLocalizations.of(context)!.recovery_button_signin,),
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
                      child: Text(AppLocalizations.of(context)!.recovery_button_back,),
                    )
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
