import 'package:chat_app/Screens/splashscreen.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatlist1 extends StatelessWidget {
  const Chatlist1({super.key});

  @override
  Widget build(BuildContext context) {
    // The full text you want to display
    String displayName =
        "Abhay bissa is jere hehehehe and some more words to test the word limit of twelve";

    return SafeArea(
      child: Material(
        surfaceTintColor: Colors.black,
        type: MaterialType.transparency,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0.0,
            shadowColor: Colors.transparent,
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
            decoration: const BoxDecoration(color: Colors.black),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 15, 17, 0),
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
                        const SizedBox(height: 10),
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
                          // topLeft: Radius.circular(75),
                          topRight: Radius.elliptical(100, 60),
                          topLeft: Radius.elliptical(100, 60)),
                      color: Color.fromARGB(255, 18, 17, 17),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 60, 0, 40),
                      child: ListView.builder(
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          return Text(
                            "Hello ${index + 1}",
                            style: const TextStyle(color: Colors.white),
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
