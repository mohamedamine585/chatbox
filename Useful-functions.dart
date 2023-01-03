import 'dart:developer';
import 'dart:ui';

import 'package:chat/Chatservice/chatuser/requestsender/receiver.dart';
import 'package:chat/Views/chatuserview.dart';
import 'package:chat/Views/consts.dart';
import 'package:chat/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Authservice.dart/chatuser.dart';
import 'Chatservice/chatservice.dart';
import 'Chatservice/chatuser/chatuserservice.dart';
import 'Chatservice/chatuser/consts.dart';
import 'Views/Chatview.dart';

Future<bool?> showerrordialog({
  required BuildContext context,
  required String title,
  required String text,
  required String keybutton,
}) {
  return showDialog<bool>(
    context: context,
    builder: ((context) {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 219, 210, 210),
        title: Text('$title'),
        content: Text(text),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                keybutton,
                style: const TextStyle(color: Colors.purple),
              )),
        ],
      );
    }),
  );
}

Future<bool?> showgenericdialog({
  required BuildContext context,
  required String title,
  required String text,
  required String truekeybutton,
  required String falsekeybutton,
}) {
  return showDialog<bool>(
    context: context,
    builder: ((context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 240, 233, 233),
        title: Text(
          title,
          style: TextStyle(color: Colors.purple),
        ),
        content: Text(text),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                falsekeybutton,
                style: const TextStyle(color: Colors.red),
              )),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                truekeybutton,
                style: const TextStyle(color: Colors.purple),
              ))
        ],
      );
    }),
  );
}

Future<bool?> showmenu(
    {required BuildContext context,
    required chatuser? user,
    required chatuser? friend}) async {
  friend_ortobe? friendD = (await FirebaseFirestore.instance
          .collection(user?.Username ?? '')
          .snapshots()
          .map((event) => event.docs
              .map((e) => friend_ortobe.fromsnapshot(e))
              .where((element) =>
                  element.Status == 'friend' ||
                  element.Status == 'block' ||
                  element.Status == 'blocked'))
          .firstWhere((element) => element.first.name == friend?.Username))
      .first;
  return showCupertinoModalPopup<bool>(
      context: context,
      builder: ((context) {
        return Container(
          width: 340,
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              block_unblock(
                  context: context,
                  user: user,
                  friend: friend,
                  friend_d: friendD),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () async {
                    if (friendD.Status == "friend") {
                      Navigator.of(context).pushNamed('crateroomview',
                          arguments: [user, friend]);
                    } else if (friendD.Status == 'blocked') {
                      await showerrordialog(
                          context: context,
                          title: "Stream Security Team",
                          text: "${friendD.name} Blocked you",
                          keybutton: "Ok");
                    } else {
                      if ((await showgenericdialog(
                              context: context,
                              title: "Stream Security Team",
                              text:
                                  "Dou you want to Unblock ${friend?.Username}",
                              truekeybutton: "Yes",
                              falsekeybutton: "No") ??
                          false)) {
                        await chatservice().abortfriendrequestordeletefriend(
                            receivername: user?.Username ?? '',
                            sendername: friend?.Username ?? '',
                            arefriends: true);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            'homeview', (route) => false);
                      }
                    }
                  },
                  child: const Text(
                    "Create room",
                    style: TextStyle(color: Colors.purple, fontSize: 20),
                  )),
              TextButton(
                onPressed: () async {
                  if ((await showgenericdialog(
                          context: context,
                          title: "Stream Security Team",
                          text: "Dou you want to Unfriend ${friend?.Username}",
                          truekeybutton: "Yes",
                          falsekeybutton: "No") ??
                      false)) {
                    await chatservice().abortfriendrequestordeletefriend(
                        receivername: user?.Username ?? '',
                        sendername: friend?.Username ?? '',
                        arefriends: true);
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('homeview', (route) => false);
                  }
                },
                child: Text(
                  'Unfriend',
                  style: TextStyle(color: Colors.purple, fontSize: 20),
                ),
              ),
            ],
          ),
        );
      }));
}

Future<void> unblockfriend(
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

Widget block_unblock(
    {required BuildContext context,
    required chatuser? user,
    required chatuser? friend,
    required friend_ortobe? friend_d}) {
  if (friend_d?.Status == 'friend') {
    return TextButton(
      onPressed: () async {
        if (await showgenericdialog(
                context: context,
                title: "Stream Security Team",
                text: "Do you really want to block ${friend?.Username}",
                truekeybutton: "Yes",
                falsekeybutton: "No") ??
            false) {
          await chatuserservice().blockfriend(
              username: user?.Username ?? '',
              friendname: friend?.Username ?? '');
          Navigator.of(context).pushNamedAndRemoveUntil(
            'homeview',
            ((route) => false),
          );
        }
      },
      child: Text(
        'Block',
        style: TextStyle(color: Colors.purple, fontSize: 20),
      ),
    );
  } else if (friend_d?.Status == 'block') {
    return TextButton(
      onPressed: () async {
        if (await showgenericdialog(
                context: context,
                title: "Stream Security Team",
                text: "Do you really want to unblock ${friend?.Username}",
                truekeybutton: "Yes",
                falsekeybutton: "No") ??
            false) {
          await unblockfriend(
              username: user?.Username ?? '',
              friendname: friend?.Username ?? '');
          Navigator.of(context).pushNamedAndRemoveUntil(
            'homeview',
            ((route) => false),
          );
        }
      },
      child: Text(
        'unBlock',
        style: TextStyle(color: Colors.red, fontSize: 20),
      ),
    );
  } else {
    return const Text(
      'Blocked',
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    );
  }
}
