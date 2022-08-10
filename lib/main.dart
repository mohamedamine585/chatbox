import 'package:chat_box/Views/AccountVie.dart';
import 'package:chat_box/Views/LoginView.dart';
import 'package:chat_box/Views/Notificationsview.dart';
import 'package:chat_box/Views/RegisterView.dart';
import 'package:chat_box/Views/chatboxhome.dart';
import 'package:chat_box/Views/chatuserView.dart';
import 'package:chat_box/Views/serachView.dart';
import 'package:chat_box/consts.dart';
import 'package:flutter/material.dart';
import 'Views/Myapp.dart';

void main() {
  runApp(MaterialApp(home: const MyApp(), routes: {
    'Loginview': ((context) => const LoginView()),
    'Registerview': ((context) => const RegisterView()),
    'homeview': (context) => const Chatboxhome(),
    'chatuserview': ((context) => const chatuserview()),
    'accountview': (((context) => const Accountview())),
    'Notificationsview': (((context) => const Notificationsview())),
  }));
}
