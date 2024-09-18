import 'package:chat_app/Screens/chatlist1.dart';
import 'package:chat_app/provide/theme.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key});
  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  @override
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    void initState() {
      super.initState();
      themeProvider.toggleTheme();
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0), // Set height to 0
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: themeProvider
                .statusbariconcolor, // Use global status bar icon brightness
            statusBarColor: themeProvider.chngcolor,
          ),
          backgroundColor: Colors.yellow,
        ),
      ),
      backgroundColor: themeProvider.chngcolor,
      body: Column(
        children: [
          // Header section with icon, avatar, and title
          Padding(
            padding: EdgeInsets.fromLTRB(5.0, 20, 45, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    CupertinoIcons.arrow_uturn_left,
                    color: themeProvider.fontclr,
                    size: 30,
                  ),
                  onPressed: () {
                    PageChange.changeScreen(context, Chatlist1());
                  },
                ),
                const SizedBox(
                    width: 10), // Add spacing between icon and search bar
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search_sharp,
                        color: themeProvider.listcolor,
                      ),
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: themeProvider.fontclr),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: themeProvider.fontclr),
                  ),
                ),
              ],
            ),
          ),

          // Chat messages section
          Expanded(
            flex: 16,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
              decoration: BoxDecoration(
                color: themeProvider
                    .listcolor, // Softer grey color for better visibility
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(80.0), // Adjust the radius as needed
                  topRight: Radius.circular(80.0),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(25.0),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Message ${(index + 1)}",
                      style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.fontclr,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
