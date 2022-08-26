import 'dart:convert';

import 'package:chat/Authservice.dart/Authservice.dart';
import 'package:chat/Authservice.dart/chatuser.dart';
import 'package:chat/Chatservice/consts.dart';
import 'package:chat/Chatservice/requestsender/requestsender.dart';
import 'package:chat/Useful-functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class chatuserservice {
  final users = FirebaseFirestore.instance.collection('users');

  Future<Iterable<chatuser?>?> get_user({required String? email}) async {
    try {
      return await users
          .where(
            chatuser_email,
            isEqualTo: email,
          )
          .get()
          .then((value) => value.docs.map((doc) => chatuser.fromsnapshot(doc)));
    } catch (e) {
      print(e);
    }
  }

  Future<Iterable<chatuser?>?> get_user_byUsername(
      {required String? Username}) async {
    try {
      if (Username != '') {
        return await users
            .where(
              chatuser_name,
              isEqualTo: Username,
            )
            .get()
            .then(
                (value) => value.docs.map((doc) => chatuser.fromsnapshot(doc)));
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> delete_account(
      {required String username, required String password}) async {
    final user = (await get_user_byUsername(Username: username))?.single;
    if (user?.hashedpassword ==
        sha1.convert(utf8.encode(password)).toString()) {
      final docinusers = (await FirebaseFirestore.instance
              .collection('users')
              .where(chatuser_name, isEqualTo: username)
              .get()
              .then((value) => value))
          .docs
          .single;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(docinusers.id)
          .delete();
      (await FirebaseFirestore.instance
              .collection(username)
              .get()
              .then((value) => value))
          .docs
          .forEach((element) async {
        final e = friend_ortobe.fromsnapshot(element);
        if (e.name != '' && e.name != null) {
          final hisdoc = await FirebaseFirestore.instance
              .collection(e.name!)
              .where(tobefriendname, isEqualTo: username)
              .get()
              .then((value) => value);
          await FirebaseFirestore.instance
              .collection(e.name ?? '')
              .doc(hisdoc.docs.single.id)
              .delete();

          await FirebaseFirestore.instance
              .collection(username)
              .doc(element.id)
              .delete();
        }
      });

      await FirebaseFirestore.instance
          .collection(username)
          .doc(docinusers.id)
          .delete();
    }
  }

  Future<chatuser?> login_user(
      {required String username,
      required String password,
      required BuildContext context}) async {
    final user = await get_user_byUsername(Username: username);
    final enteredpasswordhashed = sha1.convert(utf8.encode(password));
    if (user!.isNotEmpty) {
      if (enteredpasswordhashed.toString() == user.single?.hashedpassword) {
        return chatuser(
            Username: username,
            email: user.single?.email,
            photourl: user.single?.photourl,
            docid: user.single!.docid,
            hashedpassword: enteredpasswordhashed.toString());
      }
      await showerrordialog(
          context: context,
          title: 'Error',
          text: 'Wrong Password',
          keybutton: 'Ok');
      return null;
    }

    await showerrordialog(
        context: context,
        title: 'Error',
        text: 'User not found',
        keybutton: 'Ok');
    return null;
  }

  Future<chatuser?> create_user(
      {required String? email,
      required String name,
      required String? photourl,
      required String password,
      required BuildContext context}) async {
    if (password.isEmpty) {
      await showerrordialog(
          context: context,
          title: 'Error',
          text: 'The password is invalid',
          keybutton: 'Ok');

      return null;
    } else if (name.isEmpty) {
      await showerrordialog(
          context: context,
          title: 'Error',
          text: 'The name is invalid',
          keybutton: 'Ok');

      return null;
    } else {
      final alluserswiththatname = await get_user_byUsername(Username: name);

      if (alluserswiththatname?.isNotEmpty ?? false) {
        await showerrordialog(
            context: context,
            title: 'Error',
            text: 'This username is already in use',
            keybutton: 'Got it');
        return null;
      }
      final bytes = utf8.encode(password);
      final hashedpassword = sha1.convert(bytes);
      final document = await users.add({
        chatuser_email: email,
        chatuser_name: name,
        userphotourl: photourl,
      });
      await FirebaseFirestore.instance.collection(name).add({});
      return chatuser(
          docid: document.id,
          Username: name,
          email: email,
          photourl: userphotourl,
          hashedpassword: hashedpassword.toString());
    }
  }

  Stream<Iterable<chatuser?>?> getallusers({required String email}) {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
        (event) => event.docs
            .map((e) => chatuser.fromsnapshot(e))
            .where((element) => element.email == email));
  }

  Stream<Iterable<friend_ortobe?>?> getallfriends({required String Username}) {
    return FirebaseFirestore.instance.collection(Username).snapshots().map(
        (event) => event.docs
            .map((e) => friend_ortobe.fromsnapshot(e))
            .where((element) => element.Status == 'friend'));
  }

  Future<void> addbadgenot(
      {required String Username, required int newbadgenot}) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .where(chatuser_name, isEqualTo: Username)
        .get()
        .then((value) => value);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(doc.docs.first.id)
        .update({Onnotbadge: newbadgenot});
  }

  Stream<Iterable<friend_ortobe?>?> getrequestsenders(
      {required String Username}) {
    return FirebaseFirestore.instance.collection(Username).snapshots().map(
        (event) => event.docs
            .map((e) => friend_ortobe.fromsnapshot(e))
            .where((element) => element.Status == 'request sender'));
  }

  Stream<Iterable<chatuser?>?> getuserforphoto({required String? email}) {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
        (event) => event.docs
            .map((e) => chatuser.fromsnapshot(e))
            .where((element) => element.email == email));
  }

  Future<void> Changeusernameinusers(
      {required String oldname, required String newname}) async {
    final userdoc = await users
        .where(chatuser_name, isEqualTo: oldname)
        .get()
        .then((value) => value);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userdoc.docs.first.id)
        .update({chatuser_name: newname});
  }

  Future<void> changeusernameinfriendscollections(
      {required String oldname, required String newname}) async {
    final usercollection = FirebaseFirestore.instance.collection(oldname);

    final query = await usercollection.get();
    final userfriends = query.docs.map((e) => friend_ortobe.fromsnapshot(e));
    for (var element in userfriends) {
      if (element.name != '' && element.name != null) {
        final userfriend =
            FirebaseFirestore.instance.collection(element.name ?? '');

        final userdochere = await userfriend
            .where(tobefriendname, isEqualTo: oldname)
            .get()
            .then((value) => value);
        await FirebaseFirestore.instance
            .collection(element.name ?? '')
            .doc(userdochere.docs.first.id)
            .update({tobefriendname: newname});
      }
    }
  }

  Future<void> changeusercollectionname(
      {required String oldname, required String newname}) async {
    final oldcollection = FirebaseFirestore.instance.collection(oldname);
    final thedocs = await oldcollection.get();
    for (var element in thedocs.docs) {
      print(element);
      await FirebaseFirestore.instance.collection(newname).add(element.data());
    }
    final frienddoc = await oldcollection.get();
    for (var element in frienddoc.docs) {
      await oldcollection.doc(element.id).delete();
    }
  }

  Future<void> ChangeChatusername(
      {required String oldname, required String newname}) async {
    await changeusernameinfriendscollections(
        oldname: oldname, newname: newname);
    await changeusercollectionname(oldname: oldname, newname: newname);
    await Changeusernameinusers(oldname: oldname, newname: newname);
  }

  void showchangepassworddialog({required BuildContext context}) {
    showGeneralDialog(
        context: context,
        pageBuilder: ((context, animation, secondaryAnimation) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'Change your password',
                style: TextStyle(color: Colors.purple, fontSize: 20),
              ),
              leading: IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.purple,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
            body: changingpassword(),
          );
        }));
  }
}

class changingpassword extends StatefulWidget {
  const changingpassword({Key? key}) : super(key: key);

  @override
  State<changingpassword> createState() => _changingpasswordState();
}

class _changingpasswordState extends State<changingpassword> {
  late final TextEditingController oldpassword;
  late final TextEditingController newpassword;
  late final TextEditingController confirmnewpassword;

  _changingpasswordState();
  @override
  void initState() {
    oldpassword = TextEditingController();
    newpassword = TextEditingController();
    confirmnewpassword = TextEditingController();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 40,
      ),
      TextField(
        controller: oldpassword,
        obscureText: true,
        decoration: InputDecoration(hintText: 'Type your current password'),
      ),
      const SizedBox(
        height: 40,
      ),
      TextField(
        controller: newpassword,
        obscureText: true,
        decoration: InputDecoration(hintText: 'Type your new password'),
      ),
      const SizedBox(
        height: 40,
      ),
      TextField(
        controller: confirmnewpassword,
        obscureText: true,
        decoration: InputDecoration(hintText: 'confirm your new password'),
      ),
      const SizedBox(
        height: 40,
      ),
      TextButton(
          onPressed: () async {
            final user = await Authservice.firebase().loginwithemail(
                email: Authservice.firebase().getcurrentuser()?.email,
                password: oldpassword.text,
                context: context);
            if (user == null)
              print('no');
            else {
              if (newpassword.text == confirmnewpassword.text) {
                await Authservice.firebase()
                    .changepassword(newpassord: newpassword.text);
                Navigator.of(context).pop();
              } else {
                print('no1');
              }
            }
          },
          child: const Text(
            'SAVE ',
            style: TextStyle(color: Colors.purple),
          ))
    ]);
  }
}
