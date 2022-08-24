import 'package:chat/Authservice.dart/chatuser.dart';
import 'package:chat/Chatservice/message.dart';
import 'package:chat/imageservice/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'consts.dart';
import 'package:chat/Chatservice/requestsender/requestsender.dart';

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
      {required String receivername,
      required String sendername,
      required bool arefriends}) async {
    try {
      if (arefriends) {
        final viewed = await FirebaseFirestore.instance
            .collection(receivername)
            .where(tobefriendname, isEqualTo: sendername)
            .get()
            .then((value) =>
                value.docs.map((e) => friend_ortobe.fromsnapshot(e)));
        await Imagetakeruploader()
            .deletesentimages(messagedocid: viewed.first.messagesdocid ?? '');
        final allmessagesdoc = await FirebaseFirestore.instance
            .collection(viewed.first.messagesdocid ?? '')
            .get()
            .then((value) => value);
        allmessagesdoc.docs.forEach((element) async {
          await FirebaseFirestore.instance
              .collection(viewed.first.messagesdocid ?? '')
              .doc(element.id)
              .delete();
        });
      }
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
        .where(tobefriendname, isEqualTo: sendername)
        .get()
        .then((value) => value);
    print(senderdocument);
    await FirebaseFirestore.instance
        .collection(receivername)
        .doc(senderdocument.docs.first.id)
        .delete();
  }

  Stream<Iterable<Message?>?> getmessages({required String messagesdocid}) {
    return FirebaseFirestore.instance
        .collection(messagesdocid)
        .orderBy(tImestamp, descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => Message.fromsnapshot(e)));
  }

  Future<void> acceptrfriendrequest(
      {required String username, required String friendname}) async {
    try {
      final userdocument = await FirebaseFirestore.instance
          .collection(username)
          .where(tobefriendname, isEqualTo: friendname)
          .get()
          .then((value) => value);
      await FirebaseFirestore.instance
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
      await FirebaseFirestore.instance
          .collection(friendname)
          .doc(frienddocument.docs.first.id)
          .update({
        status: 'friend',
      });
      await FirebaseFirestore.instance
          .collection(username + '*' + friendname)
          .add({});
      await FirebaseFirestore.instance
          .collection(username)
          .doc(userdocument.docs.first.id)
          .update({
        Messagesdocid: username + '*' + friendname,
      });
      await FirebaseFirestore.instance
          .collection(friendname)
          .doc(frienddocument.docs.first.id)
          .update({
        Messagesdocid: username + '*' + friendname,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> Sendmessage(
      {required String sendername,
      required String receivername,
      required String content,
      required String messcollid,
      required bool isimage}) async {
    final Messagecollection = FirebaseFirestore.instance.collection(messcollid);

    await Messagecollection.add({
      Sendername: sendername,
      Receivername: receivername,
      Content: content,
      Isimage: isimage,
      tImestamp: DateTime.now().microsecondsSinceEpoch,
    });
  }

  Future<void> deletemessage(
      {required Timestamp, required Messagedocid}) async {
    final doc = await FirebaseFirestore.instance
        .collection(Messagedocid)
        .where(tImestamp, isEqualTo: Timestamp)
        .get()
        .then((value) => value);
    await FirebaseFirestore.instance
        .collection(Messagedocid)
        .doc(doc.docs.first.id)
        .delete();
  }

  Widget deletemessagebar(
      {required Timestamp,
      required Messagedocid,
      required BuildContext context}) {
    return AlertDialog(
      content: Column(
        children: [
          Text('Do you want to delete this message'),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    await deletemessage(
                        Timestamp: Timestamp, Messagedocid: Messagedocid);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Stream<Iterable<chatuser>?>? get_searched({required String? text}) {
    if (text != null) {
      return FirebaseFirestore.instance.collection('users').snapshots().map(
          (event) => event.docs.map((e) => chatuser.fromsnapshot(e)).where(
              (element) => (element.Username?.contains(text) ??
                  element.Username != null)));
    }
    return FirebaseFirestore.instance.collection('users').snapshots().map(
        (event) => event.docs
            .map((e) => chatuser.fromsnapshot(e))
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
          final data = snapshot as AsyncSnapshot<Iterable<friend_ortobe>>?;

          if (data?.data?.isNotEmpty ?? false) {
            if (data?.data?.first == null) {
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
            } else if (data?.data?.first.Status == 'friend') {
              return Column(
                children: [
                  const Center(
                      child: Text(
                    'Friend',
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 178, 100, 192)),
                  )),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                      onPressed: () async {
                        await chatservice().abortfriendrequestordeletefriend(
                            receivername: username!,
                            sendername: viewedname!,
                            arefriends: true);
                      },
                      child: const Text(
                        'Unfriend',
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              );
            } else if (data?.data?.first.Status == 'request sender') {
              return Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                      onPressed: () async {
                        await chatservice().acceptrfriendrequest(
                            username: username!, friendname: viewedname!);
                      },
                      child: const Text(
                        'accept invitation',
                        style: TextStyle(color: Colors.purple),
                      )),
                  TextButton(
                      onPressed: () async {
                        await chatservice().abortfriendrequestordeletefriend(
                            receivername: username!,
                            sendername: viewedname!,
                            arefriends: false);
                      },
                      child: const Text('refuse invitation',
                          style: TextStyle(color: Colors.red))),
                ],
              );
            } else {
              return Row(
                children: [
                  const SizedBox(
                    width: 85,
                  ),
                  const Text('Invitation was sent'),
                  TextButton(
                      onPressed: () async {
                        await chatservice().cancelfriendrequest(
                            sendername: username!, receivername: viewedname!);
                      },
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.red)))
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
              child: const Text('send invitation',
                  style: TextStyle(color: Colors.purple)));
        }));
  }
}
