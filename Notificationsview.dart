import 'package:flutter/material.dart';

import '../Chatservice/chatservice.dart';
import '../Chatservice/chatuser/chatuserservice.dart';
import '../Chatservice/chatuser/requestsender/receiver.dart';
import '../Imageservice/Image.dart';

class Notificationsview extends StatefulWidget {
  const Notificationsview({super.key});

  @override
  State<Notificationsview> createState() => _NotificationsviewState();
}

class _NotificationsviewState extends State<Notificationsview> {
  @override
  Widget build(BuildContext context) {
    final username = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: StreamBuilder(
            stream: chatuserservice().getrequestsenders(
              Username: username,
            ),
            builder: ((context, snapshot) {
              AsyncSnapshot<Iterable<friend_ortobe?>?>? snapshot;
              final data = snapshot?.data?.isNotEmpty;
              if (data ?? false) {
                return ListView.builder(
                    itemCount: snapshot?.data?.length,
                    itemBuilder: ((context, index) {
                      final friend = snapshot?.data?.elementAt(index);
                      return ListTile(
                        leading: Imagetakeruploader()
                            .showingimage(email: friend?.email, radius: 20),
                        title: Text('${friend?.name}'),
                        trailing: IconButton(
                            onPressed: () async {
                              await chatservice().acceptrfriendrequest(
                                  username: username,
                                  friendname: friend?.name ?? '');
                            },
                            icon: const Icon(Icons.check)),
                      );
                    }));
              }

              return const Scaffold(
                body: Text(
                  'No Notifications',
                  style: TextStyle(fontSize: 30),
                ),
              );
            })));
  }
}
