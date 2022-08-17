import 'package:chat/views/Firstview.dart';
import 'package:flutter/cupertino.dart';

import '../Authservice.dart/Authservice.dart';
import 'Loginview.dart';
import 'Registerview.dart';
import 'chatboxview.dart';

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
            return const Firstview();
          }
          return const RegisterView();
        }));
  }
}
