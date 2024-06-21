import 'package:chat_app/Screens/splashscreen.dart';
import 'package:chat_app/widget/chatbox.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Chatlist1 extends StatelessWidget {
  const Chatlist1({super.key});

  @override
  Widget build(BuildContext context) {
    String displayName =
        "Abhay bissa is jere hehehehe and some more words to test the word limit of twelve"
            .substring(0, 12);

    Color chngcolor = const Color.fromARGB(255, 31, 30, 30);

    return Material(
      child: Scaffold(
        backgroundColor: chngcolor,
        appBar: AppBar(
          backgroundColor: chngcolor,
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarColor: chngcolor, // Ensures status bar stays dark
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
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(color: chngcolor),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                        child: Text(
                          "Recent",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 118,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(7, 5, 25, 0),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: chngcolor,
                                      foregroundImage: const AssetImage(
                                          "lib/assets/images/1.jpg"),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 100, // Set width to control wrapping
                                    child: Text(
                                      overflow: TextOverflow.clip,
                                      displayName, // Display only the first 12 words
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      // softWrap: true, // Allow text to wrap
                                    ),
                                  ),
                                ],
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
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    ),
                    color: Colors.black,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      physics:
                          ClampingScrollPhysics(), // Prevent overflow by constraining scrolling
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return const Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 1, 10, 10),
                              child: ChatBox(),
                            ),
                            SizedBox(
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
