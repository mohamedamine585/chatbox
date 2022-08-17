import 'package:chat/Authservice.dart/Authservice.dart';
import 'package:chat/Authservice.dart/chatuser.dart';
import 'package:chat/Chatservice/consts.dart';
import 'package:chat/Chatservice/requestsender/requestsender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<chatuser?> create_user(
      {required String email,
      required String name,
      required String photourl}) async {
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
    );
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
            final user = await Authservice.firebase().login(
                email: Authservice.firebase().getcurrentuser()?.email,
                password: oldpassword.text);
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
