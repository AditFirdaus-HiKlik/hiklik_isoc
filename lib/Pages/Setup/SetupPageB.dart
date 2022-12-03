// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isoc/Classes/user.dart';
import 'package:isoc/Pages/Auth/auth_widget.dart';
import 'package:isoc/Pages/setup/setup_widget.dart';
import 'package:isoc/app/app_config.dart';
import 'package:page_transition/page_transition.dart';

class SetupPageB extends StatefulWidget {
  const SetupPageB({super.key});

  @override
  State<SetupPageB> createState() => _SetupPageBState();
}

class _SetupPageBState extends State<SetupPageB> {
  final _key = GlobalKey<FormState>();

  void toPrevious() {
    Navigator.of(context).pop();
  }

  Future toNext() async {
    if (_key.currentState!.validate()) {
      Navigator.of(context).push(
        PageTransition(
          childCurrent: widget,
          child: setupPages[2],
          type: PageTransitionType.rightToLeftJoined,
          curve: Curves.easeInOutQuart,
          duration: const Duration(milliseconds: 400),
          reverseDuration: const Duration(milliseconds: 400),
        ),
      );
    }
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
                      controller: UserDataController.textController7,
                      decoration: AuthTextFieldDecoration("About yourself*"),
                      minLines: 3,
                      maxLines: null,
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
