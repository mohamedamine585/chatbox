import 'dart:io';

import 'package:chat/Chatservice/chatservice.dart';
import 'package:chat/Chatservice/consts.dart';
import 'package:chat/Chatservice/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Authservice.dart/Authservice.dart';
import '../Authservice.dart/chatuser.dart';
import '../Chatservice/chatuserservice.dart';
import '../Chatservice/requestsender/requestsender.dart';
import '../views/consts.dart';

class Imagetakeruploader {
  Future<File?> pickimage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      return File(image.path);
    }
  }

  Future<String?> uploadFile(File image) async {
    String downloadURL;
    final email = Authservice.firebase().getcurrentuser()?.email;
    Reference ref =
        FirebaseStorage.instance.ref().child("images").child('$email');

    await ref.putFile(image);
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<String?> uploadFileforsend(
      {required String messagedocid, required File image}) async {
    String downloadURL;

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("images")
        .child(messagedocid + Timestamp.now().toString());

    await ref.putFile(image);
    downloadURL = await ref.getDownloadURL();

    return downloadURL;
  }

  Future<void> sendimage(
      {required String messagedocid,
      required String messdocid,
      required String sendername,
      required String receivername}) async {
    final image = await pickimage();
    if (image != null) {
      print('ok');
      final url =
          await uploadFileforsend(messagedocid: messdocid, image: image);

      await chatservice().Sendmessage(
        sendername: sendername,
        receivername: receivername,
        content: url ?? '',
        messcollid: messdocid,
        isimage: true,
      );
    }
  }

  Future<void> uploadImage({required String username}) async {
    final image = await pickimage();
    if (image != null) {
      final url = await uploadFile(image);
      final user = await FirebaseFirestore.instance
          .collection('users')
          .where(chatuser_name, isEqualTo: username)
          .get()
          .then((value) => value);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.docs.first.id)
          .update({userphotourl: url});
    }
  }

  Future<String?> getuserimage({required String email}) async {
    return await FirebaseStorage.instance
        .ref()
        .child("images")
        .child('$email')
        .getDownloadURL();
  }

  Future<void> deleteuserimage({required String email}) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .where(chatuser_email, isEqualTo: email)
        .get()
        .then((value) => value);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(doc.docs.first.id)
        .update({userphotourl: null});
    await FirebaseStorage.instance
        .ref()
        .child("images")
        .child('$email')
        .delete();
  }

  Future<void> deletesentimages({required String messagedocid}) async {
    final timestamps = await FirebaseFirestore.instance
        .collection(messagedocid)
        .get()
        .then((value) =>
            value.docs.map((e) => Message.fromsnapshot(e).timestamp));
    timestamps.forEach((element) async {
      await FirebaseStorage.instance
          .ref()
          .child("images")
          .child(messagedocid + element.toString())
          .delete();
    });
  }

  Future<String?> updateimage({required String email}) async {
    final user = await chatuserservice().get_user(email: email);
    if (user != null) {
      if (user.first?.photourl != null && user.first?.photourl != '') {
        await deleteuserimage(email: email);
        await uploadImage(username: user.first?.Username ?? '');
        return getuserimage(email: email);
      }
      uploadImage(username: user.first?.Username ?? '');
      return user.first?.photourl;
    }
    uploadImage(username: user?.first?.Username ?? '');
    return user?.first?.photourl;
  }

  Widget showingimage({required String? email, required double? radius}) {
    return StreamBuilder(
      stream: chatuserservice().getuserforphoto(email: email),
      builder: ((context, snapshot) {
        final first = snapshot as AsyncSnapshot<Iterable<chatuser?>?>;
        if (first != null) {
          return CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(
                (first.data?.first?.photourl == null ||
                        first.data?.first?.photourl == '')
                    ? standardimageurl
                    : first.data?.first?.photourl ?? ''),
            radius: radius,
          );
        }
        return const Icon(Icons.person);
      }),
    );
  }
}
