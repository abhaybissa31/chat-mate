import 'package:chat_app/Screens/splashscreen.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatlist extends StatelessWidget {
  const Chatlist({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("ChatMate"),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).clearMaterialBanners();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.black,
                  content: Text("Logged out"),
                ),
              );
              PageChange.changeScreen(context, const SplashScreen());
            },
            icon: const Icon(Icons.exit_to_app),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
      body: const Center(
        child: Text("Logged in"),
      ),
    );
  }
}
