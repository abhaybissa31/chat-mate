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
    // The full text you want to display
    String displayName =
        "Abhay bissa is jere hehehehe and some more words to test the word limit of twelve";

    return SafeArea(
      child: Material(
        // Color.fromARGB(255, 18, 17, 17)
        // type: MaterialType.,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 18, 17, 17),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 18, 17, 17),
            systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarColor: Color.fromARGB(
                  255, 21, 21, 21), // Ensures status bar stays dark
            ),
            shadowColor: Color.fromARGB(255, 18, 17, 17),
            scrolledUnderElevation: 0,
            // bottomOpacity: 1,
            // shadowColor: Colors.transparent,
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
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 18, 17, 17)),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                          child: Text(
                            "Recent",
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 1),
                        SizedBox(
                          height: 118,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(7, 0, 25, 0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: const CircleAvatar(
                                        radius: 42,
                                        backgroundColor: Color(0xFF262626),
                                        foregroundImage: AssetImage(
                                            "lib/assets/images/1.jpg"),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.center,
                                      width:
                                          100, // Set width to control wrapping
                                      child: Text(
                                        overflow: TextOverflow.clip,
                                        displayName.substring(0,
                                            12), // Display only the first 12 words
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
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)
                          // topRight: Radius.elliptical(100, 60),
                          // topLeft: Radius.elliptical(100, 60)
                          ),
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                      child: ListView.builder(
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return const Column(
                            children: [
                              ChatBox(),
                              SizedBox(
                                height: 10,
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
      ),
    );
  }
}
