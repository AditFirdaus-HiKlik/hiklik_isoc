// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:isoc/Classes/content.dart';
import 'package:isoc/Pages/home/home_events.dart';
import 'package:isoc/Pages/home/home_locations.dart';
import 'package:isoc/Pages/home/home_members.dart';
import 'package:isoc/Pages/home/home_news.dart';
import 'package:isoc/Pages/home/home_stream.dart';
import 'package:isoc/Pages/profile_page.dart';
import 'package:isoc/Pages/settings_page.dart';
import 'package:isoc/app/app_config.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void toSettings() async {
    await Navigator.of(context).push(PageTransition(
      type: PageTransitionType.size,
      curve: Curves.easeInOutQuart,
      childCurrent: widget,
      alignment: Alignment.bottomCenter,
      child: const SettingsPage(),
      duration: const Duration(milliseconds: 500),
    ));

    setState(() {
      fetchAllTabs();
    });
  }

  void toProfile() {
    Navigator.of(context).push(PageTransition(
      type: PageTransitionType.size,
      curve: Curves.easeInOutQuart,
      childCurrent: widget,
      alignment: Alignment.bottomCenter,
      child: const ProfilePage(),
      duration: const Duration(milliseconds: 500),
    ));
  }

  @override
  void initState() {
    super.initState();
    fetchAllTabs();
  }

  Future fetchAllTabs() async {
    await fetchAll();

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColors[0],
          elevation: 1,
          leading: PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case "Profile":
                  toProfile();
                  break;
                case "Settings":
                  toSettings();
                  break;
                default:
              }
            },
            icon: Icon(
              Icons.menu,
              color: appColors[3],
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "Profile",
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(AppLocalizations.of(context)!.profile),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "Settings",
                  child: Row(
                    children: [
                      const Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(AppLocalizations.of(context)!.settings),
                    ],
                  ),
                ),
              ];
            },
          ),
          title: Image.asset(
            "assets/header.png",
            height: 32,
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            clipBehavior: Clip.none,
            children: [
              HomeNews(),
              HomeEvents(),
              HomeMembers(),
              HomeLocations(),
              HomeStream(),
            ],
          ),
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(16),
          height: 72,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 8),
            ],
            color: Color(0xFF2D3436),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 8,
              right: 8,
            ),
            child: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              tabs: [
                Tab(
                  icon: const Icon(Icons.newspaper),
                  text: AppLocalizations.of(context)!.news,
                ),
                Tab(
                  icon: const Icon(Icons.calendar_month),
                  text: AppLocalizations.of(context)!.events,
                ),
                Tab(
                  icon: const Icon(Icons.card_membership),
                  text: AppLocalizations.of(context)!.members,
                ),
                Tab(
                  icon: const Icon(Icons.location_on),
                  text: AppLocalizations.of(context)!.locations,
                ),
                const Tab(
                  icon: Icon(Icons.broadcast_on_home),
                  text: "Streams",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
