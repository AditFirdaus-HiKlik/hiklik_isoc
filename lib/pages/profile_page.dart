// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isoc/Classes/user.dart';
import 'package:isoc/Pages/Auth/auth_widget.dart';
import 'package:isoc/app/app_config.dart';
import 'package:isoc/pages/profile_edit_page.dart';
import 'package:isoc/sports_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static Future<UserDataAchivement> editAchivementData(
      BuildContext context, int index) async {
    UserDataAchivement userDataAchivement = UserDataAchivement();

    if (index != -1) {
      userDataAchivement = currentUserData.user_achivements[index];
    }

    TextEditingController textController1 = TextEditingController();
    TextEditingController textController2 = TextEditingController();

    textController1.text = userDataAchivement.title;
    textController2.text = userDataAchivement.description;

    String result = await showCupertinoDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context, "delete");
                            },
                            icon: Icon(
                              Icons.delete,
                              color: appColors[4],
                            )),
                        const SizedBox(
                          width: 16,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context, "save");
                            },
                            icon: const Icon(Icons.save)),
                        const SizedBox(
                          width: 16,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context, "cancel");
                            },
                            icon: const Icon(Icons.cancel)),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: textController1,
                      decoration: AuthTextFieldDecoration("Title*"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value == "") return "Must not be empty.";
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: textController2,
                      decoration: AuthTextFieldDecoration("Description*"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value == "") return "Must not be empty.";
                        return null;
                      },
                      minLines: 3,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    userDataAchivement.title = textController1.text;
    userDataAchivement.description = textController2.text;

    switch (result) {
      case "delete":
        if (index != -1) {
          currentUserData.user_achivements.removeAt(index);
        }
        break;
      case "save":
        if (index != -1) {
          currentUserData.user_achivements[index] = userDataAchivement;
        } else {
          currentUserData.user_achivements.add(userDataAchivement);
        }
        break;
      default:
    }

    await currentUserData.getConverter().set(currentUserData);

    return userDataAchivement;
  }

  static Future<UserDataImage> editGalleryData(
      BuildContext context, int index) async {
    UserDataImage galleryData = UserDataImage();

    if (index != -1) {
      galleryData = currentUserData.user_gallery[index];
    }

    String result = await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop("delete");
                            },
                            icon: Icon(
                              Icons.delete,
                              color: appColors[4],
                            )),
                        const SizedBox(
                          width: 8,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop("cancel");
                            },
                            icon: const Icon(Icons.check)),
                      ],
                    ),
                    CachedNetworkImage(
                      imageUrl: galleryData.url,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) {
                        return const Image(
                          image: AssetImage('assets/no_image.png'),
                          fit: BoxFit.cover,
                        );
                      },
                      progressIndicatorBuilder: (context, url, progress) {
                        return const CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    switch (result) {
      case "delete":
        if (index != -1) {
          FirebaseStorage.instance
              .refFromURL(currentUserData.user_gallery[index].url)
              .delete();
          currentUserData.user_gallery.removeAt(index);
        }
        break;
      case "save":
        if (index != -1) {
          currentUserData.user_gallery[index] = galleryData;
        } else {
          currentUserData.user_gallery.add(galleryData);
        }
        break;
      default:
    }

    await currentUserData.getConverter().set(currentUserData);

    return galleryData;
  }

  static Future<UserDataImage> addGalleryData(BuildContext context) async {
    UserDataImage userDataGallery = UserDataImage();

    String hashID = userDataGallery.id;
    String downloadUrl = userDataGallery.url;

    final pick = await ImagePicker().pickImage(source: ImageSource.gallery);

    File? file;

    if (pick != null) {
      file = File(pick.path);
      var imageBytes1 = file.hashCode;
      var bytes1 = utf8.encode(imageBytes1.toString()); // data being hashed
      var digest1 = sha256.convert(bytes1);

      hashID = digest1.toString();
    }

    if (file != null) {
      showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text("Uploading..."),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child('user/profile/${currentUserData.uid}/$hashID');
      UploadTask uploadTask = ref.putFile(file);

      await uploadTask.whenComplete(() async {
        downloadUrl = await ref.getDownloadURL();
      }).catchError((onError) {
        log(onError);
      });

      Navigator.pop(context);
    }

    userDataGallery.url = downloadUrl;

    currentUserData.user_gallery.add(userDataGallery);

    await currentUserData.getConverter().set(currentUserData);

    return userDataGallery;
  }

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void toBack() {
    Navigator.of(context).pop();
  }

  void toProfileEdit() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const ProfileEditPage()),
    );
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
                    "Profile",
                    style: TextStyle(color: appColors[3]),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () =>
                            ProfilePage.editAchivementData(context, -1),
                        icon: Icon(
                          Icons.playlist_add,
                          color: appColors[3],
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    IconButton(
                        onPressed: () => ProfilePage.addGalleryData(context),
                        icon: Icon(
                          Icons.add_photo_alternate_outlined,
                          color: appColors[3],
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    IconButton(
                        onPressed: toProfileEdit,
                        icon: Icon(
                          Icons.edit,
                          color: appColors[3],
                        )),
                  ],
                ),
                body: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StreamBuilder(
                        stream: UserData.Converter(uid).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            currentUserData = UserData.fromUID(uid);

                            if (snapshot.data!.data() != null) {
                              currentUserData = snapshot.data!.data()!;
                              currentUserData.uid = uid;
                            }

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ProfileHeaderSection(currentUserData),
                                ProfileAboutSection(currentUserData),
                                ProfileAchivementSection(currentUserData),
                                ProfileGallerySection(currentUserData),
                              ],
                            );
                          } else {
                            return Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                ))));
  }
}

class ProfileHeaderSection extends StatelessWidget {
  UserData userData;

  ProfileHeaderSection(this.userData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 96,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CachedNetworkImage(
                  imageUrl: userData.user_avatar.url,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return const Image(image: AssetImage('assets/avatar.png'));
                  },
                  progressIndicatorBuilder: (context, url, progress) {
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            const VerticalDivider(
              thickness: 1,
              width: 16,
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData.user_name,
                    style: textH2,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 4.0, bottom: 4.0, right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.sports_baseball,
                                size: 8,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                userData.type_sports,
                                style: textH3,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 4.0, bottom: 4.0, right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.sports,
                                size: 8,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                userData.type_role,
                                style: textH4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAboutSection extends StatelessWidget {
  UserData userData;

  ProfileAboutSection(this.userData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.profile_aboutme,
              style: textH3,
            ),
            const Divider(
              thickness: 1,
            ),
            Text(
              userData.user_about,
              style: textH4,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAchivementSection extends StatelessWidget {
  UserData userData;

  ProfileAchivementSection(this.userData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.profile_achivements,
              style: textH3,
            ),
            const Divider(
              thickness: 1,
            ),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: userData.user_achivements.length,
              itemBuilder: (context, index) {
                UserDataAchivement achivementData =
                    userData.user_achivements[index];
                return ProfileAchivementListItem(achivementData, index);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileGallerySection extends StatelessWidget {
  UserData userData;

  ProfileGallerySection(this.userData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.profile_galley,
              style: textH3,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 512,
              child: GridView.builder(
                  primary: false,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 160,
                      mainAxisExtent: 128,
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  itemCount: userData.user_gallery.length,
                  itemBuilder: (BuildContext ctx, index) {
                    UserDataImage galleryImage = userData.user_gallery[index];
                    return ProfileGalleryGridItem(galleryImage, index);
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileAchivementListItem extends StatelessWidget {
  UserDataAchivement achivementData;
  int index;

  ProfileAchivementListItem(this.achivementData, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            onPressed: () {
              ProfilePage.editAchivementData(context, index);
            },
            icon: const Icon(
              Icons.edit,
              size: 16,
            ),
          ),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                achivementData.title,
                style: textH3,
              ),
            ),
          ),
        ],
      ),
      collapsed: const SizedBox(),
      expanded: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            style: textH4,
            achivementData.description,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}

class ProfileGalleryGridItem extends StatelessWidget {
  UserDataImage galleryData;
  int index;

  ProfileGalleryGridItem(this.galleryData, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => ProfilePage.editGalleryData(context, index),
        child: CachedNetworkImage(
          imageUrl: galleryData.url,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) {
            return const Image(
              image: AssetImage('assets/no_image.png'),
              fit: BoxFit.cover,
            );
          },
          progressIndicatorBuilder: (context, url, progress) {
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
