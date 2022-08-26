import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Chatservice/chatuserservice.dart';

class Privacyview extends StatefulWidget {
  const Privacyview({Key? key}) : super(key: key);

  @override
  State<Privacyview> createState() => _PrivacyviewState();
}

class _PrivacyviewState extends State<Privacyview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.purple),
          backgroundColor: Colors.white,
          title: const Text(
            'Profile',
            style: const TextStyle(color: Colors.purple),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () async {
                  chatuserservice().showchangepassworddialog(context: context);
                },
                child: const Text('Change Profile photo',
                    style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ));
  }
}
