import 'package:chat_box/chatservice/chatuser/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class friend_ortobe {
  final String? name;
  final String? Status;
  final String? email;
  final String docid;
  final String? messagesdocid;
  friend_ortobe(
      this.name, this.email, this.Status, this.docid, this.messagesdocid);
  friend_ortobe.fromsnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : docid = snapshot.id,
        name = snapshot.data()[tobefriendname] as String?,
        Status = snapshot.data()[status] as String?,
        email = snapshot.data()[frortobeemail] as String?,
        messagesdocid = snapshot.data()[Messagesdocid] as String?;
}
