import 'package:chat/Useful-functions.dart';
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
  late final TextEditingController confirmpassword;

  late final TextEditingController name;
  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    name = TextEditingController();
    confirmpassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    confirmpassword.dispose();
    email.dispose();
    name.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: const [
            SizedBox(
              width: 110,
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
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(55, 8, 55, 1),
            child: TextField(
              controller: name,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username...',
                  labelStyle: TextStyle(color: Colors.purple)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(55, 8, 55, 1),
            child: TextField(
              controller: email,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'email...',
                  labelStyle: TextStyle(color: Colors.purple)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(55, 8, 55, 1),
            child: TextField(
              obscureText: true,
              controller: password,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'password...',
                  labelStyle: TextStyle(color: Colors.purple)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(55, 8, 55, 1),
            child: TextField(
              obscureText: true,
              controller: confirmpassword,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'confirm password...',
                  labelStyle: TextStyle(color: Colors.purple)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.purple),
              onPressed: () async {
                if (password.text == confirmpassword.text) {
                  final user = await Authservice.firebase().register(
                      Username: name.text,
                      email: email.text,
                      password: password.text,
                      context: context);
                  if (user != null) {
                    final userincloud = await chatuserservice().create_user(
                        email: email.text,
                        name: name.text,
                        photourl: '',
                        password: password.text,
                        context: context);

                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(homeview, (route) => false);
                  }
                } else {
                  await showerrordialog(
                      context: context,
                      title: 'Error',
                      text: "Password isn't confirmed",
                      keybutton: 'Ok');
                }
              },
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
              onPressed: () async {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginswitch, (route) => false);
              },
              child: const Text(
                'I already have an account',
                style: TextStyle(color: Colors.purple),
              )),
          const SizedBox(
            height: 35,
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
