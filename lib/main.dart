import 'package:diet_tracker_app/Views/main_page.dart';
import 'package:diet_tracker_app/Views/signin_page.dart';
import 'package:diet_tracker_app/theme.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:theme_provider/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final user = FirebaseAuth.instance.currentUser!;
String useremail = '';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDfQoX0ZmpAzigVE30vZ8yMhU3fula97dc",
          authDomain: "diettracker-d061a.firebaseapp.com",
          projectId: "diettracker-d061a",
          storageBucket: "diettracker-d061a.appspot.com",
          messagingSenderId: "183710461138",
          appId: "1:183710461138:web:4b225e3ffa3c14f0c2110b"));
  // ignore: prefer_const_constructors
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        String? savedTheme = await previouslySavedThemeFuture;

        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          controller.setTheme("default_light");
        }
      },
      themes: myThemes,
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              // DefaultCupertinoLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('da', ''),
            ],
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.themeOf(themeContext).data,
            home: const HomePage(),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Fejl'));
          } else if (snapshot.hasData) {
            user.email != null ? useremail = user.email! : useremail = '';
            return const MainPage();
          } else {
            return const SignInPage();
          }
        },
      ),
    );
  }
}
