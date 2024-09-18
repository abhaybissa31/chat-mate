import 'package:chat_app/Screens/chatmsg.dart';
import 'package:chat_app/Screens/splashscreen.dart';
import 'package:chat_app/provide/theme.dart';
import 'package:chat_app/widget/chatbox.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Chatlist1 extends StatefulWidget {
  const Chatlist1({super.key});

  @override
  State<Chatlist1> createState() => _Chatlist1State();
}

class _Chatlist1State extends State<Chatlist1> {
  @override
  Widget build(BuildContext context) {
    // Access the global theme provider
    final themeProvider = Provider.of<ThemeProvider>(context);

    String displayName =
        "Abhay bissa is jere hehehehe and some more words to test the word limit of twelve"
            .substring(0, 12);

    return Material(
      child: Scaffold(
        backgroundColor: themeProvider.chngcolor, // Use global background color
        appBar: AppBar(
          backgroundColor: themeProvider.chngcolor, // Use global app bar color
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarIconBrightness: themeProvider
                .statusbariconcolor, // Use global status bar icon brightness
            statusBarColor: themeProvider.chngcolor,
          ),
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            "Messages",
            style: TextStyle(color: Colors.green),
          ),
          actions: [
            IconButton(
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
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {
                themeProvider.toggleTheme(); // Toggle the global theme
              },
              icon: themeProvider.themeicon, // Use global theme icon
            )
          ],
        ),
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
                                onTap: () => PageChange.changeScreen(
                                    context, const ChatMessageScreen()),
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
                flex: 8,
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
                    child: ListView.builder(
                      physics:
                          const ClampingScrollPhysics(), // Prevent overflow by constraining scrolling
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 1, 12, 15),
                              child: GestureDetector(
                                  onTap: () => PageChange.changeScreen(
                                      context, const ChatMessageScreen()),
                                  child: const ChatBox()),
                            ),
                            const SizedBox(
                                // height: 5,
                                )
                          ],
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
