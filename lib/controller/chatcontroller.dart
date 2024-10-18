import 'package:chat_app/model/chatmodel.dart';
import 'package:chat_app/model/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
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
      participants: [currentUserId, targetUserId], // Add participants here
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

  Future<List<ChatRoomModel>> retrieveRoomDetailsForCurrentUser() async {
    String currentUserId = auth.currentUser!.uid;
    List<ChatRoomModel> chatRoomDetails = []; // List to hold the details

    try {
      // Query the 'chats' collection where currentUserId is in the 'participants' array
      QuerySnapshot chatRoomsSnapshot = await db
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .get();

      if (chatRoomsSnapshot.docs.isNotEmpty) {
        // Iterate through the documents and retrieve the necessary details
        for (var doc in chatRoomsSnapshot.docs) {
          String receiverId = doc.get('receiverId');
          String receiverName = doc.get('receiverUserName');
          String lastMessage = doc.get('lastMessage');
          String lastMessageTimestamp = doc.get('lastMessageTimestamp');

          // Fetch the receiver image from the 'users' collection using receiverId
          DocumentSnapshot userDoc =
              await db.collection('users').doc(receiverId).get();

          if (userDoc.exists) {
            String receiverImage = userDoc.get(
                'image_url'); // Assuming 'image_url' field in users document

            // Create a ChatRoomDetail object and add it to the list
            chatRoomDetails.add(ChatRoomModel(
              id: doc.id,
              receiverId: receiverId,
              receiverUserName: receiverName,
              recImage: receiverImage,
              lastMessage: lastMessage,
              lastMessageTimestamp: lastMessageTimestamp,
            ));
          } else {
            print('Receiver details not found for Receiver ID: $receiverId');
          }
        }
      } else {
        print('No chat rooms found for current user');
      }
    } catch (e) {
      print('Error retrieving room details: $e');
    }

    return chatRoomDetails; // Return the list of chat room details
  }

  // Query to get messages based on the roomId
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
