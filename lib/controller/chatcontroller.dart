import 'package:chat_app/model/chatmodel.dart';
import 'package:chat_app/model/chatroom.dart';
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
    DocumentSnapshot recDoc =
        await db.collection('users').doc(targetUserId).get();
    // print('-----------rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
    // print(recDoc.data());
    Map<String, dynamic>? receiverData = recDoc.data() as Map<String, dynamic>?;
    // print(receiverData);
    String? receiverUserName;
    String? receiverEmail;
    if (receiverData != null || receiverData!.isNotEmpty) {
      receiverUserName =
          receiverData['username']; // Assuming the field is 'name'
      receiverEmail = receiverData['email'];

      print(receiverEmail! +
          " " +
          receiverUserName!); // Assuming the field is 'email'
      // Add any other fields you need to access here
    } else {
      print('Receiver not found');
    }
    print('---------------------------------curent uiser id $currentUserId');
    ChatModel sendChatModel = ChatModel(
        id: messageId,
        message: message,
        senderId: currentUserId,
        senderName:
            senderName, // Include senderName in the model *****this is coming from firebase for now, change that so it only comes once we dont have to fetch again
        receiverId: targetUserId,
        timestamp: DateTime.now().toString());

    var roomDetails = ChatRoomModel(
      id: roomId,
      lastMessage: message,
      lastMessageTimestamp: DateTime.now().toString(),
      senderUserName: senderName,
      senderId: auth.currentUser!.uid,
      senderEmail: auth.currentUser!.email,
      receiverId: targetUserId,
      receiverUserName: receiverUserName,
      receiverEmail: receiverEmail,
      timestamp: DateTime.now().toString(),
      unReadMessNo: 0,
    );
    try {
      await db.collection("chats").doc(roomId).set(roomDetails.toJson());
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

  Stream<List<ChatModel>> getMessage(String targetUserId) {
    String roomId = getRoomId(targetUserId);
    return db
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatModel.fromJson(doc.data()))
            .toList());
  }
}
