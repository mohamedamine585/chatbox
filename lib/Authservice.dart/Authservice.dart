import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'Authprovider.dart';
import 'Authuser.dart';
import 'FirebaseAuthprovider.dart';

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
      {required String? email, required String? password}) async {
    return await provider.login(email: email ?? '', password: password ?? '');
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

  @override
  Future<void> changepassword({required String newpassord}) async {
    await provider.changepassword(newpassord: newpassord);
  }
}
