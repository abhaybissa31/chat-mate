import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Screens/splashscreen.dart';
import 'package:chat_app/provider/currentuserdetails.dart';
import 'package:chat_app/provider/theme.dart';
import 'package:chat_app/widget/bottomnav.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as prov;

class Setting extends ConsumerStatefulWidget {
  const Setting({super.key, required this.screeno});
  final int screeno;

  @override
  ConsumerState<Setting> createState() => _SettingState();
}

class _SettingState extends ConsumerState<Setting> {
  void initState() {
    ref.read(currentUserImageProvider.notifier).fetchImageUrl();
    ref.read(currentUserUserNameProvider.notifier).fetchUsername();
    ref.read(currentUserEmailProvider.notifier).fetchEmail();
    super.initState();
    // chatController.retrieveRoomDetailsStreamForCurrentUser();
    // _loadChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = prov.Provider.of<ThemeProvider>(context);
    ref.read(currentUserImageProvider.notifier);
    final String? imageUrl = ref.watch(currentUserImageProvider);
    final currentUserId = ref.watch(currentUserIdProvider);
    final currentUserEmail = ref.watch(currentUserEmailProvider);
    final currentUserUserName = ref.watch(currentUserUserNameProvider);
    var Tstyle = TextStyle(color: themeProvider.fontclr);

    return Scaffold(
      backgroundColor: themeProvider.listcolor,
      bottomNavigationBar: const BottomNav(
        whichscreen: 2,
      ),
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didpop, idk) {
          if (didpop) {
            print('$didpop popped');
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                // Optionally add a clip behavior if desired
              ),
              clipBehavior: Clip
                  .antiAlias, // Ensures the image respects the border radius
              child: imageUrl.toString().isEmpty
                  ? Image.asset('lib/assets/images/robot1.png')
                  : CachedNetworkImage(
                      imageUrl: imageUrl.toString(),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.5,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.fill,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
              // : Image.network(
              //     imageUrl.toString(),
              //     width: MediaQuery.of(context).size.width, // Full width
              //     height: MediaQuery.of(context).size.height /
              //         2.5, // Set desired height for the rectangle
              //     excludeFromSemantics: true,
              //     filterQuality: FilterQuality.high,
              //     isAntiAlias: true,
              //     fit:
              //         BoxFit.fill, // Ensures the image covers the container
              //   ),
            ),
            SingleChildScrollView(
              child: ListView.custom(
                shrinkWrap: true, // Makes ListView take only the space it needs
                childrenDelegate: SliverChildListDelegate(
                  [
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      enableFeedback: true,
                      leading: Icon(
                        CupertinoIcons.person_crop_circle,
                        color: themeProvider.fontclr,
                        size: 45,
                      ),
                      title: Text(
                        "User Name",
                        style: TextStyle(
                            color: themeProvider.fontclr, fontSize: 19),
                      ),
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize
                            .min, // Ensures the Row only takes the needed space
                        children: [
                          Text(
                            currentUserUserName! + " ",
                            style: TextStyle(
                                color: themeProvider.altfontclt, fontSize: 18),
                          ),
                          Icon(
                            Icons.edit,
                            color: themeProvider.altfontclt,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(23, 0, 20, 0),
                      enableFeedback: true,
                      leading: Icon(
                        CupertinoIcons.at,
                        color: themeProvider.fontclr,
                        size: 40,
                      ),
                      title: Text(
                        "Email",
                        style: TextStyle(
                            color: themeProvider.fontclr, fontSize: 19),
                      ),
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize
                            .min, // Ensures the Row only takes the needed space
                        children: [
                          Text(
                            currentUserEmail! + " " ?? "",
                            style: TextStyle(
                                color: themeProvider.altfontclt, fontSize: 18),
                          ),
                          Icon(
                            Icons.edit,
                            color: themeProvider.altfontclt,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(23, 0, 20, 0),
                      enableFeedback: true,
                      leading: Icon(
                        themeProvider.isDarkMode
                            ? CupertinoIcons.moon_fill
                            : CupertinoIcons.sun_max_fill,
                        color: themeProvider.fontclr,
                        size: 40,
                      ),
                      title: Text(
                        "Dark Mode",
                        style: TextStyle(
                            color: themeProvider.fontclr, fontSize: 19),
                      ),
                      trailing: Switch(
                          activeColor: themeProvider.altfontclt,
                          inactiveThumbColor: themeProvider.fontclr,
                          value: themeProvider.isDarkMode,
                          onChanged: (isChanged) {
                            setState(() {
                              isChanged = true;
                              themeProvider.toggleTheme();
                            });
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.all(25.0),
                      child: OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(themeProvider.altfontclt),
                          enableFeedback: true,
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          ScaffoldMessenger.of(context).clearMaterialBanners();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.black,
                              content: Text("Logged out"),
                            ),
                          );
                          PageChange.changeScreen(
                              context, const SplashScreen());
                        },
                        child: const Text(
                          "LogOut",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


  // child: Image.network(
  //                 // scale: 100,
  //                 imageUrl.toString(),
  //                 width: 150, // Match the width of the container
  //                 height: 150, // Match the height of the container
  //                 excludeFromSemantics: true,
  //                 filterQuality: FilterQuality.high,
  //                 isAntiAlias: true,
  //                 fit: BoxFit
  //                     .scaleDown, // Optional: ensure the image covers the container
  //               ),