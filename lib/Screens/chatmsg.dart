import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Screens/chatlist.dart';
import 'package:chat_app/Screens/searchuser.dart';
import 'package:chat_app/controller/chatcontroller.dart';
import 'package:chat_app/provider/theme.dart';
import 'package:chat_app/widget/chatbubble.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as provider;
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';

enum ChatMessageNavigatedFrom { chatlist, searchuser }

class ChatMessageScreen extends StatefulWidget {
  const ChatMessageScreen(
      {super.key,
      required this.recUname,
      required this.recId,
      required this.recEmail,
      required this.senderId,
      required this.recImageUrl,
      required this.chatMessageNavigatedFrom});
  final ChatMessageNavigatedFrom chatMessageNavigatedFrom;
  final String recUname;
  final String recId;
  final String senderId;
  final String recEmail;
  final String? recImageUrl;

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  TextEditingController messageController = TextEditingController();
  String? currentId = auth.currentUser!.uid;
  Chatcontroller chatController = Chatcontroller();
  // List<String>? mediaType;
  File? _pickedImageFile;
  String? mediaType;
  String? imageUrl;
  bool showError = false;

  // ScrollController to keep the list at the bottom
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  // Function to scroll to the bottom of the chat
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  String toPascalCase(String str) {
    return str
        .split(' ') // Split the string into words
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '') // Capitalize the first letter of each word
        .join(' '); // Join the words back into a single string
  }

  // void chooseFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //     type: FileType.custom,
  //     allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
  //   );
  //   if (result != null) {
  //     List<File> file = result.paths.map((path) => File(path!)).toList();
  //     print('-----------------first file output -----------${file.first}');
  //     print(file.toString().contains("jpeg") ? "yes" : "no");
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  void chooseMediaOption(String option) async {
    // print('btn selected');

    // selecting image from camera
    if (option == "Camera") {
      final pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 80);

      setState(() {
        mediaType = "Image";
        _pickedImageFile = File(pickedImage!.path);
      });
      print("Image selected: ${pickedImage!.path}");
      chatController.sendMessage(
        widget.recId == currentId
            ? widget.senderId
            : widget.recId, //URL to be send of uploaded file
        messageController.text,
        _pickedImageFile.toString(),
        mediaType ?? "empty",
      );
      Navigator.of(context).pop();

      // selecting image from filepicker
    } else if (option == "File") {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'zip'],
      );
      if (result != null) {
        List<File> file = result.paths.map((path) => File(path!)).toList();
        print('-----------------first file output -----------${file.first}');
        print(file.toString().contains("jpeg") ? "yes" : "no");
        setState(() {
          mediaType = "File";
          _pickedImageFile = File(result.paths.toString());
        });
        print(result.paths.toString());
        chatController.sendMessage(
          widget.recId == currentId
              ? widget.senderId
              : widget.recId, //URL to be send of uploaded file
          messageController.text,
          _pickedImageFile.toString(),
          mediaType ?? "empty",
        );
        Navigator.of(context).pop();
      } else {
        // User canceled the picker
        Navigator.of(context).pop();
      }
    }

    // selecting image from gallery
    else {
      final pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      setState(() {
        mediaType = "Image";
        _pickedImageFile = File(pickedImage!.path);
      });

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('chat_media')
          .child(chatController.getRoomId(widget.senderId).toString() +
              DateTime.timestamp().toString());

      // Upload the file
      await storageRef.putFile(_pickedImageFile!);

      // Await the download URL
      imageUrl = await storageRef.getDownloadURL();
      print(
          '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&S$imageUrl');
      // print("Image selected: $mediaType");
      chatController.sendMessage(
        widget.recId == currentId
            ? widget.senderId
            : widget.recId, //URL to be send of uploaded file
        messageController.text,
        imageUrl,
        mediaType ?? "empty",
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    String originalString =
        widget.recUname; // Assuming this is your original string
    String pascalCaseString = toPascalCase(originalString);
    print('recid------------${widget.recId}');
    print('sender------------${widget.senderId}');
    if (messageController.value.toString() == '' ||
        messageController.value.toString().isEmpty) {
      setState(() {
        showError = true;
        messageController.clear();
      });
    }
    final themeProvider = provider.Provider.of<ThemeProvider>(context);

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
        resizeToAvoidBottomInset: true,
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
                      radius: 32,
                      backgroundColor: Colors.blue,
                      foregroundImage: (widget.recImageUrl == null ||
                              widget.recImageUrl == '')
                          ? const AssetImage("lib/assets/images/1.jpg")
                          : CachedNetworkImageProvider(widget.recImageUrl!)
                              as ImageProvider
                      // : NetworkImage(widget.recImageUrl!) as ImageProvider,
                      ),
                  const SizedBox(width: 10),
                  Text(
                    pascalCaseString,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
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
                      return Center(
                        child: Text(
                          "No messages",
                          style: TextStyle(color: themeProvider.fontclr),
                        ),
                      );
                    } else {
                      // Scroll to bottom when new data comes in
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });

                      return ListView.builder(
                        reverse: true,
                        // controller:
                        //     _scrollController, // Set the scroll controller
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          DateTime timestamp =
                              DateTime.parse(snapshot.data![index].timestamp!);
                          String formattedTime =
                              DateFormat('hh:mm a').format(timestamp);

                          return ChatBubble(
                            message: snapshot.data![index].message ?? "",
                            mediaUrl: snapshot.data![index].mediaUrl ??
                                "wmpty mediaurl",
                            receiving:
                                snapshot.data![index].senderId != currentId,
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
                IconButton(
                  icon: Icon(
                    Icons.attach_file_rounded,
                    color: themeProvider.altfontclt,
                  ),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                            child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: themeProvider.chngcolor,
                              borderRadius: BorderRadius.circular(8),
                              //   boxShadow: [
                              //     BoxShadow(
                              //       color: Colors.red,
                              //       blurRadius: 8,
                              //     ),
                              //   ],
                            ),
                            child:
                                Wrap(spacing: 8.0, runSpacing: 8.0, children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle Data 1 tap
                                  // Navigator.of(context).pop();
                                  chooseMediaOption("Camera");
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    // color: themeProvider.altfontclt,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(CupertinoIcons.camera_fill,
                                          color: themeProvider.altfontclt),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Camera",
                                        style: TextStyle(
                                            color: themeProvider.fontclr),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle Data 2 tap
                                  // Navigator.of(context).pop();
                                  chooseMediaOption("Gallery");
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    // color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons
                                            .photo_fill_on_rectangle_fill,
                                        color: themeProvider.altfontclt,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Gallery",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: themeProvider.fontclr),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle Data 2 tap
                                  chooseMediaOption("File");
                                  // Navigator.of(context).pop();
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    // color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.doc_fill,
                                        color: themeProvider.altfontclt,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "File",
                                        style: TextStyle(
                                            color: themeProvider.fontclr),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ));
                      },
                    );
                  },
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    if (messageController.text.isNotEmpty) {
                      chatController.sendMessage(
                          widget.recId == currentId
                              ? widget.senderId
                              : widget.recId,
                          mediaType ?? "",
                          _pickedImageFile
                              .toString(), //URL to be send of uploaded file
                          messageController.text);
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

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the controller
    super.dispose();
  }
}
