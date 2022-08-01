import 'package:chat_box/authservice/authservice.dart';
import 'package:chat_box/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController email;
  late final TextEditingController password;
  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
        backgroundColor: Colors.tealAccent[400],
      ),
      body: Column(children: [
        TextField(
          controller: email,
          decoration: const InputDecoration(hintText: 'email...'),
        ),
        TextField(
          controller: password,
          decoration: const InputDecoration(hintText: 'password...'),
        ),
        TextButton(
            onPressed: () async {
              final user = await Authservice.firebase()
                  .login(email: email.text, password: password.text);
            },
            child: const Text('Log in')),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerview, (route) => false);
            },
            child: const Text("You haven't an account")),
      ]),
    );
  }
}
