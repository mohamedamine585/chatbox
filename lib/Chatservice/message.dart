import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/Chatservice/consts.dart';

class Message {
  final String content;
  final int timestamp;
  final String docid;
  final String sendername;
  final String receivername;
  const Message(
      {required this.content,
      required this.timestamp,
      required this.docid,
      required this.receivername,
      required this.sendername});
  Message.fromsnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : docid = snapshot.id,
        content = snapshot.data()[Content] as String,
        timestamp = snapshot.data()[tImestamp] as int,
        sendername = snapshot.data()[Sendername] as String,
        receivername = snapshot.data()[Receivername] as String;
}
