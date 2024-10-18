import 'package:chat_app/Screens/chatlist.dart';
import 'package:chat_app/Screens/chatmsg.dart';
import 'package:chat_app/controller/chatcontroller.dart';
import 'package:chat_app/provide/theme.dart';
import 'package:chat_app/widget/bottomnav.dart';
import 'package:chat_app/widget/chatbox.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key, required this.screenno});
  final int screenno;
  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  String name = '';
  bool hasPrinted = false;

  @override
  Widget build(BuildContext context) {
    Chatcontroller chatController = Chatcontroller();

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
            statusBarIconBrightness: themeProvider.isDarkMode == true
                ? Brightness.light
                : Brightness.dark, // Correct property for status bar icons
            statusBarColor: themeProvider.chngcolor, // Change status bar color
            systemNavigationBarIconBrightness: themeProvider.isDarkMode == true
                ? Brightness.light
                : Brightness.dark, // Still applies to navigation bar icons
          ),
          // backgroundColor: Colors.yellow,
        ),
      ),
      bottomNavigationBar: const BottomNav(
        whichscreen: 1,
      ),
      backgroundColor: themeProvider.chngcolor,
      body: Column(
        children: [
          // Header section with icon, avatar, and title
          Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 20, 45, 20),
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
                    PageChange.changeScreen(
                        context,
                        const Chatlist1(
                          screenno: 1,
                        ));
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
                        borderSide: BorderSide(),
                      ),
                    ),
                    onChanged: (value) => {
                      setState(() {
                        name = value;
                      })
                    },
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
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
              decoration: BoxDecoration(
                color: themeProvider
                    .listcolor, // Softer grey color for better visibility
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(80.0), // Adjust the radius as needed
                  topRight: Radius.circular(80.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .snapshots(),
                  builder: (context, snapshots) {
                    if (snapshots.connectionState == ConnectionState.waiting ||
                        snapshots.connectionState == ConnectionState.none) {
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.purple,
                        ),
                      );
                    } else {
                      // Check if there are no documents
                      if (snapshots.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No user found',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        );
                      } else {
                        bool userFound = false;

                        return ListView.builder(
                          itemCount: snapshots.data!.docs.length > 10
                              ? 10
                              : snapshots.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index].data()
                                as Map<String, dynamic>;

                            if (name.isEmpty) {
                              userFound = true; // User found in the list
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    String roomID =
                                        chatController.getRoomId(data['id']);
                                    print(roomID);
                                    PageChange.changeScreen(
                                      context,
                                      ChatMessageScreen(
                                        recEmail: data['email'],
                                        recId: data['id'],
                                        senderId: auth.currentUser!.uid,
                                        recImageUrl: data['image_url']
                                                .toString()
                                                .isEmpty
                                            ? "lib/assets/images/1.jpg" // Pass this only if you handle it as an asset
                                            : data['image_url'],
                                        recUname: data['username'],
                                        chatMessageNavigatedFrom:
                                            ChatMessageNavigatedFrom.searchuser,
                                      ),
                                    );
                                  },
                                  child: ChatBox(
                                    boxtype: BoxType.searchUser,
                                    uname: data['username'],
                                    lastMsg: data['email'],
                                    url: data['image_url'].toString().isEmpty
                                        ? "lib/assets/images/1.jpg"
                                        : data['image_url'],
                                  ),
                                ),
                              );
                            } else if (data['username']
                                .toString()
                                .toLowerCase()
                                .startsWith(name.toLowerCase())) {
                              userFound = true; // User found in the search
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () async => PageChange.changeScreen(
                                    context,
                                    ChatMessageScreen(
                                      recEmail: data['email'],
                                      recId: data['id'],
                                      senderId: auth.currentUser!.uid,
                                      recImageUrl: data['image_url']
                                              .toString()
                                              .isEmpty
                                          ? "lib/assets/images/1.jpg" // Pass this only if you handle it as an asset
                                          : data['image_url'],
                                      recUname: data['username'],
                                      chatMessageNavigatedFrom:
                                          ChatMessageNavigatedFrom.searchuser,
                                    ),
                                  ),
                                  child: ChatBox(
                                    boxtype: BoxType.searchUser,
                                    uname: data['username'],
                                    lastMsg: data['email'],
                                    url: data['image_url'].toString().isEmpty
                                        ? "lib/assets/images/1.jpg"
                                        : data['image_url'],
                                  ),
                                ),
                              );
                            }

                            // After all users are checked, show "No user found"
                            if (index == snapshots.data!.docs.length - 1 &&
                                !userFound) {
                              return const Center(
                                heightFactor: 25,
                                child: Text(
                                  'No user found',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              );
                            }
                            return const SizedBox(); // If not a match, return empty widget
                          },
                        );
                      }
                    }
                  },
                ),
              ),

              // child: ListView.builder(
              //   padding: const EdgeInsets.all(25.0),
              //   itemCount: 10,
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 8.0),
              //       child: Text(
              //         "Message ${(index + 1)}",
              //         style: TextStyle(
              //           fontSize: 16,
              //           color: themeProvider.fontclr,
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
