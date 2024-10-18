import 'package:chat_app/Screens/chatmsg.dart';
import 'package:chat_app/Screens/splashscreen.dart';
import 'package:chat_app/controller/chatcontroller.dart';
import 'package:chat_app/model/chatroom.dart';
import 'package:chat_app/provide/theme.dart';
import 'package:chat_app/widget/bottomnav.dart';
import 'package:chat_app/widget/chatbox.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
    chatController.retrieveRoomDetailsForCurrentUser();
    _loadChatRooms();
  }

  Future<void> _loadChatRooms() async {
    chatRoomDetails = await chatController.retrieveRoomDetailsForCurrentUser();
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
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .where('participants',
                              arrayContains: auth.currentUser!.uid)
                          .orderBy('lastMessageTimestamp', descending: false)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        // Check if the connection is still active or the data is being fetched
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child:
                                  CircularProgressIndicator()); // Show loading spinner
                        }

                        // Check if the snapshot has any errors
                        if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}"));
                        }

                        // Check if there's any data
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No chat rooms found'));
                        }

                        // Extract room details from the snapshot and ensure proper type casting
                        var chatRoomDetails =
                            snapshot.data!.docs.map((doc) async {
                          // Ensure doc.data() is cast to Map<String, dynamic>
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;

                          // Ensure that participants is a List<String>
                          List<String> participants =
                              (data['participants'] as List<dynamic>)
                                  .cast<String>();

                          // Get the user ID for the receiver (assuming you want the first participant as an example)
                          String receiverId = participants
                              .firstWhere((id) => id != auth.currentUser!.uid);

                          // Fetch user details for the receiver
                          DocumentSnapshot userDoc = await FirebaseFirestore
                              .instance
                              .collection('users')
                              .doc(receiverId)
                              .get();
                          String? imageUrl = (userDoc.data()
                              as Map<String, dynamic>)['image_url'] as String?;

                          DateTime timestamp =
                              DateTime.parse(data['lastMessageTimestamp']);
                          String formattedTime =
                              DateFormat('hh:mm a').format(timestamp);
                          // Extract room details using the data
                          return ChatRoomModel(
                            senderUserName: data['senderUserName'] as String,
                            id: doc.id,
                            lastMessage: data['lastMessage'] as String?,
                            lastMessageTimestamp: formattedTime,
                            receiverId: receiverId,
                            receiverUserName:
                                data['receiverUserName'] as String?,
                            recImage: imageUrl ??
                                'lib/assets/images/1.jpg', // Default image if not found
                            participants:
                                participants, // Ensure proper type here
                          );
                        }).toList();

                        return FutureBuilder<List<ChatRoomModel>>(
                          future: Future.wait(
                              chatRoomDetails), // Wait for all async operations to complete
                          builder: (context,
                              AsyncSnapshot<List<ChatRoomModel>> roomSnapshot) {
                            // Check if the connection is still active or the data is being fetched
                            if (roomSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child:
                                      CircularProgressIndicator()); // Show loading spinner
                            }

                            // Check if there's any data
                            if (!roomSnapshot.hasData ||
                                roomSnapshot.data!.isEmpty) {
                              return Center(
                                  child: Text(
                                'No chat rooms found',
                                style: TextStyle(color: themeProvider.fontclr),
                              ));
                            }
                            return ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              itemCount: roomSnapshot.data!.length,
                              itemBuilder: (context, index) {
                                final room = roomSnapshot.data![index];

                                // Debugging statements to inspect values
                                print(
                                    'Current User ID: ${auth.currentUser!.uid}');
                                print(
                                    'Sender UserName: ${room.senderUserName}');
                                print(
                                    'Receiver UserName: ${room.receiverUserName}');

                                // Determine if the current user is the sender or the receiver
                                String displayedUserName;
                                if (room.senderId == auth.currentUser!.uid) {
                                  // The current user is the sender, display the receiver's username
                                  displayedUserName = room.senderUserName!;
                                } else {
                                  // The current user is the receiver, display their own username
                                  displayedUserName = room.receiverUserName!;
                                }

                                // Another debug statement to confirm which username will be displayed
                                print('Displayed UserName: $displayedUserName');

                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 1, 12, 15),
                                      child: GestureDetector(
                                        onTap: () async =>
                                            PageChange.changeScreen(
                                          context,
                                          ChatMessageScreen(
                                            recId: room.receiverId ??
                                                "unknown recId",
                                            recEmail: room.receiverEmail ??
                                                "unknown email",
                                            recImageUrl: room.recImage ?? "",
                                            recUname:
                                                displayedUserName, // Use the determined username here
                                            chatMessageNavigatedFrom:
                                                ChatMessageNavigatedFrom
                                                    .chatlist,
                                          ),
                                        ),
                                        child: ChatBox(
                                          lastMsg: room.lastMessage!,
                                          url: room.recImage!,
                                          uname:
                                              displayedUserName, // Pass the determined username
                                          lastseen: room.lastMessageTimestamp!,
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
