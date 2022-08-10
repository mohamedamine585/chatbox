import 'package:chat_box/authservice/authservice.dart';
import 'package:chat_box/chatservice/chatuser/chatUser.dart';
import 'package:chat_box/chatservice/chatuser/chatuserservice.dart';
import 'package:chat_box/chatservice/chatuser/consts.dart';
import 'package:chat_box/chatservice/chatuser/requestsender/receiver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class chatservice {
  Future<void> sendfriendrequest(
      {required String sendername,
      required String senderemail,
      required String receivername,
      required String receiveremail}) async {
    try {
      await FirebaseFirestore.instance.collection(sendername).add({
        tobefriendname: receivername,
        frortobeemail: receiveremail,
        status: 'request receiver',
      });
      await FirebaseFirestore.instance.collection(receivername).add({
        tobefriendname: sendername,
        frortobeemail: senderemail,
        status: 'request sender',
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> abortfriendrequestordeletefriend(
      {required String receivername, required String sendername}) async {
    try {
      final senderdocument = await FirebaseFirestore.instance
          .collection(receivername)
          .where(tobefriendname, isEqualTo: sendername)
          .get()
          .then((value) => value);
      await FirebaseFirestore.instance
          .collection(receivername)
          .doc(senderdocument.docs.first.id)
          .delete();
      final receiverdocument = await FirebaseFirestore.instance
          .collection(sendername)
          .where(tobefriendname, isEqualTo: receivername)
          .get()
          .then((value) => value);
      await FirebaseFirestore.instance
          .collection(sendername)
          .doc(receiverdocument.docs.first.id)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> cancelfriendrequest(
      {required String sendername, required String receivername}) async {
    final receiverdocument = await FirebaseFirestore.instance
        .collection(sendername)
        .where(tobefriendname, isEqualTo: receivername)
        .get()
        .then((value) => value);
    await FirebaseFirestore.instance
        .collection(sendername)
        .doc(receiverdocument.docs.first.id)
        .delete();
    final senderdocument = await FirebaseFirestore.instance
        .collection(receivername)
        .where(tobefriendname, isEqualTo: receivername)
        .get()
        .then((value) => value);
    await FirebaseFirestore.instance
        .collection(receivername)
        .doc(senderdocument.docs.first.id)
        .delete();
  }

  Future<void> acceptrfriendrequest(
      {required String username, required String friendname}) async {
    try {
      final userdocument = await FirebaseFirestore.instance
          .collection(username)
          .where(tobefriendname, isEqualTo: friendname)
          .get()
          .then((value) => value);
      FirebaseFirestore.instance
          .collection(username)
          .doc(userdocument.docs.first.id)
          .update({
        status: 'friend',
      });

      final frienddocument = await FirebaseFirestore.instance
          .collection(friendname)
          .where(tobefriendname, isEqualTo: username)
          .get()
          .then((value) => value);
      FirebaseFirestore.instance
          .collection(friendname)
          .doc(frienddocument.docs.first.id)
          .update({
        status: 'friend',
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> Sendmessage(
      {required String sendername,
      required String receivername,
      required String text}) async {
    try {
      await FirebaseFirestore.instance.collection('messages').add({
        message: text,
        sender: sendername,
        receiver: receivername,
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<Iterable<chatUser>?>? get_searched({required String? text}) {
    if (text != null) {
      return FirebaseFirestore.instance.collection('users').snapshots().map(
          (event) => event.docs.map((e) => chatUser.fromsnapshot(e)).where(
              (element) => (element.Username?.contains(text) ??
                  element.Username != null)));
    }
    return FirebaseFirestore.instance.collection('users').snapshots().map(
        (event) => event.docs
            .map((e) => chatUser.fromsnapshot(e))
            .where((element) => element != null));
  }

  Widget checkifrequestissent(
      {required String? username,
      required String? useremail,
      required String? viewedname,
      required String? viewedemail}) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(username ?? '')
            .snapshots()
            .map(((event) => event.docs
                .map((e) => friend_ortobe.fromsnapshot(e))
                .where((element) => element.name == viewedname))),
        builder: ((context, snapshot) {
          final data = snapshot.data;

          if (snapshot.data?.length != 0) {
            if (data?.first == null) {
              return TextButton(
                  onPressed: () async {
                    print(username);
                    await chatservice().sendfriendrequest(
                        sendername: username!,
                        senderemail: useremail!,
                        receivername: viewedname!,
                        receiveremail: viewedemail!);
                  },
                  child: const Text('send chat invitation'));
            } else if (snapshot.data?.first.Status == 'friend') {
              return Column(
                children: [
                  const Center(
                      child: Text(
                    'Friend',
                    style: TextStyle(fontSize: 25),
                  )),
                  TextButton(
                      onPressed: () async {
                        await chatservice().abortfriendrequestordeletefriend(
                            receivername: username!, sendername: viewedname!);
                      },
                      child: const Text('Delete from friend list'))
                ],
              );
            } else if (snapshot.data?.first.Status == 'request sender') {
              return Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        await chatservice().acceptrfriendrequest(
                            username: username!, friendname: viewedname!);
                      },
                      child: const Text('accept invitation')),
                  TextButton(
                      onPressed: () async {
                        await chatservice().abortfriendrequestordeletefriend(
                            receivername: username!, sendername: viewedname!);
                      },
                      child: const Text('refuse invitation')),
                ],
              );
            } else {
              return Row(
                children: [
                  const Text('Invitation was sent'),
                  TextButton(
                      onPressed: () async {
                        await chatservice().cancelfriendrequest(
                            sendername: username!, receivername: viewedname!);
                      },
                      child: const Text('Cancel'))
                ],
              );
            }
          }
          return TextButton(
              onPressed: () async {
                await sendfriendrequest(
                    sendername: username!,
                    senderemail: useremail!,
                    receivername: viewedname!,
                    receiveremail: viewedemail!);
              },
              child: const Text('send invitation'));
        }));
  }
}
