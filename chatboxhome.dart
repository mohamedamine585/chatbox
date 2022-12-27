import 'package:chat/Views/search.dart';
import 'package:flutter/material.dart';

import '../Imageservice/Image.dart';
import '../authservice/authservice.dart';
import '../chatservice/chatuser/chatuserservice.dart';
import '../consts.dart';

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
          AsyncSnapshot<Iterable<dynamic>?>? snapshot;
          final user = snapshot!.data?.first;

          if (user != null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Chatbox',
                  style: TextStyle(color: Color.fromARGB(255, 103, 169, 224)),
                ),
                backgroundColor: Colors.grey[300],
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
                          onPressed: () {
                            showSearch(
                                context: context, delegate: searchdelegate());
                          },
                          icon: const Icon(Icons.search))),
                  IconButton(
                      onPressed: () {
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
                    AsyncSnapshot<Iterable<dynamic>?>? snapshot1;
                    if (snapshot1!.hasData) {
                      print(user.Username);
                      return ListView.builder(
                          itemCount: snapshot1.data!.length,
                          itemBuilder: ((context1, index) {
                            final friend = snapshot1.data!.elementAt(index);

                            return ListTile(
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
