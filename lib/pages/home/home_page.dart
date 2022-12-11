// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:isoc/Classes/content.dart';
import 'package:isoc/Classes/user.dart';
import 'package:isoc/Pages/Auth/sign_in_page.dart';
import 'package:isoc/Pages/home/home_events.dart';
import 'package:isoc/Pages/home/home_locations.dart';
import 'package:isoc/Pages/home/home_members.dart';
import 'package:isoc/Pages/home/home_news.dart';
import 'package:isoc/Pages/home/home_stream.dart';
import 'package:isoc/Pages/profile_page.dart';
import 'package:isoc/Pages/settings_page.dart';
import 'package:isoc/app/app_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void toSettings() async {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );

    setState(() {
      fetchAllTabs();
    });
  }

  void toProfile() {
    if (isUserSignIn()) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllTabs();
  }

  Future fetchAllTabs() async {
    await fetchAll();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColors[0],
          elevation: 1,
          // leading: PopupMenuButton(
          //   onSelected: (value) {
          //     switch (value) {
          //       case "Profile":
          //         toProfile();
          //         break;
          //       case "Settings":
          //         toSettings();
          //         break;
          //       default:
          //     }
          //   },
          //   icon: Icon(
          //     Icons.menu,
          //     color: appColors[3],
          //   ),
          //   shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //       bottomLeft: Radius.circular(8.0),
          //       bottomRight: Radius.circular(8.0),
          //       topLeft: Radius.circular(8.0),
          //       topRight: Radius.circular(8.0),
          //     ),
          //   ),
          //   itemBuilder: (context) {
          //     return [
          //       PopupMenuItem(
          //         value: "Profile",
          //         child: Row(
          //           children: [
          //             const Icon(
          //               Icons.person,
          //               color: Colors.black,
          //             ),
          //             const SizedBox(
          //               width: 16,
          //             ),
          //             Text(AppLocalizations.of(context)!.profile),
          //           ],
          //         ),
          //       ),
          //       PopupMenuItem(
          //         value: "Settings",
          //         child: Row(
          //           children: [
          //             const Icon(
          //               Icons.settings,
          //               color: Colors.black,
          //             ),
          //             const SizedBox(
          //               width: 16,
          //             ),
          //             Text(AppLocalizations.of(context)!.settings),
          //           ],
          //         ),
          //       ),
          //     ];
          //   },
          // ),
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
        drawer: DrawerWidget(),
      ),
    );
  }
}

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Future toProfile() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  Future toSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  Future toSignOut() async {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _drawerHeader(),
          _drawerItem(
            icon: Icons.person,
            text: 'My Profile',
            onTap: toProfile,
          ),
          _drawerItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: toSettings,
          ),
          if (isUserSignIn()) _drawerItem(
            icon: Icons.exit_to_app,
            text: 'Sign Out',
            onTap: toSignOut,
          ),
        ],
      ),
    );
  }

  Widget _drawerHeader() {
    return isUserSignIn() ? UserAccountsDrawerHeader(
      currentAccountPicture: ClipOval(
        child: Image.network(currentUserData.user_avatar.url),
      ),
      accountName: Text(currentUserData.user_name),
      accountEmail: Text(currentUserData.user_email),
    ) : UserAccountsDrawerHeader(
      currentAccountPicture: ClipOval(
        child: Image.asset("avatar.png"),
      ),
      accountName: const Text('Sign In'),
      accountEmail: const Text('To view your account'),
    );
  }

  Widget _drawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final String label;
  final IconData iconData;
  final void Function() onPressed;
  final Color color;
  final Color backgroundColor;

  const QuickActionButton(this.label, this.iconData, this.onPressed, this.color,
      this.backgroundColor,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          shadowColor: Colors.transparent),
      child: SizedBox(
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: color,
            ),
            Text(
              label,
              style: TextStyle(
                  color: color, fontSize: 8, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
