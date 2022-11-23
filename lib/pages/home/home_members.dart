
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hiklik_sports/Classes/content.dart';
import 'package:hiklik_sports/Classes/user.dart';
import 'package:hiklik_sports/pages/members_page.dart';
import 'package:hiklik_sports/sports_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeMembers extends StatefulWidget {
  const HomeMembers({super.key});

  static void toMembersPage(BuildContext context, UserData userData) {
    Navigator.of(context).push(PageTransition(
      type: PageTransitionType.size,
      curve: Curves.easeInOutQuart,
      childCurrent: context.widget,
      alignment: Alignment.bottomCenter,
      child: MembersPage(userData),
      duration: const Duration(milliseconds: 500),
    ));
  }

  @override
  State<HomeMembers> createState() => _HomeMembersState();
}

class _HomeMembersState extends State<HomeMembers> {
  static String valueSport = "";
  static String valueRole = "";

  Future<QuerySnapshot<Map<String, dynamic>>> getMemberStream() async {
    var ref = FirebaseFirestore.instance.collection("users");

    Query<Map<String, dynamic>> query = ref;
    
    query = query.limit(50);

    if (valueSport != "") {
      query = query.where("type_sports", isEqualTo: valueSport);
    }

    if (valueRole != "") {
      query = query.where("type_role", isEqualTo: valueRole);
    }


    return query.get();
  }

  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 64,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: DropdownButton2(
                            buttonPadding: const EdgeInsets.all(16),
                            isExpanded: true,
                            value: valueSport,
                            items: [
                              DropdownMenuItem<String>(
                                value: "",
                                child: Text(
                                  "All Sports",
                                  style: textH3,
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "anggar",
                                child: Text(
                                  "Anggar",
                                  style: textH3,
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "basket",
                                child: Text(
                                  "Basket",
                                  style: textH3,
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "volley",
                                child: Text(
                                  "Volley",
                                  style: textH3,
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                valueSport = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: DropdownButton2(
                            buttonPadding: const EdgeInsets.all(16),
                            isExpanded: true,
                            value: valueRole,
                            items: [
                              DropdownMenuItem<String>(
                                value: "",
                                child: Text(
                                  "All Roles",
                                  style: textH3,
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "coach",
                                child: Text(
                                  "Coach",
                                  style: textH3,
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "athlete",
                                child: Text(
                                  "Athlete",
                                  style: textH3,
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "participant",
                                child: Text(
                                  "Participant",
                                  style: textH3,
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                valueRole = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    AppLocalizations.of(context)!.home_members,
                    style: textH1,
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  FutureBuilder(
                      future: getMemberStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          cachedMember = snapshot.data!.docs
                              .map((e) => UserData.fromJson(e.data()))
                              .toList();
                          return ListView.builder(
                              clipBehavior: Clip.hardEdge,
                              itemCount: cachedMember.length,
                              shrinkWrap: true,
                              primary: false,
                              itemExtent: 128,
                              itemBuilder: (context, index) {
                                return MemberCard(cachedMember[index]);
                              });
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ]
              )
            )
          );
  }
}

class MemberCard extends StatelessWidget {
  final UserData _userData;

  const MemberCard(this._userData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => HomeMembers.toMembersPage(context, _userData),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: CachedNetworkImage(
                    width: 96,
                    height: 96,
                    imageUrl: _userData.user_avatar.url,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return const Image(image: AssetImage('assets/avatar.png'));
                    },
                    progressIndicatorBuilder: (context, url, progress) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                const VerticalDivider(
                  thickness: 1,
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userData.user_name,
                      style: textH4,
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
                                  _userData.type_sports,
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
                                  _userData.type_role,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
