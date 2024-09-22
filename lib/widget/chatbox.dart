import 'package:chat_app/provide/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum BoxType {
  searchUser,
  chatlist,
}

class ChatBox extends StatelessWidget {
  ChatBox({
    super.key,
    required this.uname,
    required this.lastMsg,
    required this.boxtype,
    this.lastseen = "",
    this.url = "",
  });
  final String uname;
  final String lastMsg;
  final BoxType boxtype;
  String lastseen;
  String url;

  @override
  Widget build(BuildContext context) {
    String chatboxtype = "hehe";
    final themeProvider = Provider.of<ThemeProvider>(context);
    // if (boxtype==BoxType.searchUser) {

    // }
    return Container(
      padding: const EdgeInsets.all(22),
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
          CircleAvatar(
            radius: 35,
            foregroundImage: boxtype == BoxType.searchUser
                ? NetworkImage(url)
                : AssetImage("lib/assets/images/robot1.png"),
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
                      uname,
                      style:
                          TextStyle(color: themeProvider.fontclr, fontSize: 16),
                    ),
                    // Time aligned with the right of the name
                    chatboxtype == "searchUser"
                        ? Container(
                            child: Text('data'),
                          )
                        : Text(
                            lastseen,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                  ],
                ),
                // Message below the name
                Text(
                  lastMsg,
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
