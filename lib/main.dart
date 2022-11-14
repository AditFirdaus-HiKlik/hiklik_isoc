import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hiklik_sports/AuthTree.dart';
import 'package:hiklik_sports/LocaleProvider.dart';
import 'package:hiklik_sports/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hiklik_sports/l10n/l10n.dart';
import 'package:hiklik_sports/sports_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  sharedPreferences = await SharedPreferences.getInstance();

  runApp(const MyApp());

  await Future.delayed(const Duration(seconds: 1));

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
          title: 'HiKlik Sports',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: provider.locale,
          supportedLocales: L10n.all,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const AuthTree(),
        );
      },
    );
  }
}
