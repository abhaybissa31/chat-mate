import 'dart:io';
// import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/widget/pdfview.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chat_app/provider/theme.dart';
// import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
// import 'package:image_downloader/image_downloader.dart';
import 'package:provider/provider.dart';
import 'package:media_scanner/media_scanner.dart';

class ChatBubble extends StatefulWidget {
  const ChatBubble(
      {super.key,
      required this.message,
      required this.receiving,
      required this.mediaType,
      required this.time,
      // this.mediaSubType,
      required this.mediaUrl,
      required this.status});
  final String message;
  final bool receiving;
  final String mediaType;
  // final String? mediaSubType;
  final String time;
  final String mediaUrl;
  final String status;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool? isLoading;
  bool showConfirm = false;
  String? filePath;
  Future<void> downloadImage(String mediaUrl, BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });

      // Locate the DCIM directory
      String dcimDirPath = "/storage/emulated/0/DCIM/ChatMate";
      Directory dcimDir = Directory(dcimDirPath);

      // Ensure the ChatMate folder exists
      if (!await dcimDir.exists()) {
        await dcimDir.create(recursive: true);
      }

      // Define the file name and path
      String fileName =
          "image_${DateTime.now().millisecondsSinceEpoch}.${widget.mediaType}";
      filePath = "$dcimDirPath/$fileName";

      // Download the image
      Dio dio = Dio();
      await dio.download(mediaUrl, filePath);

      // Notify the media scanner about the new file
      await MediaScanner.loadMedia(path: filePath);

      setState(() {
        isLoading = false;
        showConfirm = true;
      });

      // Hide the confirmation message after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            showConfirm = false;
          });
        }
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Image saved to DCIM and added to the gallery: $filePath")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save image: $e")),
        );
      }
    }
  }

  Future<void> downloadFile(String mediaUrl, BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });

      // Locate the DCIM directory
      String dcimDirPath = "/storage/emulated/0/Documents/ChatMate/files";
      Directory dcimDir = Directory(dcimDirPath);

      // Ensure the ChatMate folder exists
      if (!await dcimDir.exists()) {
        await dcimDir.create(recursive: true);
      }

      // Define the file name and path
      String fileName =
          "${widget.mediaType}${DateTime.now().millisecondsSinceEpoch}.${widget.mediaType}";
      setState(() {
        filePath = "$dcimDirPath/$fileName";
      });
      print(filePath);
      // Download the image
      Dio dio = Dio();
      await dio.download(mediaUrl, filePath);

      // Notify the media scanner about the new file
      await MediaScanner.loadMedia(path: filePath);

      setState(() {
        isLoading = false;
        showConfirm = true;
      });

      // Hide the confirmation message after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            showConfirm = false;
          });
        }
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Image saved to chatmate and added loaded media: $filePath")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save image: $e")),
        );
      }
    }
    OpenFile.open(mediaUrl, type: widget.mediaType);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    showContent() {
      if (widget.mediaType == "jpg" ||
          widget.mediaType == "jpeg" ||
          widget.mediaType == "png") {
        // widget.mediaType.isEmpty
        return Stack(
          children: [
            // Image and loading overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: Material(
                          color: Colors.transparent,
                          child: Scaffold(
                            backgroundColor: themeProvider.chngcolor,
                            appBar: AppBar(
                              // actionsIconTheme: IconThemeData(),
                              centerTitle: true,
                              title: Text(
                                "Image",
                                style: TextStyle(color: themeProvider.fontclr),
                              ),
                              iconTheme:
                                  IconThemeData(color: themeProvider.fontclr),
                              backgroundColor: themeProvider.chngcolor,
                              actions: [
                                isLoading == true
                                    ? CircularProgressIndicator(
                                        color: themeProvider.fontclr)
                                    : IconButton(
                                        icon: Icon(Icons.download,
                                            color: themeProvider.fontclr),
                                        onPressed: () async {
                                          await downloadImage(
                                              widget.mediaUrl, context);
                                        },
                                      ),
                              ],
                            ),
                            body: Center(
                              child: CachedNetworkImage(
                                imageUrl: widget.mediaUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: CachedNetworkImage(
                  imageUrl: widget.mediaUrl,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Show confirmation message
            if (showConfirm)
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Download Complete",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
          ],
        );
      } else if (widget.mediaType == "" || widget.mediaType.isEmpty) {
        return Text(
          widget.message,
          style: TextStyle(fontSize: 16.9, color: themeProvider.fontclr),
        );
      } else {
        String? subtype;
        if (widget.mediaType == "png" ||
            widget.mediaType == "jpg" ||
            widget.mediaType == "jpeg") {
          subtype = "image";
        }
        if (widget.mediaType == "pdf") {
          subtype = "pdf";
        }
        // print(subtype);
        return Stack(
          children: [
            // Image and loading overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  print("onTappped");
                  downloadFile(widget.mediaUrl, context);
                  OpenFile.open(filePath, type: widget.mediaType);
                  OpenFile.platform.open(filePath);
                  // print("tapped");
                  // const types = {
                  //   ".pdf": "application/pdf",
                  //   ".dwg": "application/x-autocad"
                  // };

                  // _openOtherTypeFile() async {
                  //   final filePath = widget.mediaSubType ?? "";
                  //   final extension = widget
                  //       .mediaSubType; //import 'package:path/path.dart' as path;
                  //   // OpenFile.platform.open(filePath);
                  //   await OpenFile.open(filePath, type: types[extension]);
                  // }

                  // _openOtherTypeFile();
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return Center(
                  //       child: Material(
                  //         color: Colors.transparent,
                  //         child: Scaffold(
                  //           backgroundColor: themeProvider.chngcolor,
                  //           appBar: AppBar(
                  //             // actionsIconTheme: IconThemeData(),
                  //             centerTitle: true,
                  //             title: Text(
                  //               "Image",
                  //               style: TextStyle(color: themeProvider.fontclr),
                  //             ),
                  //             iconTheme:
                  //                 IconThemeData(color: themeProvider.fontclr),
                  //             backgroundColor: themeProvider.chngcolor,
                  //             actions: [
                  //               isLoading == true
                  //                   ? CircularProgressIndicator(
                  //                       color: themeProvider.fontclr)
                  //                   : IconButton(
                  //                       icon: Icon(Icons.download,
                  //                           color: themeProvider.fontclr),
                  //                       onPressed: () async {
                  //                         await downloadImage(
                  //                             widget.mediaUrl, context);
                  //                       },
                  //                     ),
                  //             ],
                  //           ),
                  //           body: Center(
                  //             child: MyPdfViewer(
                  //               pdfUrl: widget.mediaUrl,
                  //               // fit: BoxFit.contain,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );
                },
                child: subtype == "image"
                    ? CachedNetworkImage(
                        imageUrl: widget.mediaUrl,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      )
                    : subtype == "pdf"
                        ? SizedBox(
                            height: 150,
                            width: 150,
                            child: MyPdfViewer(
                              pdfUrl: widget.mediaUrl,
                            ))
                        : Container(
                            height: 150,
                            width: 150,
                            child: Center(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Icon(
                                      size: 30,
                                      CupertinoIcons.doc_fill,
                                      color: themeProvider.fontclr,
                                    ),
                                  ),
                                  Divider(),
                                  Text(
                                    widget.mediaType,
                                    style:
                                        TextStyle(color: themeProvider.fontclr),
                                  )
                                ],
                              ),
                            ),
                          ),
              ),
            ),

            // Show confirmation message
            if (showConfirm)
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Download Complete",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
          ],
        );
      }
    }

    print(widget.mediaType);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: widget.receiving
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width / 1.6,
            ),
            decoration: BoxDecoration(
              color: themeProvider.chngcolor,
              borderRadius: widget.receiving
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
            child: showContent(),
            // child: widget.mediaType.isEmpty
            //     ? Text(
            //         widget.message,
            //         style:
            //             TextStyle(fontSize: 16.9, color: themeProvider.fontclr),
            //       )
            //     : Stack(
            //         children: [
            //           // Image and loading overlay
            //           ClipRRect(
            //             borderRadius: BorderRadius.circular(10),
            //             child: InkWell(
            //               onTap: () {
            //                 showDialog(
            //                   context: context,
            //                   builder: (BuildContext context) {
            //                     return Center(
            //                       child: Material(
            //                         color: Colors.transparent,
            //                         child: Scaffold(
            //                           backgroundColor: themeProvider.chngcolor,
            //                           appBar: AppBar(
            //                             // actionsIconTheme: IconThemeData(),
            //                             centerTitle: true,
            //                             title: Text(
            //                               "Image",
            //                               style: TextStyle(
            //                                   color: themeProvider.fontclr),
            //                             ),
            //                             iconTheme: IconThemeData(
            //                                 color: themeProvider.fontclr),
            //                             backgroundColor:
            //                                 themeProvider.chngcolor,
            //                             actions: [
            //                               isLoading == true
            //                                   ? CircularProgressIndicator(
            //                                       color: themeProvider.fontclr)
            //                                   : IconButton(
            //                                       icon: Icon(Icons.download,
            //                                           color: themeProvider
            //                                               .fontclr),
            //                                       onPressed: () async {
            //                                         await downloadImage(
            //                                             widget.mediaUrl,
            //                                             context);
            //                                       },
            //                                     ),
            //                             ],
            //                           ),
            //                           body: Center(
            //                             child: CachedNetworkImage(
            //                               imageUrl: widget.mediaUrl,
            //                               fit: BoxFit.contain,
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     );
            //                   },
            //                 );
            //               },
            //               child: CachedNetworkImage(
            //                 imageUrl: widget.mediaUrl,
            //                 height: 150,
            //                 width: 150,
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //           ),

            //           // Show confirmation message
            //           if (showConfirm)
            //             Center(
            //               child: Container(
            //                 padding: EdgeInsets.symmetric(
            //                     horizontal: 16, vertical: 8),
            //                 decoration: BoxDecoration(
            //                   color: Colors.black.withOpacity(0.7),
            //                   borderRadius: BorderRadius.circular(10),
            //                 ),
            //                 child: Text(
            //                   "Download Complete",
            //                   style:
            //                       TextStyle(color: Colors.white, fontSize: 14),
            //                 ),
            //               ),
            //             ),
            //         ],
            //       ),
          ),
          const SizedBox(height: 10),
          widget.receiving
              ? Text(
                  widget.time,
                  style: TextStyle(color: themeProvider.altfontclt),
                )
              : Row(
                  mainAxisAlignment: widget.receiving
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    Icon(
                      CupertinoIcons.checkmark_circle,
                      color: themeProvider.altfontclt,
                      size: 20,
                    ),
                    Text(widget.time,
                        style: TextStyle(color: themeProvider.altfontclt)),
                  ],
                ),
        ],
      ),
    );
  }
}
