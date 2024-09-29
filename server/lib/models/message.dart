class Message {

  int id;
  String content;
  MessageType type;
  String senderId;
  DateTime sentAt;
  
  Message({required this.id,required this.senderId , required this.content , required this.type , required this.sentAt});

 // Convert Message to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.toString().split('.').last,
      'senderId': senderId,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}

enum MessageType {
  text,
  image,
  audio,
  video,
  reel,
  undefined,

}

MessageType messageTypeFromString(String value){
  switch (value) {
    case "text":
       return MessageType.text;
      
    case "audio":
       return MessageType.audio;
      
    case "video":
       return MessageType.video;
    case "reel":
       return MessageType.reel;
    case "image":
       return MessageType.image;
    default:
    return MessageType.undefined;
  }
}