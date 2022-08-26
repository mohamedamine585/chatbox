import 'package:flutter/material.dart';

import '../Authservice.dart/Authservice.dart';
import 'consts.dart';

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.purple),
        elevation: 0,
        title: Row(
          children: const [
            SizedBox(
              width: 70,
            ),
            Text(
              'Log in',
              style: TextStyle(color: Colors.purple, fontSize: 25),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(children: [
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(55, 8, 55, 1),
          child: TextField(
              controller: email,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'email...',
                  labelStyle: TextStyle(color: Colors.purple))),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(55, 8, 55, 1),
          child: TextField(
            controller: password,
            decoration: const InputDecoration(
              hintText: 'Password ...',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.purple),
            onPressed: () async {
              try {
                final user = await Authservice.firebase().loginwithemail(
                    email: email.text,
                    password: password.text,
                    context: context);

                if (user != null) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(homeview, (route) => false);
                }
              } catch (e) {}
            },
            child: const Text(
              'Log in',
              style: TextStyle(color: Colors.white),
            )),
        TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.purple),
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerview, (route) => false);
            },
            child: const Text("I haven't an account",
                style: TextStyle(color: Colors.white))),
      ]),
    );
  }
}
