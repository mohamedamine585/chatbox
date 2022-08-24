import 'package:chat/views/Chatview.dart';
import 'package:chat/views/Loginview.dart';
import 'package:chat/views/accountview.dart';
import 'package:chat/views/changenameview.dart';
import 'package:chat/views/chatboxview.dart';
import 'package:chat/views/chatuserview.dart';
import 'package:chat/views/myapp.dart';
import 'package:chat/views/notificationview.dart';
import 'package:chat/views/showimageview.dart';
import 'package:flutter/material.dart';

import 'views/Registerview.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
      routes: {
        'Loginview': ((context) => const LoginView()),
        'Registerview': ((context) => const RegisterView()),
        'homeview': (context) => const Chatboxhome(),
        'chatuserview': ((context) => const chatuserview()),
        'accountview': (((context) => const Accountview())),
        'Notificationsview': (((context) => const Notificationsview())),
        'changenameview': (((context) => const Changenameview())),
        'chatview': ((context) => const Chatmessages()),
        'showimageview': ((context) => const showimage())
      }));
}
