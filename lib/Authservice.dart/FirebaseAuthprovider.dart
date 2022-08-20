import 'package:chat/Authservice.dart/Authuser.dart';
import 'package:chat/firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Authprovider.dart';

class Firebaseauthprovider implements Authprovider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<Authuser?> login(
      {required String? email, required String? password}) async {
    if (email != '' && password != '') {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email ?? '', password: password ?? '');
      } on FirebaseAuthException catch (e) {
        return null;
      }
      return Authuser(email ?? '');
    }
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
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  User? getcurrentuser() {
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<void> changepassword({required String newpassord}) async {
    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(newpassord);
    } catch (e) {}
  }
}
