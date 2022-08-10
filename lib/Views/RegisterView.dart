import 'package:chat_box/authservice/authservice.dart';
import 'package:chat_box/chatservice/chatuser/chatuserservice.dart';
import 'package:chat_box/consts.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  late final TextEditingController email;
  late final TextEditingController password;

  late final TextEditingController name;
  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    name = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    name.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.cyan[350],
      ),
      body: Column(
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(hintText: ' Username...'),
          ),
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
                    .register(email: email.text, password: password.text);
                if (user != null) {
                  await chatuserservice().create_user(
                      email: email.text, name: name.text, photourl: '');
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(homeview, (route) => false);
                }
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginview, (route) => false);
              },
              child: const Text('I already have an account')),
        ],
      ),
    );
  }
}
