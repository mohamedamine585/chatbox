import 'dart:convert';

import 'package:chat/Authservice.dart/chatuser.dart';
import 'package:chat/Chatservice/chatuserservice.dart';
import 'package:chat/Useful-functions.dart';
import 'package:chat/views/consts.dart';
import 'package:flutter/material.dart';

import '../Authservice.dart/Authservice.dart';
import '../imageservice/image.dart';

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
            email: Authservice.firebase().getcurrentuser()?.email ?? ''),
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
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.of(context).pushNamed(profileview,
                        arguments: snapshot.data?.first);
                  },
                  label: const Text('Profile'),
                  style: TextButton.styleFrom(primary: Colors.purple),
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.security),
                onPressed: () {
                  Navigator.of(context).pushNamed(privacyview);
                },
                label: const Text('Privacy & Security'),
                style: TextButton.styleFrom(primary: Colors.purple),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(privacyview);
                },
                icon: const Icon(Icons.settings),
                label: const Text('Account Settings'),
                style: TextButton.styleFrom(primary: Colors.purple),
              ),
              TextButton.icon(
                onPressed: () async {
                  final shouldlogout = await showgenericdialog(
                      context: context,
                      title: 'Log out',
                      text: 'Do you want to log out ?',
                      truekeybutton: 'Yes',
                      falsekeybutton: 'Cancel');
                  if (shouldlogout ?? false) {
                    await Authservice.firebase().logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginswitch, (route) => false);
                  }
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
