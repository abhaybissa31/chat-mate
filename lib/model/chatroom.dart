class ChatRoomModel {
  String? id;
  // String? senderUserName;
  String? senderId;
  // String? senderEmail;
  String? receiverId;
  // String? receiverUserName;
  // String? receiverEmail;
  List<String>? messages;
  int? unReadMessNo;
  String? lastMessage;
  String? lastMessageTimestamp;
  List<String>? participants;
  String? timestamp;
  // String? recImage;
  // String? senderImage;

  ChatRoomModel(
      {this.id,
      this.participants,
      // this.senderUserName,
      // this.senderImage,
      // this.senderEmail,
      // this.recImage,
      // this.receiverEmail,
      this.receiverId,
      // this.receiverUserName,
      this.messages,
      this.senderId,
      this.unReadMessNo,
      this.lastMessage,
      this.lastMessageTimestamp,
      this.timestamp});

  ChatRoomModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    // if (json["senderUserName"] is String) {
    //   senderUserName = json["senderUserName"] == null
    //       ? null
    //       : (json["senderUserName"].toString());
    // }

    // if (json["senderImage"] is String) {
    //   senderImage =
    //       json["senderImage"] == null ? null : (json["senderImage"].toString());
    // }

    if (json["participants"] is List) {
      participants = json["participants"] ?? [];
    }

    // if (json["senderEmail"] is String) {
    //   senderEmail =
    //       json["senderEmail"] == null ? null : (json["senderEmail"].toString());
    // }

    if (json["senderId"] is String) {
      senderId =
          json["senderId"] == null ? null : (json["senderId"].toString());
    }

    if (json["receiverId"] is String) {
      receiverId =
          json["receiver"] == null ? null : (json["receiverId"].toString());
    }
    // if (json["receiverEmail"] is String) {
    //   receiverEmail = json["receiverEmail"] == null
    //       ? null
    //       : (json["receiverEmail"].toString());
    // }
    // if (json["receiverUserName"] is String) {
    //   receiverUserName = json["receiverUserName"] == null
    //       ? null
    //       : (json["receiverUserName"].toString());
    // }
    if (json["messages"] is List) {
      messages = json["messages"] ?? [];
    }
    if (json["unReadMessNo"] is int) {
      unReadMessNo = json["unReadMessNo"];
    }
    if (json["lastMessage"] is String) {
      lastMessage = json["lastMessage"];
    }
    if (json["lastMessageTimestamp"] is String) {
      lastMessageTimestamp = json["lastMessageTimestamp"];
    }
    if (json["timestamp"] is String) {
      timestamp = json["timestamp"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if (senderId != null) {
      _data["senderId"] = senderId?.toString();
    }
    if (receiverId != null) {
      _data["receiverId"] = receiverId?.toString();
    }
    if (messages != null) {
      _data["messages"] = messages;
    }

    if (participants != null) {
      _data["participants"] = participants;
    }
    _data["unReadMessNo"] = unReadMessNo;
    _data["lastMessage"] = lastMessage;
    _data["lastMessageTimestamp"] = lastMessageTimestamp;
    _data["timestamp"] = timestamp;
    return _data;
  }
}
