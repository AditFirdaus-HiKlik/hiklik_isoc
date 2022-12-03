import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:isoc/pages/auth/sign_in_page.dart';
import 'package:isoc/pages/auth/sign_up_page.dart';
import 'package:isoc/pages/auth_tree.dart';
import 'package:isoc/pages/auth/verification_page.dart';
import 'package:isoc/locale_provider.dart';
import 'package:isoc/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:isoc/l10n/l10n.dart';
import 'package:isoc/services/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  log("Starting Application...", name: "main.dart");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  log("Create Splash...", name: "main.dart");
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  log("Initialize Firebase...", name: "main.dart");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  log("Initialize SharedPreferences...", name: "main.dart");
  await initializeSharedPreferences();
  
  // log("Initialize PaymentService...", name: "main.dart");
  // await PaymentService.instance.initConnection();

  log("Running App...", name: "main.dart");
  runApp(const MyApp());

  log("Removing Splash...", name: "main.dart");
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        return MaterialApp(
          title: 'Indonesia Sports and Olympic Community',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: provider.locale,
          supportedLocales: L10n.all,
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const AuthTree(),
            '/signIn': (context) => const SignInPage(),
            '/signUp': (context) => const SignUpPage(),
            '/verification': (context) => const VerificationPage(),
          },
        );
      },
    );
  }
}
