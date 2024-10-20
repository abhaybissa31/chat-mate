import 'package:chat_app/widget/bottomnav.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  Setting({super.key, this.screeno});
  var screeno;
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
