import 'dart:io';

import 'package:chat_box/authservice/authservice.dart';

import 'package:chat_box/chatservice/chatuser/chatuserservice.dart';
import 'package:chat_box/chatservice/chatuser/consts.dart';
import 'package:chat_box/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    return FirebaseStorage.instance
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
        final first = snapshot.data?.first;
        if (first != null) {
          return CircleAvatar(
            backgroundImage: NetworkImage(
                snapshot.data?.first?.photourl ?? standardimageurl),
            radius: radius,
          );
        }
        return const Icon(Icons.person);
      }),
    );
  }
}
