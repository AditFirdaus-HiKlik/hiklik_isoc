import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hiklik_sports/Pages/Setup/SetupPageA.dart';
import 'package:hiklik_sports/Pages/Setup/SetupPageB.dart';
import 'package:hiklik_sports/Pages/Setup/SetupPageC.dart';

const List<Widget> setupPages = [
  SetupPageA(),
  SetupPageB(),
  SetupPageC(),
];

class SetupDropDown extends StatefulWidget {
  TextEditingController controller;

  String title = "";

  List<String> list = [];

  SetupDropDown(this.controller, this.title, this.list, {super.key});

  @override
  State<SetupDropDown> createState() => _SetupDropDownState();
}

class _SetupDropDownState extends State<SetupDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      searchController: widget.controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      isExpanded: true,
      hint: Text(
        widget.title,
        style: const TextStyle(fontSize: 14),
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
      items: widget.list
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
        return null;
      },
      onChanged: (value) {
        log("Selected Value: ${value.toString()}");
        widget.controller.text = value.toString();
      },
      onSaved: (newValue) {},
    );
  }
}
