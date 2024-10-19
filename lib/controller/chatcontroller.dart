import 'package:chat_app/model/chatmodel.dart';
import 'package:chat_app/model/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

var uid = Uuid();

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

class Chatcontroller extends GetxController {
  String currentUserId = auth.currentUser?.uid ?? '';
  RxBool isLoading = false.obs;

  String getRoomId(String targetUserId) {
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
    String currentUserId = auth.currentUser!.uid;
    isLoading.value = true;
    var messageId = uid.v6();
    String roomId = getRoomId(targetUserId);

    // Retrieve sender's username from Firestore
    DocumentSnapshot userDoc =
        await db.collection('users').doc(currentUserId).get();

    // Check if document exists and retrieve the username
    String senderName;
    if (userDoc.exists) {
      senderName = userDoc.get('username'); // Get sender's name from Firestore
    } else {
      print("User document does not exist for userId: $currentUserId");
      senderName = "Unknown"; // Assign a default name if document doesn't exist
    }

    // Retrieve receiver's details from Firestore
    DocumentSnapshot recDoc =
        await db.collection('users').doc(targetUserId).get();
    Map<String, dynamic>? receiverData = recDoc.data() as Map<String, dynamic>?;
    String? receiverUserName;
    String? receiverEmail;
    if (receiverData != null) {
      receiverUserName = receiverData['username'];
      receiverEmail = receiverData['email'];
    } else {
      print('Receiver not found');
    }
    List<String>? participants =
        ([targetUserId, currentUserId] as List<dynamic>).cast<String>();
    // Create a ChatModel instance for the message
    ChatModel sendChatModel = ChatModel(
        id: messageId,
        message: message,
        senderId: currentUserId,
        senderName: senderName,
        receiverId: targetUserId,
        timestamp: DateTime.now().toString());

    // Create a ChatRoomModel instance with participants
    var roomDetails = ChatRoomModel(
      id: roomId,
      lastMessage: message,
      lastMessageTimestamp: DateTime.now().toString(),
      senderUserName: senderName,
      senderId: currentUserId,
      senderEmail: auth.currentUser!.email,
      receiverId: targetUserId,
      receiverUserName: receiverUserName,
      receiverEmail: receiverEmail,
      timestamp: DateTime.now().toString(),
      unReadMessNo: 0,
      participants: participants, // Add participants here
    );

    // Save roomDetails and message in Firestore
    try {
      // Save roomDetails with participants in the 'chats' collection
      await db.collection("chats").doc(roomId).set(roomDetails.toJson());

      // Save the message in the 'messages' subcollection
      await db
          .collection("chats")
          .doc(roomId)
          .collection("messages")
          .doc(messageId)
          .set(sendChatModel.toJson());
    } catch (e) {
      print('Error sending message: $e');
    }

    isLoading.value = false;
  }

  Stream<List<ChatRoomModel>> retrieveRoomDetailsStreamForCurrentUser() async* {
    String currentUserId = auth.currentUser!.uid;

    try {
      // Listen to the 'chats' collection for real-time updates where currentUserId is in the 'participants' array
      await for (QuerySnapshot chatRoomsSnapshot in db
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .snapshots()) {
        List<ChatRoomModel> chatRoomDetails = [];

        if (chatRoomsSnapshot.docs.isNotEmpty) {
          // Iterate through the documents and retrieve the necessary details
          for (var doc in chatRoomsSnapshot.docs) {
            String? receiverId = doc.get('receiverId');
            String? receiverName = doc.get('receiverUserName');
            String? lastMessage = doc.get('lastMessage');
            String? lastMessageTimestamp = doc.get('lastMessageTimestamp');
            String? senderUserName = doc.get('senderUserName');
            String? senderId = doc.get('senderId');
            // Fetch the receiver image from the 'users' collection using receiverId
            DocumentSnapshot userDoc =
                await db.collection('users').doc(receiverId).get();
            DocumentSnapshot senderDoc =
                await db.collection('users').doc(senderId).get();

            if (userDoc.exists) {
              String? senderImage = senderDoc.get('image_url');
              String? receiverImage = userDoc.get('image_url');
              DateTime timestamp = DateTime.parse(lastMessageTimestamp ?? "");
              String formattedTime = DateFormat('hh:mm a').format(timestamp);

              // Create a ChatRoomDetail object and add it to the list
              chatRoomDetails.add(ChatRoomModel(
                id: doc.id,
                senderImage: senderImage,
                senderId: senderId,
                receiverId: receiverId,
                senderUserName: senderUserName,
                receiverUserName: receiverName,
                recImage: receiverImage ?? "lib/assets/images/1.jpg",
                lastMessage: lastMessage,
                lastMessageTimestamp: formattedTime,
              ));
            }
          }
          yield chatRoomDetails; // Stream the list of chat room details
        }
      }
    } catch (e) {
      print('Error retrieving room details: $e');
      yield []; // In case of error, return an empty list
    }
  }

  // Query to get messages based on the roomId
  Stream<List<ChatModel>> getMessage(String targetUserId) {
    String roomId = getRoomId(targetUserId);
    return db
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatModel.fromJson(doc.data()))
            .toList());
  }
}
