import 'package:chat_box/authservice/Authuser.dart';
import 'package:chat_box/authservice/Firebaseauthprovider.dart';
import 'package:chat_box/authservice/authprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authservice implements Authprovider {
  final Authprovider provider;

  factory Authservice.firebase() => Authservice(Firebaseauthprovider());

  Authservice(this.provider);

  @override
  Future<void> initialize() async {
    await provider.initialize();
  }

  @override
  Future<Authuser?> login(
      {required String email, required String password}) async {
    await provider.login(email: email, password: password);
    return Authuser(email);
  }

  @override
  Future<void> logout() async {
    await provider.logout();
  }

  @override
  Future<Authuser?> register(
      {required String email, required String password}) async {
    await provider.register(email: email, password: password);
    return Authuser(email);
  }

  @override
  User? getcurrentuser() {
    return FirebaseAuth.instance.currentUser;
  }
}
