import 'package:chat_app/Screens/splashscreen.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatlist1 extends StatelessWidget {
  const Chatlist1({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Wrap with SafeArea
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
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
                  padding: const EdgeInsets.fromLTRB(17, 0, 0, 0),
                  // decoration: const BoxDecoration(
                  //   borderRadius: BorderRadius.only(
                  //       bottomLeft: Radius.circular(80),
                  //       bottomRight: Radius.circular(80)),
                  //   color: Colors.black,
                  // ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the left
                    children: [
                      const Text(
                        "Recent",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 100, // Set a fixed height for the ListView
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(7, 0, 25, 0),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const CircleAvatar(
                                      radius: 38,
                                      backgroundColor: Colors.black,
                                      foregroundImage:
                                          AssetImage("lib/assets/images/1.jpg"),
                                    ),
                                  ),
                                  const Text(
                                    "Abhay",
                                    style: TextStyle(color: Colors.white),
                                  )
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
              // Removed SizedBox to prevent overflow
              Expanded(
                flex: 9,
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                      color: Color.fromARGB(53, 129, 128, 128)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 40, 0, 0),
                    child: ListView.builder(
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          return Text(
                            "Hello ${index + 1}",
                            style: const TextStyle(color: Colors.white),
                          );
                        }),
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
