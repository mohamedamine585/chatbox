import 'package:chat_box/authservice/Authuser.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class Authprovider {
  Future<Authuser?> login({required String email, required String password});
  Future<Authuser?> register({required String email, required String password});
  Future<void> initialize();
  Future<void> logout();
  User? getcurrentuser();
}
