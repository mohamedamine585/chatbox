import 'package:chat_box/chatservice/chatuser/chatUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'consts.dart';

class chatuserservice {
  final users = FirebaseFirestore.instance.collection('users');
  Future<Iterable<chatUser?>?> get_user({required String? email}) async {
    try {
      return await users
          .where(
            chatuser_email,
            isEqualTo: email,
          )
          .get()
          .then((value) => value.docs.map((doc) => chatUser.fromsnapshot(doc)));
    } catch (e) {
      print(e);
    }
  }

  Future<chatUser?> create_user(
      {required String email,
      required String name,
      required String photourl}) async {
    final document = await users.add({
      chatuser_email: email,
      chatuser_name: name,
      userphotourl: photourl,
    });
    await FirebaseFirestore.instance.collection(chatuser_name).add({});
    return chatUser(
      docid: document.id,
      Username: name,
      email: email,
      photourl: userphotourl,
    );
  }
}
