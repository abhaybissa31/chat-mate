import 'dart:collection';

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
  Queue<Map<String, String>> messageQueue = Queue(); // Queue to hold messages
  bool isSending = false;

  String getRoomId(String targetUserId) {
    if (currentUserId.isEmpty) {
      return 'Error: Current user ID is missing';
    }

    List<String> userIds = [targetUserId, currentUserId];
    userIds.sort();
    return "${userIds[0]}@${userIds[1]}"; // Join the sorted IDs with '@'
  }

  Future<void> sendMessage(String targetUserId, String message) async {
    messageQueue.add({'targetUserId': targetUserId, 'message': message});
    _processQueue(); // Start processing the queue
  }

  void _processQueue() async {
    if (isSending || messageQueue.isEmpty) return;

    isSending = true; // Set the flag to true
    isLoading.value = true;

    while (messageQueue.isNotEmpty) {
      final messageData = messageQueue.removeFirst();
      final targetUserId = messageData['targetUserId']!;
      final message = messageData['message']!;

      try {
        String messageId = uid.v6();
        String roomId = getRoomId(targetUserId);
        String senderName = await _getSenderName(currentUserId);
        var receiverDetails = await _getReceiverDetails(targetUserId);

        // Create ChatModel instance for the message
        ChatModel sendChatModel = ChatModel(
          id: messageId,
          message: message,
          senderId: currentUserId,
          senderName: senderName,
          receiverId: targetUserId,
          timestamp: DateTime.now().toString(),
        );

        // Create ChatRoomModel instance with participants
        var roomDetails = ChatRoomModel(
          id: roomId,
          lastMessage: message,
          lastMessageTimestamp: DateTime.now().toString(),
          senderUserName: senderName,
          senderId: currentUserId,
          senderEmail: auth.currentUser!.email,
          receiverId: targetUserId,
          receiverUserName: receiverDetails['username'],
          receiverEmail: receiverDetails['email'],
          timestamp: DateTime.now().toString(),
          unReadMessNo: 0,
          participants: [targetUserId, currentUserId],
        );

        // Save roomDetails and message in Firestore
        await _saveChatAndMessage(roomId, roomDetails, sendChatModel);
      } catch (e) {
        print('Error sending message: $e');
      }
    }

    isSending = false; // Reset the flag
    isLoading.value = false; // Hide loading state
  }

  Future<String> _getSenderName(String userId) async {
    DocumentSnapshot userDoc = await db.collection('users').doc(userId).get();
    return userDoc.exists ? userDoc.get('username') : "Unknown";
  }

  Future<Map<String, String?>> _getReceiverDetails(String targetUserId) async {
    DocumentSnapshot recDoc =
        await db.collection('users').doc(targetUserId).get();
    if (recDoc.exists) {
      return {
        'username': recDoc.get('username'),
        'email': recDoc.get('email'),
      };
    } else {
      print('Receiver not found');
      return {'username': null, 'email': null};
    }
  }

  Future<void> _saveChatAndMessage(
      String roomId, ChatRoomModel roomDetails, ChatModel sendChatModel) async {
    await db.collection("chats").doc(roomId).set(roomDetails.toJson());
    await db
        .collection("chats")
        .doc(roomId)
        .collection("messages")
        .doc(sendChatModel.id)
        .set(sendChatModel.toJson());
  }

  Stream<List<ChatRoomModel>> retrieveRoomDetailsStreamForCurrentUser() async* {
    try {
      await for (QuerySnapshot chatRoomsSnapshot in db
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .snapshots()) {
        yield await _mapChatRoomSnapshots(chatRoomsSnapshot.docs);
      }
    } catch (e) {
      print('Error retrieving room details: $e');
      yield []; // In case of error, return an empty list
    }
  }

  Future<List<ChatRoomModel>> _mapChatRoomSnapshots(
      List<QueryDocumentSnapshot> docs) async {
    List<ChatRoomModel> chatRoomDetails = [];
    for (var doc in docs) {
      String? receiverId = doc.get('receiverId');
      String? receiverName = doc.get('receiverUserName');
      String? senderId = doc.get('senderId');

      // Fetch images from the 'users' collection
      DocumentSnapshot userDoc =
          await db.collection('users').doc(receiverId).get();
      DocumentSnapshot senderDoc =
          await db.collection('users').doc(senderId).get();

      if (userDoc.exists) {
        chatRoomDetails.add(ChatRoomModel(
          id: doc.id,
          senderImage: senderDoc.get('image_url'),
          senderId: senderId,
          receiverId: receiverId,
          senderUserName: doc.get('senderUserName'),
          receiverUserName: receiverName,
          recImage: userDoc.get('image_url') ?? "lib/assets/images/1.jpg",
          lastMessage: doc.get('lastMessage'),
          lastMessageTimestamp:
              _formatTimestamp(doc.get('lastMessageTimestamp')),
        ));
      }
    }
    return chatRoomDetails; // Return the mapped chat room details
  }

  String _formatTimestamp(String? timestamp) {
    DateTime dateTime = DateTime.parse(timestamp ?? "");
    return DateFormat('hh:mm a').format(dateTime);
  }

  Stream<List<ChatModel>> getMessage(String targetUserId) {
    String roomId = getRoomId(targetUserId);
    return db
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy("timestamp", descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatModel.fromJson(doc.data()))
            .toList());
  }
}
