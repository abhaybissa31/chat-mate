import 'package:chat_app/Screens/chatlist1.dart';
import 'package:chat_app/provide/theme.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ChatMessageScreen extends StatelessWidget {
  const ChatMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0), // Set height to 0
        child: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness:
                Brightness.dark, // Use global status bar icon brightness
            statusBarColor: Colors.white,
          ),
          backgroundColor: Colors.yellow,
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header section with icon, avatar, and title
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 20, 0, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(CupertinoIcons.arrow_uturn_left),
                  onPressed: () {
                    PageChange.changeScreen(context, Chatlist1());
                  },
                ),
                SizedBox(width: 10), // Add spacing between icon and avatar
                const CircleAvatar(
                    radius: 30, // Adjust radius to match design requirements
                    backgroundColor: Colors.blue,
                    foregroundImage: AssetImage(
                        "lib/assets/images/1.jpg") // Add color to visualize the avatar
                    ),
                const SizedBox(
                    width: 10), // Add spacing between avatar and text
                const Text(
                  'Abhay',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Chat messages section
          Expanded(
            flex: 15,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(80),
                  topRight: Radius.circular(80),
                ),
                color:
                    Colors.grey[200], // Softer grey color for better visibility
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Message ${(index + 1)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
