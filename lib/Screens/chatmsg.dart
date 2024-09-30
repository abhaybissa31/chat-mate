import 'package:chat_app/Screens/chatlist.dart';
import 'package:chat_app/Screens/searchuser.dart';
import 'package:chat_app/controller/chatcontroller.dart';
import 'package:chat_app/provide/theme.dart';
import 'package:chat_app/widget/chatbubble.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  TextEditingController messageController = TextEditingController();
  Chatcontroller chatController = Chatcontroller();
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    if (messageController.value.toString() == '' ||
        messageController.value.toString().isEmpty) {
      setState(() {
        showError = true;
        messageController.clear();
      });
    }
    final themeProvider = Provider.of<ThemeProvider>(context);

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
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: themeProvider.isDarkMode == true
                  ? Brightness.light
                  : Brightness.dark,
              statusBarColor: themeProvider.chngcolor,
              systemNavigationBarIconBrightness:
                  themeProvider.isDarkMode == true
                      ? Brightness.light
                      : Brightness.dark,
              systemNavigationBarColor: themeProvider.listcolor,
            ),
          ),
        ),
        backgroundColor: themeProvider.chngcolor,
        body: Column(
          children: [
            // Header section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.blue,
                    foregroundImage: (widget.recImageUrl != null &&
                                widget.recImageUrl !=
                                    "lib/assets/images/1.jpg" ||
                            widget.recImageUrl == '')
                        ? NetworkImage(widget.recImageUrl!)
                        : const AssetImage("lib/assets/images/1.jpg")
                            as ImageProvider,
                  ),
                  const SizedBox(width: 10),
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
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                decoration: BoxDecoration(
                  color: themeProvider.listcolor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                    topRight: Radius.circular(80.0),
                  ),
                ),
                child: StreamBuilder(
                  stream: chatController.getMessage(widget.recId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error ${snapshot.error}"),
                      );
                    } else if (snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("No messages"),
                      );
                    } else {
                      return ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          DateTime timestamp =
                              DateTime.parse(snapshot.data![index].timestamp!);
                          String formattedTime =
                              DateFormat('hh:mm a').format(timestamp);
                          return ChatBubble(
                            message: snapshot.data![index].message!,
                            mediaUrl: snapshot.data![index].imageUrl ?? '',
                            receiving:
                                widget.recId == snapshot.data![index].senderId,
                            status: "read",
                            time: formattedTime,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        // Floating action button for message input
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: themeProvider.chngcolor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                Icon(CupertinoIcons.mic_fill, color: themeProvider.altfontclt),
                const SizedBox(width: 10),
                Expanded(
                  child: showError
                      ? TextField(
                          controller: messageController,
                          minLines: 1,
                          maxLines: 3,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: 18, color: themeProvider.fontclr),
                          decoration: const InputDecoration(
                            hintText: "Please Type dont send empty messages",
                            border: InputBorder.none,
                          ),
                        )
                      : TextField(
                          controller: messageController,
                          minLines: 1,
                          maxLines: 3,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: 18, color: themeProvider.fontclr),
                          decoration: const InputDecoration(
                            hintText: "Message",
                            border: InputBorder.none,
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Icon(CupertinoIcons.photo_fill_on_rectangle_fill,
                    color: themeProvider.altfontclt),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    if (messageController.text.isNotEmpty) {
                      chatController.sendMessage(
                          widget.recId, messageController.text);
                      messageController.clear(); // Clear after sending
                    }
                  },
                  child: Icon(Icons.send, color: themeProvider.altfontclt),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
