class ChatModel {
  String? id;
  String? message;
  String? senderName;
  String? senderId;
  String? receiverId;
  String? timestamp;
  String? readStatus;
  String? imgUrl;
  String? videoUrl;
  String? audioUrl;
  String? documentUrl;
  List<String>? reactions;
  List<dynamic>? replies;

  ChatModel(
      {this.id,
      this.audioUrl,
      this.documentUrl,
      this.imgUrl,
      this.message,
      this.reactions,
      this.readStatus,
      this.receiverId,
      this.replies,
      this.senderId,
      this.senderName,
      this.timestamp,
      this.videoUrl});

  ChatModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] is String) {
      id = json['id'];
    }
    if (json['message'] is String) {
      message = json['message'];
    }
    if (json['senderName'] is String) {
      senderName = json['senderName'];
    }
    if (json['senderId'] is String) {
      senderId = json['senderId'];
    }
    if (json['receiverId'] is String) {
      receiverId = json['receiverId'];
    }
    if (json['timestamp'] is String) {
      timestamp = json['timestamp'];
    }
    if (json['readStatus'] is String) {
      readStatus = json['readStatus'];
    }
    if (json['imgUrl'] is String) {
      imgUrl = json['imgUrl'];
    }
    if (json['videoUrl'] is String) {
      videoUrl = json['videoUrl'];
    }
    if (json['audioUrl'] is String) {
      audioUrl = json['audioUrl'];
    }
    if (json['documentUrl'] is String) {
      documentUrl = json['documentUrl'];
    }
    if (json['reactions'] is List) {
      reactions = json['reactions'] == null
          ? null
          : List<String>.from(json['reactions']);
    }
    if (json['replies'] is List) {
      replies = json['replies'] ?? [];
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;

    _data["message"] = message;

    _data["senderName"] = senderName;

    _data["senderId"] = senderId;

    _data["receiverId"] = receiverId;

    _data["timestamp"] = timestamp;

    _data["readStatus"] = readStatus;

    _data["imgUrl"] = imgUrl;

    _data["videoUrl"] = videoUrl;

    _data["audioUrl"] = audioUrl;

    _data["documentUrl"] = documentUrl;

    if (reactions != null) {
      _data["reactions"] = reactions;
    }

    if (replies != null) {
      _data["replies"] = replies;
    }

    return _data;
  }
}
