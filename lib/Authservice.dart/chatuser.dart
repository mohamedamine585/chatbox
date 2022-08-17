import 'package:cloud_firestore/cloud_firestore.dart';

import '../Chatservice/consts.dart';

class chatuser {
  final String docid;
  final String? Username;
  final String? email;
  final String? photourl;

  const chatuser(
      {required this.Username,
      required this.email,
      required this.photourl,
      required this.docid});
  chatuser.fromsnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : docid = snapshot.id,
        email = snapshot.data()[chatuser_email] as String?,
        Username = snapshot.data()[chatuser_name] as String?,
        photourl = snapshot.data()[userphotourl] as String?;
}
