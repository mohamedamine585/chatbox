import 'dart:io';

import 'package:chatserver/models/user.dart';

class UserScoket extends User{
  WebSocket socket;

  UserScoket({required super.id, required super.email, required super.name, required super.joinedAt,required this.socket});

}