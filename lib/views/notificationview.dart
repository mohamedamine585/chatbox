import 'package:chat/Useful-functions.dart';
import 'package:flutter/material.dart';

import '../Chatservice/chatservice.dart';
import '../Chatservice/chatuserservice.dart';
import '../Chatservice/requestsender/requestsender.dart';
import '../imageservice/image.dart';

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
        appBar: AppBar(
          elevation: 0,
          title: Row(
            children: const [
              SizedBox(
                width: 48,
              ),
              Text(
                'Notifications',
                style: TextStyle(color: Colors.purple),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.purple),
        ),
        body: StreamBuilder(
            stream: chatuserservice().getrequestsenders(
              Username: username,
            ),
            builder: ((context, snapshot) {
              final data = snapshot as AsyncSnapshot<Iterable<friend_ortobe?>?>;

              return FutureBuilder(
                  future: chatuserservice()
                      .addbadgenot(Username: username, newbadgenot: 0),
                  builder: (context, snapshot1) {
                    if (data.data?.isNotEmpty ?? false) {
                      return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: ((context, index) {
                            final friend = snapshot.data?.elementAt(index);
                            return ListTile(
                              leading: Imagetakeruploader().showingimage(
                                  email: friend?.email, radius: 20),
                              title: Text('${friend?.name}'),
                              trailing: IconButton(
                                  onPressed: () async {
                                    final shouldaccept = await showgenericdialog(
                                        context: context,
                                        title: 'Accept invitaion',
                                        text:
                                            ' ${snapshot.data?.elementAt(index)?.name} will be able to chat with you',
                                        truekeybutton: 'Accept',
                                        falsekeybutton: 'Deny');
                                    await chatservice().acceptrfriendrequest(
                                        username: username,
                                        friendname: friend?.name ?? '');
                                  },
                                  icon: const Icon(Icons.check)),
                            );
                          }));
                    }
                    return const Scaffold(
                      body: Center(
                        child: Text(
                          'No Notifications',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    );
                  });
            })));
  }
}
