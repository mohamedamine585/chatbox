import 'package:chat/Authservice.dart/chatuser.dart';
import 'package:chat/Chatservice/chatservice.dart';
import 'package:chat/Chatservice/chatuserservice.dart';
import 'package:chat/Chatservice/message.dart';
import 'package:chat/Chatservice/requestsender/requestsender.dart';
import 'package:chat/Useful-functions.dart';
import 'package:chat/imageservice/image.dart';
import 'package:chat/views/consts.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Chatservice/chatuser/consts.dart';

class Chatmessages extends StatefulWidget {
  const Chatmessages({Key? key}) : super(key: key);

  @override
  State<Chatmessages> createState() => _ChatmessagesState();
}

class _ChatmessagesState extends State<Chatmessages> {
  @override
  Widget build(BuildContext context) {
    final userandfriend =
        ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    final user = userandfriend.first as chatuser;
    final friend = userandfriend.last as friend_ortobe;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.purple),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            IconButton(
              iconSize: 30,
              onPressed: () async {
                final friendasuser =
                    await chatuserservice().get_user(email: friend.email);
                Navigator.of(context)
                    .pushNamed(Chatuserview, arguments: friendasuser?.first);
              },
              icon: Imagetakeruploader()
                  .showingimage(email: friend.email, radius: 25),
            ),
            const SizedBox(
              width: 15,
            ),
            Container(
              width: 160,
              child: Text(
                friend.name ?? '',
                softWrap: true,
                style: const TextStyle(color: Colors.purple),
              ),
            ),
            const SizedBox(
              width: 1,
            ),
            Positioned(
              child: IconButton(
                  onPressed: () async {
                    final friendasuser =
                        await chatuserservice().get_user(email: friend.email);
                    showmenu(
                        context: context,
                        user: user,
                        friend: friendasuser?.first);
                  },
                  icon: const Icon(Icons.menu)),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: chatservice()
                  .getmessages(messagesdocid: friend.messagesdocid ?? ''),
              builder: ((context, snapshot) {
                snapshot as AsyncSnapshot<Iterable<Message?>?>;
                if (snapshot.hasData) {
                  return Container(
                    height: 460 - MediaQuery.of(context).viewInsets.bottom,
                    child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        reverse: true,
                        itemBuilder: ((context, index) {
                          if (snapshot.data!.isNotEmpty) {
                            if (snapshot.data!.elementAt(index)!.content !=
                                '') {
                              if (snapshot.data?.elementAt(index)?.isimage ==
                                      false ||
                                  snapshot.data?.elementAt(index)?.isimage ==
                                      null) {
                                return ListTile(
                                  title: BubbleNormal(
                                    text: snapshot.data!
                                        .elementAt(index)!
                                        .content,
                                    color: getbubblecolor(
                                        test: snapshot.data
                                                ?.elementAt(index)
                                                ?.sendername ==
                                            user.Username),
                                    isSender: snapshot.data
                                            ?.elementAt(index)
                                            ?.sendername ==
                                        user.Username,
                                  ),
                                );
                              }
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: seekwidth(
                                            issender: snapshot.data
                                                    ?.elementAt(index)
                                                    ?.sendername ==
                                                user.Username),
                                      ),
                                      Container(
                                        child: GestureDetector(
                                          onTap: (() {
                                            Navigator.of(context).pushNamed(
                                                showimageview,
                                                arguments: snapshot.data
                                                    ?.elementAt(index)
                                                    ?.content);
                                          }),
                                          child: (Image(
                                              loadingBuilder: ((context, child,
                                                  loadingProgress) {
                                                return loadingProgress == null
                                                    ? child
                                                    : Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 35,
                                                          ),
                                                          Container(
                                                            height: 80,
                                                            width: 50,
                                                            child: const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .purple,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                              }),
                                              width: 250,
                                              height: 200,
                                              image: NetworkImage(snapshot.data
                                                      ?.elementAt(index)
                                                      ?.content ??
                                                  ''))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  )
                                ],
                              );
                            }
                          }
                          return const Center(
                            child: Text('No messages'),
                          );
                        })),
                  );
                }
                return Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text('No messages'),
                  ),
                );
              })),
          MessageBar(
            onSend: (message) async {
              final friend_d = await getfriend_byname(
                  Username: user.Username ?? '', friendname: friend.name ?? "");
              if (friend_d?.Status == 'block') {
                if ((await showgenericdialog(
                        context: context,
                        title: "Stream Security Team",
                        text: "You have blocked ${friend.name}",
                        truekeybutton: "Ok",
                        falsekeybutton: "Unblock")) ==
                    false) {
                  await unblockfriend(
                      username: user.Username ?? '',
                      friendname: friend.name ?? '');
                }
              } else if (friend_d?.Status == 'blocked') {
                await showerrordialog(
                    context: context,
                    title: "Stream Security Team",
                    text: "${friend.name} blocked you",
                    keybutton: "Got it");
              } else {
                await chatservice().Sendmessage(
                    sendername: user.Username ?? '',
                    receivername: friend.name ?? '',
                    content: message,
                    messcollid: friend.messagesdocid ?? '',
                    isimage: false);
              }
            },
            sendButtonColor: Colors.purple,
            actions: [
              InkWell(
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 24,
                ),
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.purple,
                    size: 24,
                  ),
                  onTap: () async {
                    final friend_d = await getfriend_byname(
                        Username: user.Username ?? '',
                        friendname: friend.name ?? "");
                    if (friend_d?.Status == 'block') {
                      if ((await showgenericdialog(
                              context: context,
                              title: "Stream Security Team",
                              text: "You have blocked ${friend.name}",
                              truekeybutton: "Ok",
                              falsekeybutton: "Unblock")) ==
                          false) {
                        await unblockfriend(
                            username: user.Username ?? '',
                            friendname: friend.name ?? '');
                      }
                    } else if (friend_d?.Status == 'blocked') {
                      await showerrordialog(
                          context: context,
                          title: "Stream Security Team",
                          text: "${friend.name} blocked you",
                          keybutton: "Got it");
                    } else {
                      final image = await Imagetakeruploader().pickimage();
                      if (image != null) {
                        final url = await Imagetakeruploader()
                            .uploadFileforsend(
                                messagedocid: friend.messagesdocid ?? '',
                                image: image);
                        await chatservice().Sendmessage(
                            sendername: user.Username ?? '',
                            receivername: friend.name ?? '',
                            content: url ?? '',
                            messcollid: friend.messagesdocid ?? '',
                            isimage: true);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

double seekwidth({required bool issender}) {
  if (issender) {
    return 95;
  }
  return 0;
}

Color getbubblecolor({required bool test}) {
  if (test) return Color.fromARGB(255, 179, 137, 187);
  return Color.fromARGB(255, 187, 180, 180);
}

Future<void> unblockfriend(
    {required String username, required String friendname}) async {
  try {
    final userdocument = await FirebaseFirestore.instance
        .collection(username)
        .where(tobefriendname, isEqualTo: friendname)
        .get()
        .then((value) => value);
    FirebaseFirestore.instance
        .collection(username)
        .doc(userdocument.docs.first.id)
        .update({
      status: 'friend',
    });

    final frienddocument = await FirebaseFirestore.instance
        .collection(friendname)
        .where(tobefriendname, isEqualTo: username)
        .get()
        .then((value) => value);
    FirebaseFirestore.instance
        .collection(friendname)
        .doc(frienddocument.docs.first.id)
        .update({
      status: 'friend',
    });
  } catch (e) {
    print(e);
  }
}

Future<friend_ortobe?>? getfriend_byname(
    {required String Username, required String friendname}) async {
  return (await FirebaseFirestore.instance
          .collection(Username)
          .snapshots()
          .map((event) => event.docs
              .map((e) => friend_ortobe.fromsnapshot(e))
              .where((element) =>
                  element.Status == 'friend' ||
                  element.Status == 'block' ||
                  element.Status == 'blocked'))
          .firstWhere((element) => element.first.name == friendname))
      .first;
}
