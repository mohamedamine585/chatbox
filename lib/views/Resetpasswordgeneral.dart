import 'package:chat/views/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Authservice.dart/Authservice.dart';
import '../Useful-functions.dart';

class ResetpasswordGeneral extends StatefulWidget {
  const ResetpasswordGeneral({super.key});

  @override
  State<ResetpasswordGeneral> createState() => _ResetpasswordGeneralState();
}

class _ResetpasswordGeneralState extends State<ResetpasswordGeneral> {
  late final TextEditingController newpassword;
  late final TextEditingController confirmnewpassword;
  @override
  void initState() {
    newpassword = TextEditingController();
    confirmnewpassword = TextEditingController();
    super.initState();
  }

  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.purple),
        title: const Center(
            child: Text(
          'Reset password',
          style: TextStyle(color: Colors.purple),
        )),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(children: [
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(80, 8, 80, 1),
          child: TextField(
            controller: newpassword,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Your new password',
                labelStyle: TextStyle(color: Colors.purple)),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(80, 8, 80, 1),
          child: TextField(
            controller: confirmnewpassword,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Confirm your new password',
                labelStyle: TextStyle(color: Colors.purple)),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        TextButton(
            onPressed: () async {
              if (newpassword.text != confirmnewpassword.text) {
                await showerrordialog(
                    context: context,
                    title: "Error",
                    text: "Password isn't well confirmed",
                    keybutton: "Got it");
              } else {
                print(email);
                await Authservice.firebase().changepassword(
                    newpassord: newpassword.text, context: context);
                final user = await Authservice.firebase().loginwithemail(
                    email: email, password: newpassword.text, context: context);
                if (user != null) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(homeview, (route) => false);
                } else {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginswitch, (route) => false);
                }
              }
            },
            child: const Text(
              'SAVE',
              style: TextStyle(color: Colors.purple),
            ))
      ]),
    );
  }
}
