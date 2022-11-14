import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiklik_sports/Pages/Auth/VerificationPage.dart';
import 'package:hiklik_sports/Pages/Auth/auth_widget.dart';
import 'package:hiklik_sports/config.dart';
import 'package:hiklik_sports/sports_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _key = GlobalKey<FormState>();

  bool _submitting = false;
  String errorMessage = "";

  final TextEditingController _textController1 = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();
  final TextEditingController _textController3 = TextEditingController();

  void toVerificationPage() {
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
    // Navigator.pop(context);
  }

  Future trySignUp() async {
    if (_key.currentState!.validate()) {
      setState(() {
        _submitting = true;
      });

      final String email = _textController1.text;
      final String password = _textController2.text;

      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        scaffoldMessage(context, "Sign Up Successfull");

        _submitting = false;

        VerificationPage.sendLink(context);
        toVerificationPage();
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
                      AppLocalizations.of(context)!.signup_header,
                      textAlign: TextAlign.center,
                      style: textH1,
                    ),
                    Text(
                      AppLocalizations.of(context)!.signup_header_description,
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
                    TextFormField(
                      controller: _textController2,
                      decoration: AuthTextFieldDecoration("Password"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: true,
                      validator: (String? value) {
                        if (value == "") return "Must not be empty.";
                        if (value != null && !(value.length >= 6)) {
                          return "Must 6 characters long.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _textController3,
                      decoration: AuthTextFieldDecoration("Confirm password"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: true,
                      validator: (String? value) {
                        if (value != _textController2.text) {
                          return "Password not match.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      onPressed: trySignUp,
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
                          : Text(AppLocalizations.of(context)!.signup_button_signup),
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
                      child: Text(AppLocalizations.of(context)!.signup_button_back),
                    ),
                    if (errorMessage != "")
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 48,
                            ),
                            const Icon(
                              Icons.warning_rounded,
                              color: Colors.red,
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            Text(
                              errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
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
