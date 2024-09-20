import 'package:chat_app/Screens/chatlist1.dart';
import 'package:chat_app/Screens/searchuser.dart';
import 'package:chat_app/Screens/setting.dart';
import 'package:chat_app/provide/theme.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  BottomNav({super.key, this.whichscreen = 0});
  int whichscreen;

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // return BottomNavigationBar(
    //   currentIndex: widget.whichscreen,
    //   onTap: _selectPage,
    //   // elevation: 20,
    //   enableFeedback: true,
    //   backgroundColor: themeProvider.listcolor,
    //   unselectedItemColor: themeProvider.fontclr,
    //   selectedItemColor: themeProvider.isDarkMode ? Colors.green : Colors.white,
    //   selectedIconTheme: themeProvider.isDarkMode
    //       ? const IconThemeData(color: Colors.green)
    //       : const IconThemeData(color: Colors.white),
    //   unselectedIconTheme: IconThemeData(color: themeProvider.fontclr),
    //   items: const [
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         CupertinoIcons.chat_bubble,
    //       ),
    //       label: "Messages",
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         CupertinoIcons.settings,
    //       ),
    //       label: "Settings",
    //     ),
    //   ],
    // );
    return Container(
      color: themeProvider.isDarkMode
          ? themeProvider.listcolor
          : themeProvider.chngcolor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: GNav(
            gap: 15,
            // style: GnavStyle.google,
            tabActiveBorder: Border.all(color: Colors.black, width: 1.5),
            curve: Curves.easeInOut,
            haptic: true,
            selectedIndex: widget.whichscreen,
            onTabChange: _selectPage,
            tabBackgroundColor: themeProvider.isDarkMode
                ? themeProvider.chngcolor
                : Colors.transparent,
            backgroundColor: themeProvider.isDarkMode
                ? themeProvider.listcolor
                : themeProvider.chngcolor,
            iconSize: 25,
            padding: const EdgeInsets.all(15),
            color: themeProvider.fontclr,
            activeColor: themeProvider.isDarkMode
                ? Colors.green
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

    if (_selectedPageIndex == 1) {
      PageChange.changeScreen(
          context,
          SearchUser(
            screenno: 1,
          ));
    } else if (_selectedPageIndex == 2) {
      PageChange.changeScreen(
          context,
          Setting(
            screeno: 2,
          ));
    } else {
      PageChange.changeScreen(
          context,
          Chatlist1(
            screenno: 0,
          ));
    }
  }
}
