enum messagetype {
  text,
  image,
  audio,
  video,
  file,
}

class Message {
  String text;
  bool isImage;
  DateTime sentAt;
  String senderId;
  String conversationId;
  Message(
      this.text, this.isImage, this.conversationId, this.senderId, this.sentAt);
}
