import 'package:cloud_firestore/cloud_firestore.dart';

import 'consts.dart';

class chatUser {
  final String docid;
  final String Username;
  final String email;
  final String photourl;

  const chatUser(
      {required this.Username,
      required this.email,
      required this.photourl,
      required this.docid});
  chatUser.fromsnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : docid = snapshot.id,
        email = snapshot.data()[chatuser_email] as String,
        Username = snapshot.data()[chatuser_name] as String,
        photourl = snapshot.data()[userphotourl] as String;
}
