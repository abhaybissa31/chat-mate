import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
      ),
      child: const Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 32,
            foregroundImage: AssetImage("lib/assets/images/2.jpg"),
          ),
          SizedBox(
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
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    // Time aligned with the right of the name
                    Text(
                      "12:00 PM",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                // Message below the name
                Text(
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
