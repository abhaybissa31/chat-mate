import 'package:chat_app/Screens/chatlist.dart';
import 'package:chat_app/Screens/searchuser.dart';
import 'package:chat_app/Screens/setting.dart';
import 'package:chat_app/provider/theme.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key, required this.whichscreen});
  final int whichscreen;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedPageIndex =
        widget.whichscreen; // Initialize with the provided screen
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      color: themeProvider.isDarkMode
          ? themeProvider.listcolor
          : themeProvider.chngcolor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: GNav(
            gap: 15,
            tabActiveBorder: Border.all(color: Colors.black, width: 1),
            curve: Curves.easeInOut,
            haptic: true,
            selectedIndex: _selectedPageIndex, // Use the state value here
            onTabChange: _selectPage, // Update the tab change logic
            tabBackgroundColor: themeProvider.isDarkMode
                ? const Color.fromARGB(255, 20, 20, 20)
                : Colors.transparent,
            backgroundColor: themeProvider.isDarkMode
                ? themeProvider.listcolor
                : themeProvider.chngcolor,
            iconSize: 25,
            padding: const EdgeInsets.all(15),
            color: themeProvider.fontclr,
            activeColor: themeProvider.isDarkMode
                ? Colors.purple
                : const Color.fromARGB(255, 75, 29, 29),
            tabs: const [
              GButton(
                icon: CupertinoIcons.chat_bubble,
                text: "Messages",
              ),
              GButton(
                icon: CupertinoIcons.person_3_fill,
                text: "People",
              ),
              GButton(
                icon: CupertinoIcons.settings,
                text: "Settings",
              )
            ]),
      ),
    );
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });

    // Handle navigation after updating the state
    if (index == 1) {
      PageChange.changeScreen(
          context,
          const SearchUser(
            screenno: 1,
          ));
    } else if (index == 2) {
      PageChange.changeScreen(
          context,
          const Setting(
            screeno: 2,
          ));
    } else {
      PageChange.changeScreen(
          context,
          const Chatlist1(
            screenno: 0,
          ));
    }
  }
}
