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
  Future<Authuser?> loginwithemail(
      {required String? email,
      required String? password,
      required BuildContext context}) async {
    try {
      return await provider.loginwithemail(
          email: email ?? '', password: password ?? '', context: context);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await provider.logout();
  }

  @override
  Future<Authuser?> register(
      {required String Username,
      required String email,
      required String password,
      required BuildContext context}) async {
    return await provider.register(
        Username: Username, email: email, password: password, context: context);
  }

  @override
  Future<void> changepassword(
      {required String newpassord, required BuildContext context}) async {
    await provider.changepassword(newpassord: newpassord, context: context);
  }

  @override
  Future<Authuser?> loginwithusername(
      {required String Username,
      required String password,
      required BuildContext context}) async {
    try {
      return await provider.loginwithusername(
          Username: Username, password: password, context: context);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> sendemailverification(
      {required String email, required BuildContext context}) async {
    await provider.sendemailverification(email: email, context: context);
    throw UnimplementedError();
  }

  @override
  Future<void> sendpasswordreset(
      {required String email, required BuildContext context}) async {
    await provider.sendpasswordreset(email: email, context: context);
  }

  @override
  // TODO: implement getcurrentuser
  User? get getcurrentuser => FirebaseAuth.instance.currentUser;
}
