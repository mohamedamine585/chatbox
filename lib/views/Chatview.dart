import 'package:chat/Authservice.dart/chatuser.dart';
import 'package:chat/Chatservice/chatservice.dart';
import 'package:chat/Chatservice/chatuserservice.dart';
import 'package:chat/Chatservice/consts.dart';
import 'package:chat/Chatservice/message.dart';
import 'package:chat/Chatservice/requestsender/requestsender.dart';
import 'package:chat/Useful-functions.dart';
import 'package:chat/imageservice/image.dart';
import 'package:chat/views/consts.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_10.dart';

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
            Text(
              friend.name ?? '',
              softWrap: true,
              style: const TextStyle(color: Colors.purple),
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
                    width: 400,
                    height: 460 - MediaQuery.of(context).viewInsets.bottom,
                    child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        reverse: true,
                        itemBuilder: ((context, index) {
                          final date = DateTime.fromMillisecondsSinceEpoch(
                              snapshot.data!.elementAt(index)!.timestamp);

                          if (snapshot.data!.isNotEmpty) {
                            if (snapshot.data!.elementAt(index)!.content !=
                                '') {
                              if (snapshot.data?.elementAt(index)?.isimage ==
                                      false ||
                                  snapshot.data?.elementAt(index)?.isimage ==
                                      null) {
                                return ListTile(
                                  onLongPress: () async {
                                    if (await showgenericdialog(
                                            context: context,
                                            title: 'Delete message',
                                            text:
                                                'Do you want to delete this message',
                                            truekeybutton: 'Yes',
                                            falsekeybutton: 'No') ??
                                        false) {
                                      await chatservice().deletemessage(
                                          Timestamp: snapshot.data
                                              ?.elementAt(index)
                                              ?.timestamp,
                                          Messagedocid: friend.messagesdocid);
                                    }
                                  },
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
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: (Image(
                                                errorBuilder: ((context, error,
                                                    stackTrace) {
                                                  return const Text(
                                                      'Can not  load image');
                                                }),
                                                loadingBuilder: ((context,
                                                    child, loadingProgress) {
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
                                                              child:
                                                                  const Center(
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
                                                image: NetworkImage(snapshot
                                                        .data
                                                        ?.elementAt(index)
                                                        ?.content ??
                                                    ''))),
                                          ),
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
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Text('No messages'),
                  ),
                );
              })),
          MessageBar(
            onSend: (message) async {
              await chatservice().Sendmessage(
                  sendername: user.Username ?? '',
                  receivername: friend.name ?? '',
                  content: message,
                  messcollid: friend.messagesdocid ?? '',
                  isimage: false);
            },
            sendButtonColor: Colors.purple,
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.purple,
                    size: 24,
                  ),
                  onTap: () async {
                    final image = await Imagetakeruploader().pickimage();
                    if (image != null) {
                      final url = await Imagetakeruploader().uploadFileforsend(
                          messagedocid: friend.messagesdocid ?? '',
                          image: image);
                      await chatservice().Sendmessage(
                          sendername: user.Username ?? '',
                          receivername: friend.name ?? '',
                          content: url ?? '',
                          messcollid: friend.messagesdocid ?? '',
                          isimage: true);
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
    return 105;
  }
  return 0;
}

Color getbubblecolor({required bool test}) {
  if (test) return Color.fromARGB(255, 179, 137, 187);
  return Color.fromARGB(255, 187, 180, 180);
}
