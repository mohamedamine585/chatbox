import 'package:chat_box/Imageservice/Image.dart';
import 'package:chat_box/authservice/authservice.dart';
import 'package:chat_box/chatservice/chatuser/chatUser.dart';
import 'package:chat_box/chatservice/chatuser/chatservice.dart';
import 'package:chat_box/chatservice/chatuser/chatuserservice.dart';
import 'package:chat_box/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Accountview extends StatefulWidget {
  const Accountview({super.key});

  @override
  State<Accountview> createState() => _AccountviewState();
}

class _AccountviewState extends State<Accountview> {
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as chatUser?;
    return Scaffold(
      appBar: AppBar(title: const Text('Your account')),
      body: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Imagetakeruploader().showingimage(radius: 85, email: user?.email),
        Center(
          child: TextButton(
              onPressed: () async {
                await Imagetakeruploader()
                    .updateimage(email: user?.email ?? '');
              },
              child: const Text('upload new image')),
        ),
        TextButton(
            onPressed: () async {
              await Imagetakeruploader()
                  .deleteuserimage(email: user?.email ?? '');
            },
            child: const Text('delete your image')),
        Text(
          user?.Username ?? '',
          style: const TextStyle(fontSize: 20),
        ),
        Text(user?.email ?? ''),
        TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.change_circle),
            label: const Text('Change your name')),
        TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.password),
            label: const Text('Change your password')),
        TextButton.icon(
            onPressed: () async {
              await Authservice.firebase().logout();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginview, (route) => false);
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout')),
      ]),
    );
  }
}
