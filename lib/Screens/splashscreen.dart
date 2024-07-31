import 'dart:async';

import 'package:chat_app/Screens/login_signup.dart';
// import 'package:favorite_places/screens/places.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
     const Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginSignup(),
        ),
      ),
    );

    // var assetsImage = const AssetImage(
    //     'lib/assets/images/placeholder.png'); //<- Creates an object that fetches an image.
    // var image = Image(
    //     image: assetsImage,
    //     height: 300); //<- Creates a widget that displays an image.

    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   // title: Text("MyApp"),
        //   backgroundColor:
        //       Colors.blue, //<- background color to combine with the picture :-)
        // ),
        body: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // Image.asset("lib/assets/images/maps.png",color: Colors.white,scale:2.8,filterQuality: FilterQuality.high, ),
              const SizedBox(height: 40,),
              Text('ChatMate',style:GoogleFonts.russoOne(fontSize: 60,color: Colors.white, fontWeight: FontWeight.w100), ),
            ],),
          ),
        ), //<- place where the image appears
      ),
    );
  }
}
