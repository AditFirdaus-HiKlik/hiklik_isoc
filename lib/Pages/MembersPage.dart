// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hiklik_sports/Classes/user.dart';
import 'package:hiklik_sports/config.dart';
import 'package:hiklik_sports/sports_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MembersPage extends StatefulWidget {
  UserData userData;

  MembersPage(this.userData, {super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  void toBack() {
    Navigator.of(context).pop();
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
                ),
                body: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StreamBuilder(
                        stream: widget.userData.getConverter().snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            widget.userData = snapshot.data!.data()!;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                MembersHeaderSection(widget.userData),
                                MembersAboutSection(widget.userData),
                                MembersAchivementSection(widget.userData),
                                MembersGallerySection(widget.userData),
                              ],
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                ))));
  }
}

class MembersHeaderSection extends StatelessWidget {
  UserData userData;

  MembersHeaderSection(this.userData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: Container(
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
                    return const CircularProgressIndicator();
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData.user_name,
                    style: textH3,
                  ),
                  const SizedBox(
                    height: 4,
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
                                width: 8,
                              ),
                              Text(
                                userData.type_sports,
                                style: textH4,
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

class MembersAboutSection extends StatelessWidget {
  UserData userData;

  MembersAboutSection(this.userData, {super.key});

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

class MembersAchivementSection extends StatelessWidget {
  UserData userData;

  MembersAchivementSection(this.userData, {super.key});

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
              primary: false,
              shrinkWrap: true,
              itemCount: userData.user_achivements.length,
              itemBuilder: (context, index) {
                UserDataAchivement achivementData =
                    userData.user_achivements[index];
                return MembersAchivementListItem(achivementData);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MembersGallerySection extends StatelessWidget {
  UserData userData;

  MembersGallerySection(this.userData, {super.key});

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
                    return MembersGalleryGridItem(galleryImage);
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class MembersAchivementListItem extends StatelessWidget {
  UserDataAchivement achivementData;

  MembersAchivementListItem(this.achivementData, {super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            achivementData.title,
            style: textH3,
          ),
        ),
      ),
      collapsed: const SizedBox(),
      expanded: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                achivementData.description,
                style: textH4,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MembersGalleryGridItem extends StatelessWidget {
  UserDataImage galleryData;

  MembersGalleryGridItem(this.galleryData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.hardEdge,
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
                        return const Center(child: SizedBox(width: 48, height: 48, child: CircularProgressIndicator()));
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
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
            return Center(child: const CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
