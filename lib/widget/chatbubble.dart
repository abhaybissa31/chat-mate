import 'package:chat_app/provide/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {super.key,
      required this.message,
      required this.receiving,
      required this.time,
      required this.mediaUrl,
      required this.status});
  final String message;
  final bool receiving;
  final String time;
  final String mediaUrl;
  final String status;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            receiving ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width / 1.6),
              decoration: BoxDecoration(
                color: themeProvider.chngcolor,
                borderRadius: receiving
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(10),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(0),
                      ),
              ),
              child: mediaUrl == ""
                  ? Text(
                      message,
                      style: TextStyle(
                          fontSize: 16.9, color: themeProvider.fontclr),
                    )
                  : Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(mediaUrl)),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          message,
                          style: TextStyle(
                              fontSize: 16.9, color: themeProvider.fontclr),
                        ),
                      ],
                    )),
          const SizedBox(
            height: 10,
          ),
          receiving
              ? Text(time)
              : Row(
                  mainAxisAlignment: receiving
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    const Icon(
                      CupertinoIcons.checkmark_circle,
                      size: 20,
                    ),
                    Text(time)
                  ],
                )
        ],
      ),
    );
  }
}
