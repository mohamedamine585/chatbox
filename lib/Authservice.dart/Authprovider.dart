import 'package:firebase_auth/firebase_auth.dart';

import 'Authuser.dart';

abstract class Authprovider {
  Future<Authuser?> login({required String email, required String password});
  Future<Authuser?> register({required String email, required String password});
  Future<void> initialize();
  Future<void> logout();
  User? getcurrentuser();
  Future<void> changepassword({required String newpassord});
}
