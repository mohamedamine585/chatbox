import 'package:chat/Authservice.dart/Authservice.dart';
import 'package:chat/Authservice.dart/chatuser.dart';
import 'package:chat/Chatservice/chatuser/chatuserservice.dart';
import 'package:chat/Chatservice/chatuser/requestsender/receiver.dart';
import 'package:chat/Imageservice/Image.dart';
import 'package:chat/Views/consts.dart';
import 'package:chat/views/search.dart';
import 'package:flutter/material.dart';

import 'consts.dart';

class Chatboxhome extends StatefulWidget {
  const Chatboxhome({super.key});

  @override
  State<Chatboxhome> createState() => _Chatboxhome();
}

class _Chatboxhome extends State<Chatboxhome> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: chatuserservice()
            .get_user(email: Authservice.firebase().getcurrentuser?.email),
        builder: ((context, snapshot) {
          final sd = snapshot.data as Iterable<chatuser?>?;
          final user = sd?.first;

          if (user != null) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: const Text(
                  'Chatbox',
                  style: TextStyle(color: Color.fromARGB(255, 111, 46, 131)),
                ),
                backgroundColor: Color.fromARGB(255, 252, 252, 252),
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(accountview, arguments: user);
                  },
                  icon: Imagetakeruploader()
                      .showingimage(email: user.email, radius: 20),
                ),
                actions: [
                  Center(
                      child: IconButton(
                          color: Colors.purple,
                          onPressed: () {
                            showSearch(
                                context: context, delegate: searchdelegate());
                          },
                          icon: const Icon(Icons.search))),
                  IconButton(
                      color: Colors.purple,
                      onPressed: () async {
                        Navigator.of(context).pushNamed(notificationsview,
                            arguments: user.Username);
                      },
                      icon: const Icon(Icons.notifications))
                ],
              ),
              body: StreamBuilder(
                  stream: chatuserservice()
                      .getallfriends(Username: user.Username ?? ''),
                  builder: ((context1, snapshot1) {
                    if (snapshot1.hasData) {
                      final d1 =
                          snapshot1 as AsyncSnapshot<Iterable<friend_ortobe?>?>;
                      return ListView.builder(
                          itemCount: snapshot1.data!.length,
                          itemBuilder: ((context1, index) {
                            final friend = snapshot1.data!.elementAt(index);

                            return ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed(chatview,
                                      arguments: [user, friend]);
                                },
                                title: Text(
                                  friend!.name!,
                                  maxLines: 1,
                                ),
                                leading: IconButton(
                                  onPressed: (() async {}),
                                  icon: Imagetakeruploader().showingimage(
                                      email: friend.email, radius: 20),
                                ));
                          }));
                    }
                    return const Scaffold(body: CircularProgressIndicator());
                  })),
            );
          }

          return const Scaffold(body: CircularProgressIndicator());
        }));
  }
}
