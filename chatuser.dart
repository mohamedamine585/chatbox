import 'package:cloud_firestore/cloud_firestore.dart';

import '../Chatservice/consts.dart';

class chatuser {
  final String docid;
  final String? Username;
  final String? email;
  final String? photourl;
  final String? hashedpassword;
  final bool? isemailverified;
  int? onnotbadge;
  chatuser(
      {required this.Username,
      required this.email,
      required this.photourl,
      required this.docid,
      required this.hashedpassword,
      this.onnotbadge,
      this.isemailverified});
  chatuser.fromsnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : docid = snapshot.id,
        email = snapshot.data()[chatuser_email] as String?,
        Username = snapshot.data()[chatuser_name] as String?,
        hashedpassword = snapshot.data()[Hashedpassword] as String?,
        photourl = snapshot.data()[userphotourl] as String?,
        onnotbadge = snapshot.data()[Onnotbadge] as int?,
        isemailverified = snapshot.data()[Isemailverified] as bool?;
}
