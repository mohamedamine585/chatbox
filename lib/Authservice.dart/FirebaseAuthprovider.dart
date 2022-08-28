import 'package:chat/Authservice.dart/Authservice.dart';
import 'package:chat/Authservice.dart/Authuser.dart';
import 'package:chat/Chatservice/chatservice.dart';
import 'package:chat/Chatservice/chatuserservice.dart';
import 'package:chat/Chatservice/consts.dart';
import 'package:chat/Useful-functions.dart';
import 'package:chat/firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'Authprovider.dart';

class Firebaseauthprovider implements Authprovider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<Authuser?> loginwithemail(
      {required String? email,
      required String? password,
      required BuildContext context}) async {
    if (email != '' && password != '') {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email ?? '', password: password ?? '');
      } on FirebaseAuthException catch (e) {
        await showerrordialog(
            context: context,
            title: 'Error',
            text: e.message ?? '',
            keybutton: 'Ok');
        return null;
      }
      return Authuser(email ?? '');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {}
  }

  @override
  Future<Authuser?> register(
      {required String Username,
      required String email,
      required String password,
      required BuildContext context}) async {
    final all_users_with_that_name =
        (await chatuserservice().get_user_byUsername(Username: Username))
            ?.toList();

    if (all_users_with_that_name?.isEmpty ?? false) {
      if (Username == '') {
        await showerrordialog(
            context: context,
            title: 'Error',
            text: 'Invalid username',
            keybutton: 'Ok');
        return null;
      }

      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        await showerrordialog(
            context: context,
            title: 'Error',
            text: e.message ?? e.toString(),
            keybutton: "Ok");
        return null;
      }
      return Authuser(email);
    } else {
      await showerrordialog(
          context: context,
          title: 'Error',
          text: 'This username is already used',
          keybutton: 'Ok');
    }
    return null;
  }

  @override
  User? getcurrentuser() {
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (e) {}
    return null;
  }

  @override
  Future<void> changepassword({required String newpassord}) async {
    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(newpassord);
    } catch (e) {}
  }

  @override
  Future<Authuser?> loginwithusername(
      {required String Username,
      required String password,
      required BuildContext context}) async {
    final userincloud =
        await chatuserservice().get_user_byUsername(Username: Username);
    try {
      if (userincloud!.isNotEmpty) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: userincloud.first?.email ?? '', password: password);
      }
    } catch (e) {
      await showerrordialog(
          context: context,
          title: 'Error',
          text: e.toString(),
          keybutton: 'Ok');
      return null;
    }
    return Authuser(userincloud.first?.email ?? '');
  }
}
