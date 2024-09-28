import 'package:chat_app/model/chatmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

var uid = Uuid();

class Chatcontroller extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;

  String getRoomId(String targetUserId) {
    String currentUserId = auth.currentUser?.uid ?? '';

    if (currentUserId.isEmpty) {
      return 'Error: Current user ID is missing';
    }

    List<String> userIds = [targetUserId, currentUserId];
    userIds.sort();
    String roomId =
        "${userIds[0]}@${userIds[1]}"; // Join the sorted IDs with '@'

    return roomId;
  }

  Future<void> sendMessage(String targetUserId, String message) async {
    isLoading = true.obs;
    var messageId = uid.v6();
    String roomId = getRoomId(targetUserId);

    // Retrieve sender's username from Firestore
    String currentUserId = auth.currentUser!.uid;
    DocumentSnapshot userDoc =
        await db.collection('users').doc(currentUserId).get();
    print('---------------------------------curent uiser id $currentUserId');
    // Check if document exists and retrieve the username
    String senderName;
    if (userDoc.exists) {
      senderName = userDoc.get('username'); // Get sender's name from Firestore
    } else {
      print("User document does not exist for userId: $currentUserId");
      senderName = "Unknown"; // Assign a default name if document doesn't exist
    }

    ChatModel sendChatModel = ChatModel(
      id: messageId,
      message: message,
      senderId: currentUserId,
      senderName:
          senderName, // Include senderName in the model *****this is coming from firebase for now, change that so it only comes once we dont have to fetch again
      receiverId: targetUserId,
    );

    try {
      await db
          .collection("chats")
          .doc(roomId)
          .collection("messages")
          .doc(messageId)
          .set(sendChatModel.toJson());
    } catch (e) {
      print('Error sending message: $e');
    }
    isLoading = false.obs;
  }
}
