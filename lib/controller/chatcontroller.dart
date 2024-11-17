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

  Future<void> sendMessage(String targetUserId, String message,
      String? mediaUrl, String? mediaTyp) async {
    print('mediatyperece====================================$mediaTyp');
    messageQueue.add({
      'targetUserId': targetUserId,
      'message': message,
      'mediaUrl': mediaUrl ?? "",
      'mediaType': mediaTyp ?? "empty on chat controll"
    });
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
      final mediaType = messageData['mediaType'];
      final mediaUrl = messageData['mediaUrl'] ?? "epmpty final mediaUrl";

      try {
        String messageId = uid.v6();
        String roomId = getRoomId(targetUserId);
        // String senderName = await _getSenderName(currentUserId);
        var senderDetails = await getSenderDetails(currentUserId);
        var receiverDetails = await getReceiverDetails(targetUserId);

        // Create ChatModel instance for the message
        ChatModel sendChatModel = ChatModel(
          mediaType: mediaType,
          mediaUrl: mediaUrl,
          id: messageId,
          message: message,
          senderId: currentUserId,
          senderName: senderDetails['username'],
          receiverId: targetUserId,
          timestamp: DateTime.now().toString(),
        );
        print('-----------------------mediiaaaa$mediaUrl');
        print('--------------------Mediaaaaa11222$mediaType');

        // Create ChatRoomModel instance with participants
        var roomDetails = ChatRoomModel(
          id: roomId,
          lastMessage: message,
          lastMessageTimestamp: DateTime.now().toString(),
          // senderUserName: senderName,
          senderId: currentUserId,
          // senderEmail: auth.currentUser!.email,
          receiverId: targetUserId,
          // receiverUserName: receiverDetails['username'],
          // receiverEmail: receiverDetails['email'],
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

  Future<Map<String, String?>> getSenderDetails(String userId) async {
    DocumentSnapshot userDoc = await db.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return {
        'username': userDoc.get('username'),
        'image_url':
            userDoc.get('image_url') ?? "empty image on chatcontroller 101 ",
      };
    } else {
      print('sender not found');
      return {'username': null, 'image': null};
    }
  }

  Future<Map<String, String?>> getReceiverDetails(String targetUserId) async {
    DocumentSnapshot recDoc =
        await db.collection('users').doc(targetUserId).get();
    if (recDoc.exists) {
      return {
        'username': recDoc.get('username'),
        'image_url':
            recDoc.get('image_url') ?? "empty image on chatcontroller 101 ",
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
          .orderBy("lastMessageTimestamp", descending: true)
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
      // String? receiverName = doc.get('receiverUserName');
      String? senderId = doc.get('senderId');

      // Fetch images from the 'users' collection
      DocumentSnapshot userDoc =
          await db.collection('users').doc(receiverId).get();
      // DocumentSnapshot senderDoc =
      //     await db.collection('users').doc(senderId).get();

      if (userDoc.exists) {
        chatRoomDetails.add(ChatRoomModel(
          id: doc.id,
          // senderImage: senderDoc.get('imageUrl'),
          senderId: senderId,
          receiverId: receiverId,
          // senderUserName: doc.get('senderUserName'),
          // receiverUserName: receiverName,
          // recImage: userDoc.get('image_url') ?? "lib/assets/images/1.jpg",
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

  Stream<List<Map<String, dynamic>>> getFavContacts() async* {
    Map<String, int> contactMessageCount = {};

    try {
      // Listen to chat room snapshots
      await for (QuerySnapshot chatRoomsSnapshot in db
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .snapshots()) {
        // Iterate over each chat room
        for (var chatRoom in chatRoomsSnapshot.docs) {
          String roomId = chatRoom.id;
          var participants = chatRoom.get('participants') as List<dynamic>;

          // Get the other user's ID (excluding the current user)
          String otherUserId =
              participants.firstWhere((id) => id != currentUserId);

          // Get the number of messages exchanged in this chat room
          QuerySnapshot messageSnapshot = await db
              .collection('chats')
              .doc(roomId)
              .collection('messages')
              .get();

          contactMessageCount[otherUserId] = messageSnapshot.size;
        }

        // Fetch user details for each otherUserId
        List<Map<String, dynamic>> sortedContacts = [];

        for (var entry in contactMessageCount.entries) {
          String otherUserId = entry.key;

          // Fetch the user data for the otherUserId
          DocumentSnapshot userDoc =
              await db.collection('users').doc(otherUserId).get();

          if (userDoc.exists) {
            String username = userDoc.get('username') ?? 'Unknown User';
            String imageUrl = userDoc.get('image_url') ?? 'default_image_url';

            sortedContacts.add({
              'userId': otherUserId,
              'username': username,
              'profileImage': imageUrl,
              'messageCount': entry.value,
            });
          }
        }

        // Sort contacts by message count
        sortedContacts.sort(
          (a, b) =>
              (b['messageCount'] as int).compareTo(a['messageCount'] as int),
        );

        // Take only the top 10 users
        List<Map<String, dynamic>> topContacts =
            sortedContacts.take(10).toList();

        // Yield the top contacts
        yield topContacts;
      }
    } catch (e) {
      print("Error fetching favorite contacts: $e");
      yield [];
    }
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
