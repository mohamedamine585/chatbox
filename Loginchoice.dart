import 'package:chat/views/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Loginswitch extends StatefulWidget {
  const Loginswitch({Key? key}) : super(key: key);

  @override
  State<Loginswitch> createState() => _LoginswitchState();
}

class _LoginswitchState extends State<Loginswitch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            const Center(
              child: const Text(
                'Log in',
                style: TextStyle(color: Colors.purple, fontSize: 40),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.purple),
                onPressed: () {
                  Navigator.of(context).pushNamed(loginview);
                },
                child: const Text(
                  "Log in with Email",
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.purple),
                onPressed: () {
                  Navigator.of(context).pushNamed(loginviewwithname);
                },
                child: const Text(
                  'Log in with Username',
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
