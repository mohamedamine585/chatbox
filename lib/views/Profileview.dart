import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Authservice.dart/chatuser.dart';
import '../Useful-functions.dart';
import '../imageservice/image.dart';

class Profileview extends StatefulWidget {
  const Profileview({Key? key}) : super(key: key);

  @override
  State<Profileview> createState() => _ProfileviewState();
}

class _ProfileviewState extends State<Profileview> {
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as chatuser?;
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
                  await Imagetakeruploader()
                      .updateimage(email: user?.email ?? '');
                },
                child: const Text('Change Profile photo',
                    style: TextStyle(color: Colors.black)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () async {
                  final shoulddeletephoto = await showgenericdialog(
                      context: context,
                      title: 'Security',
                      text:
                          'This will delete your current photo and assign you the standard user photo',
                      truekeybutton: 'Delete',
                      falsekeybutton: 'Cancel');
                  if (shoulddeletephoto ?? false) {
                    final shoulddeletephoto = await showgenericdialog(
                        context: context,
                        title: 'Delete user photo',
                        text: 'Do you want to delete your photo',
                        truekeybutton: 'Yes',
                        falsekeybutton: 'No');
                    if (shoulddeletephoto ?? false) {
                      await Imagetakeruploader()
                          .deleteuserimage(email: user?.email ?? '');
                    }
                  }
                },
                child: const Text(
                  'Delete Profile photo ',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ));
  }
}
