import 'package:chat_box/Views/LoginView.dart';
import 'package:chat_box/Views/RegisterView.dart';
import 'package:chat_box/Views/chatboxhome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../authservice/authservice.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Authservice.firebase().initialize(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final user = Authservice.firebase().getcurrentuser();

            if (user != null) return const Chatboxhome();
            return const LoginView();
          }
          return const RegisterView();
        }));
  }
}
