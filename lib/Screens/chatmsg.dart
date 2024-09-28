import 'package:chat_app/Screens/chatlist.dart';
import 'package:chat_app/Screens/searchuser.dart';
import 'package:chat_app/controller/chatcontroller.dart';
import 'package:chat_app/provide/theme.dart';
import 'package:chat_app/widget/chatbubble.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum ChatMessageNavigatedFrom { chatlist, searchuser }

class ChatMessageScreen extends StatefulWidget {
  const ChatMessageScreen(
      {super.key,
      required this.recUname,
      required this.recId,
      required this.recEmail,
      required this.recImageUrl,
      required this.chatMessageNavigatedFrom});
  final ChatMessageNavigatedFrom chatMessageNavigatedFrom;
  final String recUname;
  final String recId;
  final String recEmail;
  final String? recImageUrl;
  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  @override
  Widget build(BuildContext context) {
    Chatcontroller chatController = Chatcontroller();
    TextEditingController messageController = TextEditingController();
    final themeProvider = Provider.of<ThemeProvider>(context);
    void initState() {
      super.initState();
      themeProvider.toggleTheme();
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        PageChange.changeScreen(
            context,
            widget.chatMessageNavigatedFrom == ChatMessageNavigatedFrom.chatlist
                ? const Chatlist1(screenno: 0)
                : const SearchUser(screenno: 1));
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0), // Set height to 0
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: themeProvider.isDarkMode == true
                    ? Brightness.light
                    : Brightness.dark, // Correct property for status bar icons
                statusBarColor:
                    themeProvider.chngcolor, // Change status bar color
                systemNavigationBarIconBrightness:
                    themeProvider.isDarkMode == true
                        ? Brightness.light
                        : Brightness.dark,
                systemNavigationBarColor: themeProvider
                    .listcolor // Still applies to navigation bar icons
                ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: BoxDecoration(
              color: themeProvider.chngcolor,
              borderRadius: BorderRadius.circular(100)),
          child: Row(
            children: [
              SizedBox(
                  height: 30,
                  width: 30,
                  child: Icon(
                    CupertinoIcons.mic_fill,
                    color: themeProvider.altfontclt,
                  )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: TextField(
                controller: messageController,
                minLines: 1,
                maxLines: 3,
                enableIMEPersonalizedLearning: true,
                enableInteractiveSelection: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 18, color: themeProvider.fontclr),
                decoration: const InputDecoration(
                  filled: false,
                  contentPadding: EdgeInsets.all(7),
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: "Message",
                ),
              )),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  height: 30,
                  width: 30,
                  child: Icon(
                    CupertinoIcons.photo_fill_on_rectangle_fill,
                    color: themeProvider.altfontclt,
                  )),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  height: 30,
                  width: 30,
                  child: InkWell(
                    splashFactory: InkSplash.splashFactory,
                    splashColor: Colors.grey,
                    enableFeedback: true,
                    onTap: () {
                      if (messageController.text.isNotEmpty) {
                        chatController.sendMessage(
                            widget.recId, messageController.text);
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: themeProvider.altfontclt,
                    ),
                  ))
            ],
          ),
        ),
        backgroundColor: themeProvider.chngcolor,
        body: Column(
          children: [
            // Header section with icon, avatar, and title
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 20, 0, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.arrow_uturn_left,
                      color: themeProvider.altfontclt,
                      size: 30,
                    ),
                    onPressed: () {
                      PageChange.changeScreen(
                          context,
                          widget.chatMessageNavigatedFrom ==
                                  ChatMessageNavigatedFrom.chatlist
                              ? const Chatlist1(screenno: 0)
                              : const SearchUser(screenno: 1));
                    },
                  ),
                  // Add spacing between icon and avatar
                  CircleAvatar(
                    radius: 38, // Adjust radius to match design requirements
                    backgroundColor: Colors.blue,
                    foregroundImage: (widget.recImageUrl != null &&
                                widget.recImageUrl !=
                                    "lib/assets/images/1.jpg" ||
                            widget.recImageUrl == '')
                        ? NetworkImage(widget.recImageUrl!)
                        : AssetImage("lib/assets/images/1.jpg")
                            as ImageProvider,

                    // Add color to visualize the avatar
                  ),
                  const SizedBox(
                      width: 10), // Add spacing between avatar and text
                  Text(
                    widget.recUname,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple),
                  ),
                ],
              ),
            ),

            // Chat messages section
            Expanded(
              flex: 15,
              child: Container(
                  padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
                  decoration: BoxDecoration(
                    color: themeProvider
                        .listcolor, // Softer grey color for better visibility
                    borderRadius: const BorderRadius.only(
                      topLeft:
                          Radius.circular(80.0), // Adjust the radius as needed
                      topRight: Radius.circular(80.0),
                    ),
                  ),
                  child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ChatBubble(
                                  message:
                                      "Lorem ipsum and the rest message resides here, so once again lorem ipsum",
                                  receiving: true,
                                  status: "read",
                                  time: "10am",
                                  mediaUrl: "",
                                ),
                                ChatBubble(
                                  message:
                                      "Lorem ipsum and the rest message resides here, so once again lorem ipsum",
                                  receiving: false,
                                  status: "read",
                                  time: "10am",
                                  mediaUrl: "lib/assets/images/1.jpg",
                                )
                              ],
                            ));
                      })),
            ),
          ],
        ),
      ),
    );
  }
}
