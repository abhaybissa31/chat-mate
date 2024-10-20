import 'package:chat_app/Screens/chatmsg.dart';
import 'package:chat_app/Screens/splashscreen.dart';
import 'package:chat_app/controller/chatcontroller.dart';
import 'package:chat_app/model/chatroom.dart';
import 'package:chat_app/provide/theme.dart';
import 'package:chat_app/widget/bottomnav.dart';
import 'package:chat_app/widget/chatbox.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Chatlist1 extends StatefulWidget {
  const Chatlist1({super.key, required this.screenno});
  final int screenno;

  @override
  State<Chatlist1> createState() => _Chatlist1State();
}

class _Chatlist1State extends State<Chatlist1> {
  Chatcontroller chatController = Chatcontroller();
  List<ChatRoomModel> chatRoomDetails = [];

  String displayName =
      "Abhay bissa is jere hehehehe and some more words to test the word limit of twelve"
          .substring(0, 12);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatController.retrieveRoomDetailsStreamForCurrentUser();
    _loadChatRooms();
  }

  Future<void> _loadChatRooms() async {
    // chatRoomDetails = await chatController.retrieveRoomDetailsStreamForCurrentUser();
    setState(() {
      // Update UI if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the global theme provider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Material(
      child: Scaffold(
        backgroundColor: themeProvider.chngcolor, // Use global background color
        appBar: AppBar(
          backgroundColor: themeProvider.chngcolor, // Use global app bar color
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: themeProvider.isDarkMode
                ? Colors.purple
                : themeProvider.chngcolor,
            statusBarIconBrightness: themeProvider.isDarkMode == true
                ? Brightness.light
                : Brightness.dark, // Correct property for status bar icons
            statusBarColor: themeProvider.chngcolor, // Change status bar color
            systemNavigationBarIconBrightness: themeProvider.isDarkMode == true
                ? Brightness.light
                : Brightness.dark, // Still applies to navigation bar icons
          ),
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            "Messages",
            style: TextStyle(color: Colors.purple),
          ),
          actions: [
            IconButton(
              enableFeedback: true,
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
              color: Colors.purple,
            ),
            IconButton(
              enableFeedback: true,
              onPressed: () {
                themeProvider.toggleTheme(); // Toggle the global theme
              },
              icon: themeProvider.themeicon, // Use global theme icon
            )
          ],
        ),
        bottomNavigationBar: const BottomNav(
          whichscreen: 0,
        ),
        // body: chatRoomDetails.isNotEmpty
        //     ? ListView.builder(
        //         itemCount: chatRoomDetails.length,
        //         itemBuilder: (context, index) {
        //           final room = chatRoomDetails[index];
        //           return ListTile(
        //             leading: room.recImage!.isNotEmpty
        //                 ? Image.network(room.recImage!)
        //                 : CircleAvatar(
        //                     child: Icon(Icons
        //                         .person), // You can customize this as needed
        //                   ),
        //             title: Text(room.receiverUserName!),
        //             subtitle: Text(room.lastMessage!),
        //             trailing: Text(room.lastMessageTimestamp!),
        //           );
        //         },
        //       )
        //     : Center(child: Text('No chat rooms found')),

        body: Container(
          decoration: BoxDecoration(
              color: themeProvider.chngcolor), // Global background color
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                        child: Text(
                          "Recent",
                          style: TextStyle(
                              color: themeProvider.fontclr,
                              fontSize: 18), // Global font color
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 110,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(7, 5, 25, 0),
                              child: GestureDetector(
                                onTap: () async => PageChange.changeScreen(
                                    context,
                                    const ChatMessageScreen(
                                      recId: "",
                                      senderId: "",
                                      recEmail: 'bissa',
                                      recImageUrl: 'lib/assets/images/1.jpg',
                                      recUname: 'itsabhay yo boi',
                                      chatMessageNavigatedFrom:
                                          ChatMessageNavigatedFrom.chatlist,
                                    )),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: CircleAvatar(
                                        radius: 38,
                                        backgroundColor: themeProvider
                                            .chngcolor, // Avatar background based on theme
                                        foregroundImage: const AssetImage(
                                            "lib/assets/images/1.jpg"),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.center,
                                      width:
                                          100, // Set width to control wrapping
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            6, 0, 0, 0),
                                        child: Text(
                                          overflow: TextOverflow.clip,
                                          displayName, // Display only the first 12 words
                                          style: TextStyle(
                                              color: themeProvider.fontclr,
                                              fontSize:
                                                  16), // Global font color
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(80),
                      topRight: Radius.circular(80),
                    ),
                    color:
                        themeProvider.listcolor, // Global list background color
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(19.0, 19, 19, 0),
                    child: StreamBuilder<List<ChatRoomModel>>(
                      stream: chatController
                          .retrieveRoomDetailsStreamForCurrentUser(),
                      builder: (context,
                          AsyncSnapshot<List<ChatRoomModel>> snapshot) {
                        // Check if the connection is still active or the data is being fetched
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child:
                                  CircularProgressIndicator()); // Show loading spinner
                        }

                        // Check if there's any error
                        if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}"));
                        }

                        // Check if there's any data
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                              child: Text(
                            'No chat found. Start a new chat?',
                            style: TextStyle(color: themeProvider.fontclr),
                          ));
                        }

                        // Extract chat room details from the snapshot
                        List<ChatRoomModel> chatRoomDetails = snapshot.data!;

                        return ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          itemCount: chatRoomDetails.length,
                          itemBuilder: (context, index) {
                            final room = chatRoomDetails[index];

                            // Determine the username to display
                            String displayedUserName;
                            if (room.senderId == auth.currentUser!.uid) {
                              // Current user is the sender, display receiver's username
                              displayedUserName =
                                  room.receiverUserName ?? 'Unknown';
                            } else {
                              // Current user is the receiver, display sender's username
                              displayedUserName =
                                  room.senderUserName ?? 'Unknown';
                            }

                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 1, 12, 15),
                                  child: GestureDetector(
                                    onTap: () async => PageChange.changeScreen(
                                        context,
                                        ChatMessageScreen(
                                          recId: room.receiverId ==
                                                  auth.currentUser!.uid
                                              ? room.senderId!
                                              : room.receiverId!,
                                          senderId: room.receiverId ==
                                                  auth.currentUser!.uid
                                              ? room.receiverId!
                                              : room.senderId!,
                                          recEmail: room.receiverEmail ??
                                              "unknown email",
                                          recImageUrl: room.receiverId ==
                                                  auth.currentUser!.uid
                                              ? room.senderImage
                                              : room.recImage,
                                          recUname: (room.senderId ==
                                                  auth.currentUser!.uid
                                              ? room.receiverUserName ?? ''
                                              : room.senderUserName ?? ''),
                                          // Use the determined username here
                                          chatMessageNavigatedFrom:
                                              ChatMessageNavigatedFrom.chatlist,
                                        )),
                                    child: ChatBox(
                                      lastMsg: room.lastMessage ?? '',
                                      url: room.receiverId ==
                                              auth.currentUser!.uid
                                          ? room.senderImage ??
                                              "lib/assets/images/1.jpg"
                                          : room.recImage ??
                                              "lib/assets/images/1.jpg",
                                      // url: room.recImage ??
                                      //     'lib/assets/images/1.jpg',
                                      uname: displayedUserName,
                                      lastseen: room.lastMessageTimestamp ?? '',
                                      boxtype: BoxType.chatlist,
                                    ),
                                  ),
                                ),
                                const SizedBox(),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
