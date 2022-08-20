import 'package:flutter/material.dart';

import '../Authservice.dart/Authservice.dart';
import '../Chatservice/chatuserservice.dart';
import 'consts.dart';

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
        elevation: 0,
        title: Row(
          children: const [
            SizedBox(
              width: 120,
            ),
            Text(
              'Register',
              style: TextStyle(color: Colors.purple, fontSize: 25),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          TextField(
            controller: name,
            decoration: const InputDecoration(
              hintText: ' Username...',
            ),
          ),
          TextField(
            controller: email,
            decoration: const InputDecoration(hintText: 'email...'),
          ),
          TextField(
            controller: password,
            decoration: const InputDecoration(hintText: 'password...'),
          ),
          const SizedBox(
            height: 20,
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
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.purple),
              )),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginview, (route) => false);
              },
              child: const Text(
                'I already have an account',
                style: TextStyle(color: Colors.purple),
              )),
          const SizedBox(
            height: 100,
            width: 80,
          ),
          Row(
            children: [
              const SizedBox(
                child: SizedBox(width: 300),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.info)),
            ],
          ),
        ],
      ),
    );
  }
}
