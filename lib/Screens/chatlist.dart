import 'package:flutter/material.dart';

class Chatlist extends StatelessWidget {
  const Chatlist({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatMate"),
      ),
      body: const Center(
        child: Text("Logged in"),
      ),
    );
  }
}
