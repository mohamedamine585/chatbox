import 'dart:convert';

import 'package:chat/Authservice.dart/Authservice.dart';
import 'package:chat/Authservice.dart/chatuser.dart';
import 'package:chat/Chatservice/chatuserservice.dart';
import 'package:chat/Imageservice/Image.dart';
import 'package:chat/views/consts.dart';
import 'package:flutter/material.dart';

class Accountview extends StatefulWidget {
  const Accountview({super.key});

  @override
  State<Accountview> createState() => _AccountviewState();
}

class _AccountviewState extends State<Accountview> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: chatuserservice().getallusers(
            email: Authservice.firebase().getcurrentuser?.email ?? ''),
        builder: (context, snapshot) {
          snapshot as AsyncSnapshot<Iterable<chatuser?>?>;
          return Scaffold(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.purple),
              elevation: 0,
              title: Row(
                children: const [
                  SizedBox(
                    width: 50,
                  ),
                  Text(
                    'Your account',
                    style: TextStyle(color: Colors.purple),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
            ),
            body: Column(children: [
              const SizedBox(
                height: 20,
              ),
              Imagetakeruploader()
                  .showingimage(radius: 85, email: snapshot.data?.first?.email),
              const SizedBox(height: 27),
              Row(
                children: [
                  const Text('                   Name *  :'),
                  Text(
                    snapshot.data?.first?.Username ?? '',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const Text('                    email *  :'),
                  Text(snapshot.data?.first?.email ?? ''),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.upload),
                  onPressed: () async {
                    await Imagetakeruploader()
                        .updateimage(email: snapshot.data?.first?.email ?? '');
                  },
                  label: const Text('upload new image'),
                  style: TextButton.styleFrom(primary: Colors.purple),
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.cancel_presentation),
                onPressed: () async {
                  await Imagetakeruploader().deleteuserimage(
                      email: snapshot.data?.first?.email ?? '');
                },
                label: const Text('delete your image'),
                style: TextButton.styleFrom(primary: Colors.purple),
              ),
              TextButton.icon(
                onPressed: () {
                  chatuserservice().showchangepassworddialog(context: context);
                },
                icon: const Icon(Icons.password),
                label: const Text('Change your password'),
                style: TextButton.styleFrom(primary: Colors.purple),
              ),
              TextButton.icon(
                onPressed: () async {
                  await Authservice.firebase().logout();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginview, (route) => false);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: TextButton.styleFrom(primary: Colors.red),
              ),
            ]),
          );
        });
  }
}
