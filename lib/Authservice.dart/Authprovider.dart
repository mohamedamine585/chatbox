import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'Authuser.dart';

abstract class Authprovider {
  Future<dynamic> loginwithemail(
      {required String email,
      required String password,
      required BuildContext context});
  Future<dynamic> loginwithusername(
      {required String Username,
      required String password,
      required BuildContext context});
  Future<dynamic> register(
      {required String Username,
      required String email,
      required String password,
      required BuildContext context});
  Future<void> initialize();
  Future<void> logout();
  User? getcurrentuser();
  Future<void> changepassword(
      {required String newpassord, required BuildContext context});
  Future<void> sendemailverification(
      {required String email, required BuildContext context});
  Future<void> sendpasswordreset(
      {required String email, required BuildContext context});
}
