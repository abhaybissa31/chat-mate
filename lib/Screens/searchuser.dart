import 'package:chat_app/Screens/chatlist.dart';
import 'package:chat_app/Screens/chatmsg.dart';
import 'package:chat_app/controller/chatcontroller.dart';
import 'package:chat_app/provider/theme.dart';
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
  bool userFound = false;
  int userSearchLimit = 10;

  @override
  Widget build(BuildContext context) {
    Chatcontroller chatController = Chatcontroller();
    final themeProvider = Provider.of<ThemeProvider>(context);

    void searchMoreUsers() {
      // Use Future.microtask to delay setState until after the current build phase
      Future.microtask(() {
        setState(() {
          userSearchLimit += 10; // Increase the limit by 10
        });
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
            statusBarColor: themeProvider.chngcolor,
            systemNavigationBarIconBrightness:
                themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(whichscreen: 1),
      backgroundColor: themeProvider.chngcolor,
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didpop, idk) {
          if (didpop) {
            print('$didpop popped');
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        },
        child: Column(
          children: [
            // Header with search field
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 20, 45, 20),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(CupertinoIcons.arrow_uturn_left,
                        color: themeProvider.fontclr, size: 30),
                    onPressed: () {
                      PageChange.changeScreen(
                        context,
                        const Chatlist1(screenno: 1),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search_sharp,
                            color: themeProvider.listcolor),
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: themeProvider.fontclr),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                          userSearchLimit =
                              10; // Reset limit when a new search begins
                          userFound = false;
                        });
                      },
                      style: TextStyle(
                          color: themeProvider.listcolor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // User list section
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                decoration: BoxDecoration(
                  color: themeProvider.listcolor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                    topRight: Radius.circular(80.0),
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: StreamBuilder<QuerySnapshot?>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .orderBy("username")
                          .limit(userSearchLimit)
                          .snapshots(),
                      builder: (context, snapshots) {
                        // Reset userFound to false at the beginning of each build
                        userFound = false;

                        // Show loading indicator if the connection is still in progress
                        if (snapshots.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        // Handle errors in the stream
                        if (snapshots.hasError) {
                          return Center(
                              child: Text('An error occurred',
                                  style: TextStyle(
                                      color: themeProvider.fontclr,
                                      fontSize: 20)));
                        }

                        // Check if there is data and if the list of documents is empty
                        if (!snapshots.hasData ||
                            snapshots.data == null ||
                            snapshots.data!.docs.isEmpty) {
                          if (name.isNotEmpty) {
                            Future.microtask(() => searchMoreUsers());
                          }

                          return Center(
                              child: Text('No user found😔',
                                  style: TextStyle(
                                      color: themeProvider.fontclr,
                                      fontSize: 20)));
                        }

                        // If documents exist, build the list
                        return ListView.builder(
                          itemCount: snapshots.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index].data()
                                as Map<String, dynamic>;

                            if (data['id'] == auth.currentUser!.uid) {
                              return Container(); // Skip the current user
                            }

                            if (name.isEmpty ||
                                data['username']
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(name.toLowerCase())) {
                              userFound = true;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    String roomID =
                                        chatController.getRoomId(data['id']);
                                    PageChange.changeScreen(
                                      context,
                                      ChatMessageScreen(
                                        recEmail: data['email'],
                                        recId: data['id'],
                                        senderId: auth.currentUser!.uid,
                                        recImageUrl: data['image_url'].isEmpty
                                            ? "lib/assets/images/robot1.png"
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
                                    url: data['image_url'].isEmpty
                                        ? ""
                                        : data['image_url'],
                                  ),
                                ),
                              );
                            }

                            // Automatically load more users if none match and reach the end of the list
                            if (index == snapshots.data!.docs.length - 1 &&
                                !userFound) {
                              Future.microtask(() => searchMoreUsers());
                            }

                            return const SizedBox();
                          },
                        );
                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
