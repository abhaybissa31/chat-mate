import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/provider/theme.dart';
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
    this.lastseen,
    this.url = "",
  });

  final String uname;
  final String lastMsg;
  final BoxType boxtype;
  final String? lastseen; // Make lastseen nullable if optional
  final dynamic url;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Debugging statement to check uname value
    // print('ChatBox Uname: $uname');

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
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
              foregroundImage:
                  url.toString() == "lib/assets/images/robot1.png" ||
                          url.toString().isEmpty
                      ? AssetImage("lib/assets/images/robot1.png")
                      : CachedNetworkImageProvider(url)
              // : NetworkImage(url),
              ),
          const SizedBox(width: 12),
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
                    Text(
                      lastseen ?? '', // Default text if lastseen is null
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                // Message below the name
                Text(
                  lastMsg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
