import 'dart:async';
import 'dart:math';

import 'package:chat/Authservice.dart/Authservice.dart';
import 'package:chat/Streamuser/Streamuser.dart';
import 'package:chat/Useful-functions.dart';
import 'package:chat/views/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';

class ResetpasswordView extends StatefulWidget {
  const ResetpasswordView({Key? key}) : super(key: key);

  @override
  State<ResetpasswordView> createState() => _ResetpasswordViewState();
}

class _ResetpasswordViewState extends State<ResetpasswordView> {
  late final TextEditingController email;
  late final TextEditingController code;
  late final Timer timer;
  @override
  void initState() {
    email = TextEditingController();
    code = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    email.dispose();
    code.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    var verif = null;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.purple),
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            "Reset password",
            style: TextStyle(color: Colors.purple),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.purple),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          const Text(
            'In order to verify your ownership , a six-digit code will be sent to your email',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(55, 8, 55, 1),
            child: TextField(
              controller: email,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'email',
                  labelStyle: TextStyle(color: Colors.purple)),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: () async {
                if (email.text == "" || !email.text.contains("@gmail.")) {
                  await showerrordialog(
                      context: context,
                      title: "Error",
                      text: "The email must constain '@gmail.com'",
                      keybutton: "Got it");
                } else if (email.text.length < 8) {
                  await showerrordialog(
                      context: context,
                      title: "Error",
                      text: "The email is badly formatted",
                      keybutton: "Got it");
                } else {
                  verif = await Streamuser().SendemailverificationUnknown(
                      email: email.text, context: context);
                  timer = Streamuser().Timeout(context, verif);
                }
              },
              child:
                  const Text("Send", style: TextStyle(color: Colors.purple))),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(105, 8, 105, 1),
            child: TextField(
              controller: code,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Code',
                  labelStyle: TextStyle(color: Colors.purple)),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          TextButton(
              onPressed: () async {
                if (verif.toString() == code.text) {
                  timer.cancel();
                  code.text = '';
                  Authservice.firebase()
                      .sendpasswordreset(email: email.text, context: context);
                  await showerrordialog(
                      context: context,
                      title: "Info",
                      text:
                          "We've sent an email where you can set a new password",
                      keybutton: "Got it");
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginswitch, (route) => false);
                } else {
                  await showerrordialog(
                      context: context,
                      title: "Error",
                      text: "wrong code",
                      keybutton: "Got it");
                }
              },
              child: const Text("Proceed",
                  style: TextStyle(color: Colors.purple))),
        ],
      ),
    );
  }
}
