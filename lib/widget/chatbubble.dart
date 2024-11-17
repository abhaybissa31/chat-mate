import 'dart:io';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chat_app/provider/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:image_downloader/image_downloader.dart';
import 'package:provider/provider.dart';

bool? downloaded = false;

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {super.key,
      required this.message,
      required this.receiving,
      required this.time,
      required this.mediaUrl,
      required this.status});
  final String message;
  final bool receiving;
  final String time;
  final String mediaUrl;
  final String status;

  Future<void> downloadImage(String mediaUrl, BuildContext context) async {
    try {
      // Get the external storage directory
      Directory? externalDir = await getExternalStorageDirectory();

      if (externalDir == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unable to access storage")),
        );
        return;
      }

      // Create a folder named 'ChatMate' in the external directory
      String chatMateDirPath = "${externalDir.path}/ChatMate";
      Directory chatMateDir = Directory(chatMateDirPath);

      if (!await chatMateDir.exists()) {
        await chatMateDir.create(recursive: true);
      }

      // Define the file name and path
      String fileName = "image_${DateTime.now().millisecondsSinceEpoch}.jpg";
      String filePath = "$chatMateDirPath/$fileName";

      // Download the file using Dio
      Dio dio = Dio();
      await dio.download(mediaUrl, filePath);
      downloaded = true;
      // Notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image downloaded to $filePath")),
      );
    } catch (e) {
      downloaded = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to download image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // TODO: implement build
    print('inside chatbublllesssss $mediaUrl');
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            receiving ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width / 1.6),
              decoration: BoxDecoration(
                color: themeProvider.chngcolor,
                borderRadius: receiving
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(10),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(0),
                      ),
              ),
              // Inside the ChatBubble widget
              child: mediaUrl.isEmpty
                  ? Text(
                      message,
                      style: TextStyle(
                          fontSize: 16.9, color: themeProvider.fontclr),
                    )
                  : Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: mediaUrl.startsWith(
                                    'lib/assets/') // Check for valid asset path
                                ? Image.asset(
                                    mediaUrl,
                                    height: 150,
                                    width: 150,
                                  )
                                : Container(
                                    // Handle invalid mediaUrl case
                                    height:
                                        200, // Default height or placeholder
                                    color: Colors.grey,
                                    child: InkWell(
                                      onTap: () {
                                        if (downloaded = true) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text("ImageDownloaded")));
                                        }
                                        print('Tapped');
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Center(
                                              child: Material(
                                                color: Colors
                                                    .transparent, // Make background transparent
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .white, // Add background color for the image
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10), // Optional rounding
                                                  ),
                                                  padding: EdgeInsets.all(10),
                                                  child: Container(
                                                    color:
                                                        themeProvider.chngcolor,
                                                    child: Stack(
                                                      children: [
                                                        Center(
                                                          child: Image.network(
                                                            mediaUrl,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment: Alignment
                                                              .topCenter,
                                                          height: 55,
                                                          color: Colors
                                                              .transparent
                                                              .withOpacity(0.8),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Positioned(
                                                                top:
                                                                    40, // Adjust for status bar
                                                                left: 10,
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .arrow_back,
                                                                      color: Colors
                                                                          .white),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                              Positioned(
                                                                top: 40,
                                                                right: 0,
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .download,
                                                                      color: Colors
                                                                          .white),
                                                                  onPressed:
                                                                      () async {
                                                                    await downloadImage(
                                                                        mediaUrl,
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Image.network(
                                        mediaUrl,
                                        height: 150,
                                        width: 150,
                                      ),
                                    ),
                                  )),
                        const SizedBox(height: 10),
                        Text(
                          message,
                          style: TextStyle(
                              fontSize: 16.9, color: themeProvider.fontclr),
                        ),
                      ],
                    )),
          const SizedBox(
            height: 10,
          ),
          receiving
              ? Text(
                  time,
                  style: TextStyle(color: themeProvider.altfontclt),
                )
              : Row(
                  mainAxisAlignment: receiving
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    Icon(
                      CupertinoIcons.checkmark_circle,
                      color: themeProvider.altfontclt,
                      size: 20,
                    ),
                    Text(time,
                        style: TextStyle(color: themeProvider.altfontclt))
                  ],
                )
        ],
      ),
    );
  }
}
