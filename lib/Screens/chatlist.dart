import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Screens/chatmsg.dart';
import 'package:chat_app/controller/chatcontroller.dart';
import 'package:chat_app/model/chatroom.dart';
import 'package:chat_app/provider/currentuserdetails.dart';
import 'package:chat_app/provider/senderreceiver.dart';
import 'package:chat_app/provider/theme.dart';
import 'package:chat_app/widget/bottomnav.dart';
import 'package:chat_app/widget/chatbox.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

class Chatlist1 extends ConsumerStatefulWidget {
  const Chatlist1({super.key, required this.screenno});
  final int screenno;

  @override
  _Chatlist1State createState() => _Chatlist1State();
}

class _Chatlist1State extends ConsumerState<Chatlist1> {
  Chatcontroller chatController = Chatcontroller();
  List<ChatRoomModel> chatRoomDetails = [];

  String displayName =
      "Abhay bissa is jere hehehehe and some more words to test the word limit of twelve"
          .substring(0, 12);
  @override
  void initState() {
    ref.read(currentUserImageProvider.notifier).fetchImageUrl();
    ref.read(currentUserUserNameProvider.notifier).fetchUsername();
    ref.read(currentUserIdProvider.notifier).fetchId();
    super.initState();
    chatController.retrieveRoomDetailsStreamForCurrentUser();
    // _loadChatRooms();
  }

  String? toPascalCase(String str) {
    return str
        .split(' ') // Split the string into words
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '') // Capitalize the first letter of each word
        .join(' ')
        .substring(
          0,
        ); // Join the words back into a single string
  }

  @override
  Widget build(BuildContext context) {
    ref.read(currentUserImageProvider.notifier);
    // ignore: unused_local_variable
    final String? imageUrl = ref.watch(currentUserImageProvider);
    final currentUserId = ref.watch(currentUserIdProvider);
    // ignore: unused_local_variable
    final currentUserUserName = ref.watch(currentUserUserNameProvider);
    // print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO$currentUserUserName");
    // Access the global theme provider
    final themeProvider = provider.Provider.of<ThemeProvider>(context);

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
          // actions: [
          //   IconButton(
          //     enableFeedback: true,
          //     onPressed: () {
          //       FirebaseAuth.instance.signOut();
          //       ScaffoldMessenger.of(context).clearMaterialBanners();
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(
          //           backgroundColor: Colors.black,
          //           content: Text("Logged out"),
          //         ),
          //       );
          //       PageChange.changeScreen(context, const SplashScreen());
          //     },
          //     icon: const Icon(Icons.exit_to_app),
          //     color: Colors.purple,
          //   ),
          //   // IconButton(
          //   //   enableFeedback: true,
          //   //   onPressed: () {
          //   //     themeProvider.toggleTheme(); // Toggle the global theme
          //   //   },
          //   //   icon: themeProvider.themeicon, // Use global theme icon
          //   // )
          // ],
        ),
        bottomNavigationBar: const BottomNav(
          whichscreen: 0,
        ),

        body: PopScope(
          canPop: true,
          onPopInvokedWithResult: (didpop, idk) {
            if (didpop) {
              print('$didpop popped');
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: themeProvider.chngcolor), // Global background color
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            "Recent", // Text 'Recent' restored as per your request
                            style: TextStyle(
                              color: themeProvider.fontclr,
                              fontSize: 18, // Global font color
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 110,
                          child: StreamBuilder<List<Map<String, dynamic>>>(
                            stream: chatController
                                .getFavContacts(), // Use the getFavContacts stream
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Error loading contacts.'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                    child: Text('No recent contacts.',
                                        style: TextStyle(
                                            color: themeProvider.fontclr)));
                              }

                              final contacts = snapshot.data!;

                              return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: contacts.length,
                                itemBuilder: (context, index) {
                                  final contact = contacts[index];
                                  // print(contact);
                                  // Provide fallback values for potential null data
                                  final displayName =
                                      contact['username'] ?? 'Unknown User';
                                  final profileImageUrl =
                                      contact['profileImage'] ??
                                          'lib/assets/images/1.jpg';
                                  final recEmail =
                                      contact['email'] ?? 'unknown@example.com';
                                  String originalString = displayName;
                                  String? userNamePascal =
                                      toPascalCase(originalString);

                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 25, 0),
                                    child: GestureDetector(
                                      onTap: () async =>
                                          PageChange.changeScreen(
                                        context,
                                        ChatMessageScreen(
                                          recId: contact['userId'] ??
                                              '', // Handle null case
                                          senderId:
                                              currentUserId!, // Pass the current user ID
                                          recEmail:
                                              recEmail, // Pass receiver email
                                          recImageUrl:
                                              profileImageUrl, // Use profile image with fallback
                                          recUname:
                                              userNamePascal, // Use display name with fallback
                                          chatMessageNavigatedFrom:
                                              ChatMessageNavigatedFrom.chatlist,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: CircleAvatar(
                                              radius: 38,
                                              backgroundColor:
                                                  themeProvider.chngcolor,
                                              foregroundImage: profileImageUrl ==
                                                          "" ||
                                                      profileImageUrl == null
                                                  ? const AssetImage(
                                                      'lib/assets/images/1.jpg')
                                                  : CachedNetworkImageProvider(
                                                      profileImageUrl,
                                                    ),

                                              // : NetworkImage(
                                              //     profileImageUrl), // Use profile image
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Container(
                                            alignment: Alignment.center,
                                            width:
                                                100, // Set width to control wrapping
                                            child: Text(
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              // overflow: TextOverflow.clip,
                                              userNamePascal!, // Display name with fallback
                                              style: TextStyle(
                                                // overflow: TextOverflow.fade,

                                                color: themeProvider.fontclr,
                                                fontSize:
                                                    16, // Global font color
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
                      color: themeProvider
                          .listcolor, // Global list background color
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(19.0, 19, 19, 0),
                      child: RepaintBoundary(
                        child: StreamBuilder<List<ChatRoomModel>>(
                          stream: chatController
                              .retrieveRoomDetailsStreamForCurrentUser(),
                          builder: (context,
                              AsyncSnapshot<List<ChatRoomModel>> snapshot) {
                            // Check if the connection is still active or the data is being fetched
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
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
                            List<ChatRoomModel> chatRoomDetails =
                                snapshot.data!;

                            return ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              itemCount: chatRoomDetails.length,
                              itemBuilder: (context, index) {
                                final room = chatRoomDetails[index];

                                // var senderDetails = chatController
                                //     .getSenderDetails(room.senderId!);
                                // var receiverDetails = Chatcontroller()
                                //     .getReceiverDetails(room.receiverId!);
                                // String originalString =
                                //     (room.senderId == currentUserId
                                //         ? receiverDetails['username'] ?? ''
                                //         : room.senderUserName ?? '');
                                final senderDetailsAsync = ref.watch(
                                    senderDetailsProvider(room.senderId!));
                                final receiverDetailsAsync = ref.watch(
                                    receiverDetailsProvider(room.receiverId!));

                                return senderDetailsAsync.when(
                                  data: (senderDetails) {
                                    return receiverDetailsAsync.when(
                                      data: (receiverDetails) {
                                        String originalString = (room
                                                    .senderId ==
                                                currentUserId
                                            ? receiverDetails['username'] ?? ''
                                            : senderDetails['username'] ?? '');

                                        // Convert originalString to PascalCase
                                        String? userNamePascal =
                                            toPascalCase(originalString);

                                        // Determine the username to display
                                        // ignore: unused_local_variable
                                        String displayedUserName;
                                        if (room.senderId == currentUserId) {
                                          // Current user is the sender, display receiver's username
                                          displayedUserName =
                                              receiverDetails['username'] ??
                                                  'Unknown';
                                        } else {
                                          // Current user is the receiver, display sender's username
                                          displayedUserName =
                                              senderDetails['username'] ??
                                                  'Unknown';
                                        }

                                        // // Debugging prints
                                        // print(
                                        //     '+++++++++++++++++++++DETAILS+++++++++++++++++++++');
                                        // print(
                                        //     'CurrentUserId----->${currentUserId}');
                                        // print(
                                        //     'SenderName---->>>>>>${senderDetails['username']}');
                                        // print('SenderId===>>${room.senderId}');
                                        // print(
                                        //     'Sender Image==${senderDetails['image_url']}');
                                        // print(
                                        //     'ReceiverName--->>>>${receiverDetails['username']}');
                                        // print(
                                        //     'ReceiverId===>>${room.receiverId}');
                                        // print(
                                        //     'Receiver Image==${receiverDetails['image_url']}');
                                        // print(
                                        //     '+++++++++++++++++++++DETAILS End ChatList+++++++++++++++++++++');

                                        return Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      12, 1, 12, 15),
                                              child: GestureDetector(
                                                onTap: () async =>
                                                    PageChange.changeScreen(
                                                  context,
                                                  ChatMessageScreen(
                                                    recId: room.receiverId ==
                                                            currentUserId
                                                        ? room.senderId!
                                                        : room.receiverId!,
                                                    senderId: room.receiverId ==
                                                            currentUserId
                                                        ? room.receiverId!
                                                        : room.senderId!,
                                                    recEmail: "",
                                                    recImageUrl:
                                                        room.receiverId ==
                                                                currentUserId
                                                            ? senderDetails[
                                                                'image_url']
                                                            : receiverDetails[
                                                                'image_url'],
                                                    recUname: userNamePascal,
                                                    chatMessageNavigatedFrom:
                                                        ChatMessageNavigatedFrom
                                                            .chatlist,
                                                  ),
                                                ),
                                                child: ChatBox(
                                                  lastMsg:
                                                      room.lastMessage ?? '',
                                                  url: (room.receiverId ==
                                                              currentUserId ||
                                                          receiverDetails[
                                                                  'image_url'] ==
                                                              null)
                                                      ? senderDetails[
                                                              'image_url'] ??
                                                          "lib/assets/images/1.jpg"
                                                      : receiverDetails[
                                                              'image_url'] ??
                                                          "lib/assets/images/1.jpg",
                                                  uname: userNamePascal!,
                                                  lastseen:
                                                      room.lastMessageTimestamp ??
                                                          '',
                                                  boxtype: BoxType.chatlist,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                      loading: () => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      error: (error, stack) =>
                                          Text("Error: $error"),
                                    );
                                  },
                                  loading: () => CircularProgressIndicator(),
                                  error: (error, stack) =>
                                      Text("Error: $error"),
                                );

                                // senderDetailsAsync.when(
                                //   data: (senderDetails) {
                                //     return receiverDetailsAsync.when(
                                //       data: (receiverDetails) {
                                //         String originalString = (room.senderId ==
                                //                 currentUserId
                                //             ? receiverDetails['username'] ?? ''
                                //             : senderDetails['username'] ?? '');

                                //         String? userNamePascal =
                                //             toPascalCase(originalString);

                                //         return Text(userNamePascal ?? "");
                                //       },
                                //       loading: () => CircularProgressIndicator(),
                                //       error: (error, stack) =>
                                //           Text("Error: $error"),
                                //     );
                                //   },
                                //   loading: () => CircularProgressIndicator(),
                                //   error: (error, stack) => Text("Error: $error"),
                                // );

                                // String? userNamePascal =
                                //     toPascalCase(originalString);
                                // // Determine the username to display
                                // String displayedUserName;
                                // if (room.senderId == currentUserId) {
                                //   // Current user is the sender, display receiver's username
                                //   displayedUserName =
                                //       room.receiverUserName ?? 'Unknown';
                                // } else {
                                //   // Current user is the receiver, display sender's username
                                //   displayedUserName =
                                //       room.senderUserName ?? 'Unknown';
                                // }
                                // print(
                                //     '+++++++++++++++++++++DETAILS+++++++++++++++++++++');
                                // print('CurrentUserId----->${currentUserId}');
                                // print(
                                //     'SenderName---->>>>>>${room.senderUserName}');
                                // print('SenderId===>>${room.senderId}');
                                // print('Image==${room.senderImage}');
                                // print(
                                //     'ReceiverName--->>>>${room.receiverUserName}\n');
                                // print('ReceiverId===>>${room.receiverId}');
                                // print('Image==${room.recImage}');
                                // print(
                                //     '+++++++++++++++++++++DETAILS End ChatList+++++++++++++++++++++');
                                // return Column(
                                //   children: [
                                //     Padding(
                                //       padding: const EdgeInsets.fromLTRB(
                                //           12, 1, 12, 15),
                                //       child: GestureDetector(
                                //         onTap: () async =>
                                //             PageChange.changeScreen(
                                //                 context,
                                //                 ChatMessageScreen(
                                //                   recId: room.receiverId ==
                                //                           currentUserId
                                //                       ? room.senderId!
                                //                       : room.receiverId!,
                                //                   senderId: room.receiverId ==
                                //                           currentUserId
                                //                       ? room.receiverId!
                                //                       : room.senderId!,
                                //                   recEmail: room.receiverEmail ??
                                //                       "unknown email",
                                //                   recImageUrl: room.receiverId ==
                                //                           currentUserId
                                //                       ? room.senderImage
                                //                       : room.recImage,
                                //                   recUname: userNamePascal!,
                                //                   // Use the determined username here
                                //                   chatMessageNavigatedFrom:
                                //                       ChatMessageNavigatedFrom
                                //                           .chatlist,
                                //                 )),
                                //         child: ChatBox(
                                //           lastMsg: room.lastMessage ?? '',
                                //           url: room.receiverId == currentUserId ||
                                //                   room.recImage == null
                                //               ? room.recImage ??
                                //                   "lib/assets/images/1.jpg"
                                //               : imageUrl ??
                                //                   "lib/assets/images/1.jpg",
                                //           // url: room.recImage ??
                                //           //     'lib/assets/images/1.jpg',
                                //           uname: userNamePascal!,
                                //           lastseen:
                                //               room.lastMessageTimestamp ?? '',
                                //           boxtype: BoxType.chatlist,
                                //         ),

                                // const SizedBox();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
