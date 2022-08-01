import 'package:chat_box/authservice/Authuser.dart';

abstract class Authprovider {
  Future<Authuser?> login({required String email, required String password});
  Future<Authuser?> register({required String email, required String password});
  Future<void> initialize();
  Future<void> logout();
}
