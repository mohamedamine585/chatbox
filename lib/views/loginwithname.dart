import 'package:chat/views/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Authservice.dart/Authservice.dart';

class Loginwithname extends StatefulWidget {
  const Loginwithname({Key? key}) : super(key: key);

  @override
  State<Loginwithname> createState() => _LoginwithnameState();
}

class _LoginwithnameState extends State<Loginwithname> {
  @override
  late final TextEditingController username;
  late final TextEditingController password;
  @override
  void initState() {
    username = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
              controller: username,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username...',
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
                final user = await Authservice.firebase().loginwithusername(
                    Username: username.text,
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
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerview, (route) => false);
            },
            child: const Text("I haven't an account",
                style: TextStyle(color: Colors.purple))),
      ]),
    );
  }
}
