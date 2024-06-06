import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            // spreadRadius: 0,
          )
        ],
        color: Color.fromARGB(255, 0, 0, 0),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 35,
            foregroundImage: AssetImage("lib/assets/images/robot1.png"),
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
