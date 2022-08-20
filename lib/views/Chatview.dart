import 'package:chat/Authservice.dart/chatuser.dart';
import 'package:chat/Chatservice/chatservice.dart';
import 'package:chat/Chatservice/consts.dart';
import 'package:chat/Chatservice/message.dart';
import 'package:chat/Chatservice/requestsender/requestsender.dart';
import 'package:chat/imageservice/image.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
            Imagetakeruploader().showingimage(email: friend.email, radius: 20),
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
                return Container(
                  height: 460 - MediaQuery.of(context).viewInsets.bottom,
                  child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: ((context, index) {
                        if (snapshot.data!.isNotEmpty) {
                          if (snapshot.data!.first!.content != null) {
                            return ListTile(
                              onLongPress: () {},
                              title: BubbleNormal(
                                text: snapshot.data!.elementAt(index)!.content,
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
                        }
                        return const Center(
                          child: Text('No messages'),
                        );
                      })),
                );
              })),
          MessageBar(
            onSend: (message) async {
              await chatservice().Sendmessage(
                  sendername: user.Username ?? '',
                  receivername: friend.name ?? '',
                  content: message,
                  messcollid: friend.messagesdocid ?? '');
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
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color getbubblecolor({required bool test}) {
  if (test) return Color.fromARGB(255, 179, 137, 187);
  return Color.fromARGB(255, 187, 180, 180);
}
