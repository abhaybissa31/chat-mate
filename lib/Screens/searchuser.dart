import 'package:chat_app/Screens/chatlist1.dart';
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
                .statusbariconcolor, // Correct property for status bar icons
            statusBarColor: themeProvider.chngcolor, // Change status bar color
            systemNavigationBarIconBrightness: themeProvider
                .statusbariconcolor, // Still applies to navigation bar icons
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
              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
              decoration: BoxDecoration(
                color: themeProvider
                    .listcolor, // Softer grey color for better visibility
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(80.0), // Adjust the radius as needed
                  topRight: Radius.circular(80.0),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState ==
                                ConnectionState.waiting ||
                            snapshots.connectionState == ConnectionState.none)
                        ? Center(
                            child: Center(
                              child: Text(
                                "No users found",
                                style: TextStyle(color: themeProvider.fontclr),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: snapshots.data!.docs.length > 10
                                ? 10
                                : snapshots.data!.docs.length,
                            itemBuilder: (context, index) {
                              var data = snapshots.data!.docs[index].data()
                                  as Map<String, dynamic>;
                              if (name.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ChatBox(
                                    boxtype: BoxType.searchUser,
                                    uname: data['username'],
                                    lastMsg: data['email'],
                                    url: data['image_url'],
                                  ),
                                );
                                // return ListTile(
                                //   title: Text(
                                //     data['username'] ??
                                //         'No Username', // Fallback value if 'username' is null
                                //     maxLines: 1,
                                //     overflow: TextOverflow.ellipsis,
                                //     style: TextStyle(
                                //         color: themeProvider.fontclr,
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.bold),
                                //   ),
                                //   subtitle: Text(
                                //     data['email'] ??
                                //         'No Email', // Fallback value if 'email' is null
                                //     maxLines: 1,
                                //     overflow: TextOverflow.ellipsis,
                                //     style: const TextStyle(
                                //         color: Colors.grey,
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.bold),
                                //   ),
                                //   leading: CircleAvatar(
                                //     radius: 40,
                                //     backgroundImage: data['image_url'] != null
                                //         ? NetworkImage(data[
                                //             'image_url']) // If 'image_url' is present
                                //         : const AssetImage(
                                //             'assets/default_avatar.png'), // Default image if null
                                //   ),
                                // );
                              }
                              if (data['username']
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(name.toLowerCase())) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ChatBox(
                                    boxtype: BoxType.searchUser,
                                    uname: data['username'],
                                    lastMsg: data['email'],
                                    url: data['image_url'],
                                  ),
                                );
                                // return ListTile(
                                //   title: Text(
                                //     data['username'],
                                //     maxLines: 1,
                                //     overflow: TextOverflow.ellipsis,
                                //     style: TextStyle(
                                //         color: themeProvider.fontclr,
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.bold),
                                //   ),
                                //   subtitle: Text(
                                //     data['email'],
                                //     maxLines: 1,
                                //     overflow: TextOverflow.ellipsis,
                                //     style: const TextStyle(
                                //         color: Colors.grey,
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.bold),
                                //   ),
                                //   leading: CircleAvatar(
                                //     radius: 40,
                                //     backgroundImage:
                                //         NetworkImage(data['image_url']),
                                //   ),
                                // );
                              } else {
                                return Container();
                              }
                            });
                  }),
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
