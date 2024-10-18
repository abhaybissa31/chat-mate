import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

// import 'package:flutter_riverpod/flutter_riverpod.dart';
class Loggeduser with ChangeNotifier {
  String currentUserId = auth.currentUser?.uid ?? '';
  Future<Map<String, String>> currentUserDetails() async {
    DocumentSnapshot userDoc =
        await db.collection('users').doc(currentUserId).get();

    Map<String, String> userDetails = {
      'uid': currentUserId,
      'username': '',
      'email': '',
      'image_url': ''
    };

    if (userDoc.exists) {
      userDetails['username'] = userDoc.get('username');
      userDetails['email'] = userDoc.get('email');
      userDetails['image_url'] = userDoc.get('image_url');
    }

    notifyListeners();
    return userDetails; // Return the user details map
  }

// Method to fetch all chats for the current user
}
