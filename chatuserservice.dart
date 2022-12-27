
import 'package:chat/Chatservice/chatuser/chatUser.dart';
import 'package:chat/Chatservice/chatuser/requestsender/receiver.dart';
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
    await FirebaseFirestore.instance.collection(name).add({});
    return chatUser(
      docid: document.id,
      Username: name,
      email: email,
      photourl: userphotourl,
    );
  }

  Stream<Iterable<friend_ortobe?>?> getallfriends({required String Username}) {
    return FirebaseFirestore.instance.collection(Username).snapshots().map(
        (event) => event.docs
            .map((e) => friend_ortobe.fromsnapshot(e))
            .where((element) => element.Status == 'friend'));
  }

  Stream<Iterable<friend_ortobe?>?> getrequestsenders(
      {required String Username}) {
    return FirebaseFirestore.instance.collection(Username).snapshots().map(
        (event) => event.docs
            .map((e) => friend_ortobe.fromsnapshot(e))
            .where((element) => element.Status == 'request receiver'));
  }

  Stream<Iterable<chatUser?>?> getuserforphoto({required String? email}) {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
        (event) => event.docs
            .map((e) => chatUser.fromsnapshot(e))
            .where((element) => element.email == email));
  }
}
