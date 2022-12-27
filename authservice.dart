import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Authservice.dart/Authprovider.dart';
import '../Authservice.dart/Authuser.dart';
import '../Authservice.dart/FirebaseAuthprovider.dart';

class Authservice implements Authprovider {
  final Authprovider provider;

  factory Authservice.firebase() => Authservice(Firebaseauthprovider());

  Authservice(this.provider);

  @override
  Future<void> initialize() async {
    await provider.initialize();
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
    await provider.register(
        email: email, password: password, Username: Username, context: context);
    return Authuser(email);
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
