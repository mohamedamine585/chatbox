import 'package:chat_box/Imageservice/Image.dart';
import 'package:chat_box/authservice/authservice.dart';
import 'package:chat_box/chatservice/chatuser/chatUser.dart';
import 'package:chat_box/chatservice/chatuser/chatservice.dart';
import 'package:chat_box/chatservice/chatuser/chatuserservice.dart';
import 'package:flutter/material.dart';

class chatuserview extends StatefulWidget {
  const chatuserview({super.key});

  @override
  State<chatuserview> createState() => _chatuserviewState();
}

class _chatuserviewState extends State<chatuserview> {
  @override
  Widget build(BuildContext context) {
    final vieweduser = ModalRoute.of(context)!.settings.arguments as chatUser;

    return FutureBuilder(
        future: chatuserservice()
            .get_user(email: Authservice.firebase().getcurrentuser()?.email),
        builder: (context, snapshot) {
          if (vieweduser.email != snapshot.data?.first!.email) {
            return Scaffold(
              appBar: AppBar(
                title: Text(vieweduser.Username ?? ''),
              ),
              body: Column(children: [
                Center(
                  child: SizedBox(
                    height: 250,
                    child: Imagetakeruploader()
                        .showingimage(email: vieweduser.email, radius: 85),
                  ),
                ),
                Text(
                  vieweduser.Username ?? '',
                  style: const TextStyle(fontSize: 30),
                ),
                Text(vieweduser.email ?? ''),
                chatservice().checkifrequestissent(
                    username: snapshot.data?.first?.Username ?? '',
                    useremail: snapshot.data?.first?.email,
                    viewedname: vieweduser.Username,
                    viewedemail: vieweduser.email),
              ]),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('You'),
            ),
            body: Column(children: [
              Text(vieweduser.Username ?? ''),
              Text(vieweduser.email ?? ''),
            ]),
          );
        });
  }
}
