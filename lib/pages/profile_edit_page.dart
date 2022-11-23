// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hiklik_sports/Classes/user.dart';
import 'package:hiklik_sports/Pages/Auth/auth_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hiklik_sports/app/app_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  UserData tempUserData = UserData();

  bool isSaving = false;

  void toBack() {
    Navigator.of(context).pop();
  }

  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();
  TextEditingController textController3 = TextEditingController();
  TextEditingController textController4 = TextEditingController();
  TextEditingController textController5 = TextEditingController();
  TextEditingController textController6 = TextEditingController();
  TextEditingController textController7 = TextEditingController();
  TextEditingController textController8 = TextEditingController();
  TextEditingController textController9 = TextEditingController();
  TextEditingController textController10 = TextEditingController();

  File? file;
  FileImage? fileImage;

  Future pickImage() async {
    final pick = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        file = File(pick.path);
        fileImage = FileImage(file!);
      }
    });
  }

  Future createTemp() async {
    log("Create temp");
    var fetchedData = await currentUserData.getConverter().get();

    currentUserData = fetchedData.data()!;

    tempUserData = UserData.fromJson(currentUserData.toJson());

    applyFromTemp();
  }

  void applyFromTemp() {
    setState(() {
      textController1.text = tempUserData.user_name;
      textController2.text = tempUserData.user_domicile;
      textController3.text = tempUserData.user_phone;
      textController5.text = tempUserData.user_birthDate;
      textController6.text = tempUserData.type_sports;
      textController7.text = tempUserData.type_role;
      textController8.text = tempUserData.user_about;
      textController9.text = tempUserData.social_line;
      textController10.text = tempUserData.social_instagram;
    });
  }

  void applyToTemp() {
    tempUserData.uid = uid;
    tempUserData.user_name = textController1.text;
    tempUserData.user_domicile = textController2.text;
    tempUserData.user_phone = textController3.text;
    tempUserData.user_birthDate = textController5.text;
    tempUserData.type_sports = textController6.text;
    tempUserData.type_role = textController7.text;
    tempUserData.user_about = textController8.text;
    tempUserData.social_line = textController9.text;
    tempUserData.social_instagram = textController10.text;
  }

  Future trySaveProfile() async {
    setState(() {
      isSaving = true;
    });

    applyToTemp();

    tempUserData.user_avatar.url = await uploadImage();

    currentUserData = tempUserData;

    await UserData.Converter(uid).set(currentUserData);

    setState(() {
      isSaving = false;
    });

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    createTemp();
  }

  Future<String> uploadImage() async {
    String downloadUrl = tempUserData.user_avatar.url;

    if (file != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('user/profile/$uid/avatar');
      UploadTask uploadTask = ref.putFile(file!);

      await uploadTask.whenComplete(() async {
        downloadUrl = await ref.getDownloadURL();
      }).catchError((onError) {
        log(onError);
      });
    }

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ClipRect(
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: appColors[0],
                  leading: IconButton(
                      onPressed: toBack,
                      icon: Icon(
                        Icons.arrow_circle_left_outlined,
                        color: appColors[3],
                      )),
                  title: Text(
                    "Profile Edit",
                    style: TextStyle(color: appColors[3]),
                  ),
                ),
                body: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Form(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  height: 160,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: (file == null)
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              currentUserData.user_avatar.url,
                                          fit: BoxFit.contain,
                                          errorWidget: (context, url, error) {
                                            return const Image(
                                                image: AssetImage(
                                                    'assets/avatar.png'));
                                          },
                                          progressIndicatorBuilder:
                                              (context, url, progress) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          },
                                        )
                                      : Image.file(
                                          file!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                GestureDetector(
                                  onTap: pickImage,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .profile_edit_changeavatar,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                TextFormField(
                                  controller: textController1,
                                  decoration: AuthTextFieldDecoration("Name"),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    if (value == "") {
                                      return "Must not be empty.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: textController2,
                                  decoration:
                                      AuthTextFieldDecoration("Domicile"),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    if (value == "") {
                                      return "Must not be empty.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: textController3,
                                  decoration: AuthTextFieldDecoration("Phone"),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    if (value == "") {
                                      return "Must not be empty.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: textController5,
                                  decoration:
                                      AuthTextFieldDecoration("Birth Date"),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    if (value == "") {
                                      return "Must not be empty.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                DropdownButtonFormField2(
                                  value: (textController6.text != "")
                                      ? textController6.text
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
                                  buttonPadding: const EdgeInsets.only(
                                      left: 16, right: 16),
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
                                    return null;
                                  },
                                  onChanged: (value) {
                                    textController6.text = value.toString();
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                DropdownButtonFormField2(
                                  value: (textController7.text != "")
                                      ? textController7.text
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
                                  buttonPadding: const EdgeInsets.only(
                                      left: 16, right: 16),
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
                                    return null;
                                  },
                                  onChanged: (value) {
                                    textController7.text = value.toString();
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: textController8,
                                  decoration: AuthTextFieldDecoration("About"),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  minLines: 5,
                                  maxLines: null,
                                  validator: (String? value) {
                                    if (value == "") {
                                      return "Must not be empty.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: textController9,
                                  decoration: AuthTextFieldDecoration("Line"),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    if (value == "") {
                                      return "Must not be empty.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  controller: textController10,
                                  decoration:
                                      AuthTextFieldDecoration("Instagram"),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    if (value == "") {
                                      return "Must not be empty.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                ElevatedButton(
                                  onPressed: trySaveProfile,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: appColors[1],
                                    backgroundColor: appColors[2],
                                    minimumSize: const Size.fromHeight(48),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(32)),
                                    ),
                                  ),
                                  child: isSaving
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: appColors[1],
                                          ),
                                        )
                                      : const Text('Save profile'),
                                ),
                              ]),
                        ))))));
  }
}
