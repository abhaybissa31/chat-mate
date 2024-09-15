import 'package:chat_app/provide/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            // spreadRadius: 0,
          )
        ],
        color: themeProvider.chngcolor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          // Avatar
          const CircleAvatar(
            radius: 35,
            foregroundImage: AssetImage("lib/assets/images/robot1.png"),
          ),
          const SizedBox(
            width: 12,
          ),
          // Name and message with time aligned
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name
                    Text(
                      "Abhay",
                      style:
                          TextStyle(color: themeProvider.fontclr, fontSize: 16),
                    ),
                    // Time aligned with the right of the name
                    const Text(
                      "12:00 PM",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                // Message below the name
                const Text(
                  "heheheheheheheheheh",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
