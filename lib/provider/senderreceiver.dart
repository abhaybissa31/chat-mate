import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/controller/chatcontroller.dart';

Chatcontroller chatController = Chatcontroller();
final senderDetailsProvider =
    FutureProvider.family<Map<String, String?>, String>((ref, senderId) async {
  return await chatController.getSenderDetails(senderId);
});

final receiverDetailsProvider =
    FutureProvider.family<Map<String, String?>, String>(
        (ref, receiverId) async {
  return await chatController.getReceiverDetails(receiverId);
});
