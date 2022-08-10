import 'package:chat_box/authservice/Authuser.dart';
import 'package:chat_box/authservice/authprovider.dart';
import 'package:chat_box/chatservice/chatuser/chatservice.dart';
import 'package:chat_box/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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
}
