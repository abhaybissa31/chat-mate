import 'package:chat_app/Screens/chatlist.dart';
import 'package:chat_app/Screens/splashscreen.dart';
import 'package:chat_app/provider/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:provider/provider.dart' as provider;

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    riverpod.ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(create: (context) => ThemeProvider()),
          // Add other providers here if needed
        ],
        child: const App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("lib/assets/images/final.jpg"), context);
    precacheImage(const AssetImage("lib/assets/images/chat2.png"), context);
    precacheImage(const AssetImage("lib/assets/images/robot1.png"), context);
    precacheImage(const AssetImage("lib/assets/images/shadow.png"), context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatMate',
      // theme: ThemeData().copyWith(
      //   colorScheme: ColorScheme.fromSeed(
      //       seedColor: const Color.fromARGB(255, 63, 17, 177)),
      // ),
      //
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              return const Chatlist1(
                screenno: 0,
              );
            }
            return const SplashScreen();
          }),
    );
  }
}
