import 'package:chat_app/widget/bottomnav.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({super.key, required this.screeno});
  final int screeno;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: BottomNav(
        whichscreen: 2,
      ),
      body: Center(
        child: Text("data"),
      ),
    );
  }
}
