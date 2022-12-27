import 'package:chat/authservice/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Authservice.dart/Authprovider.dart';
import '../Authservice.dart/Authuser.dart';
import '../firebase_options.dart';

class Firebaseauthprovider implements Authprovider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<Authuser?> login(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<Authuser?> register(
      {required String Username,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<void> changepassword(
      {required String newpassord, required BuildContext context}) {
    // TODO: implement changepassword
    throw UnimplementedError();
  }

  @override
  Future loginwithemail(
      {required String email,
      required String password,
      required BuildContext context}) {
    // TODO: implement loginwithemail
    throw UnimplementedError();
  }

  @override
  Future loginwithusername(
      {required String Username,
      required String password,
      required BuildContext context}) {
    // TODO: implement loginwithusername
    throw UnimplementedError();
  }

  @override
  Future<void> sendemailverification(
      {required String email, required BuildContext context}) {
    // TODO: implement sendemailverification
    throw UnimplementedError();
  }

  @override
  Future<void> sendpasswordreset(
      {required String email, required BuildContext context}) {
    // TODO: implement sendpasswordreset
    throw UnimplementedError();
  }

  @override
  // TODO: implement getcurrentuser
  User? get getcurrentuser => Authservice.firebase().getcurrentuser;
}
