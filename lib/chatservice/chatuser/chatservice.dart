import 'dart:html';

import 'package:chat_box/chatservice/chatuser/chatuserservice.dart';
import 'package:chat_box/chatservice/chatuser/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class chatservice {
  Future<void> sendfriendrequest(
      {required String username, required String friendname}) async {
    try {
      await FirebaseFirestore.instance.collection(username).add({
        tobefriendname: friendname,
        status: 'request sender',
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> abortfriendrequestordeletefriend(
      {required String username, required String sendername}) async {
    try {
      final document = await FirebaseFirestore.instance
          .collection(username)
          .where(tobefriendname == sendername)
          .get()
          .then((value) => value);
      await FirebaseFirestore.instance
          .collection(username)
          .doc(document.docs.first.id)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> acceptrfriendrequest(
      {required String username, required String friendname}) async {
    try {
      final document = await FirebaseFirestore.instance
          .collection(username)
          .where(tobefriendname == friendname)
          .get()
          .then((value) => value);
      FirebaseFirestore.instance
          .collection(username)
          .doc(document.docs.first.id)
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
}
