import 'package:chat/Chatservice/requestsender/requestsender.dart';
import 'package:chat/views/accountview.dart';
import 'package:flutter/material.dart';

import '../Authservice.dart/Authservice.dart';
import '../Authservice.dart/chatuser.dart';
import '../Chatservice/chatservice.dart';
import '../Chatservice/chatuserservice.dart';
import '../imageservice/image.dart';

class chatuserview extends StatefulWidget {
  const chatuserview({super.key});

  @override
  State<chatuserview> createState() => _chatuserviewState();
}

class _chatuserviewState extends State<chatuserview> {
  @override
  Widget build(BuildContext context) {
    final vieweduser = ModalRoute.of(context)!.settings.arguments as chatuser;

    return FutureBuilder(
        future: chatuserservice()
            .get_user(email: Authservice.firebase().getcurrentuser()?.email),
        builder: (context, snapshot) {
          final d = snapshot as AsyncSnapshot<Iterable<chatuser?>?>;

          if (d.data?.first?.email != vieweduser.email) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.purple),
                elevation: 0,
                backgroundColor: Colors.white,
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
                const SizedBox(
                  height: 25,
                ),
                Text(vieweduser.email ?? ''),
                const SizedBox(
                  height: 25,
                ),
                chatservice().checkifrequestissent(
                    username: snapshot.data?.first?.Username,
                    useremail: snapshot.data?.first?.email,
                    viewedname: vieweduser.Username,
                    viewedemail: vieweduser.email,
                    context: context),
              ]),
            );
          }
          return const Accountview();
        });
  }
}
