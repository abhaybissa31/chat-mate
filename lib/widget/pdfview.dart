import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MyPdfViewer extends StatefulWidget {
  final String pdfUrl; // Firebase Storage URL

  MyPdfViewer({required this.pdfUrl});

  @override
  _MyPdfViewerState createState() => _MyPdfViewerState();
}

class _MyPdfViewerState extends State<MyPdfViewer> {
  late PDFViewController pdfViewController;
  String? localFilePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePdf();
  }

  Future<void> _downloadAndSavePdf() async {
    try {
      // Download the file from Firebase Storage
      final ref = FirebaseStorage.instance.refFromURL(widget.pdfUrl);
      final bytes = await ref.getData();

      // Get the device's temporary directory
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp.pdf');

      // Write the downloaded bytes to the file
      await file.writeAsBytes(bytes!);

      setState(() {
        localFilePath = file.path;
        isLoading = false;
      });
    } catch (e) {
      print("Error downloading PDF: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My PDF Document"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : localFilePath == null
              ? Center(child: Text("Failed to load PDF"))
              : PDFView(
                  filePath: localFilePath,
                  autoSpacing: true,
                  enableSwipe: true,
                  pageSnap: true,
                  swipeHorizontal: true,
                  onError: (error) {
                    print(error);
                  },
                  onPageError: (page, error) {
                    print('$page: ${error.toString()}');
                  },
                  onViewCreated: (PDFViewController vc) {
                    pdfViewController = vc;
                  },
                  onPageChanged: (page, total) =>
                      print('Page changed: $page/${total ?? 'Unknown'}')
                          as PageChangedCallback?,
                ),
    );
  }
}
