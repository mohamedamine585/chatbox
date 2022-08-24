import 'package:chat/Chatservice/chatuserservice.dart';
import 'package:chat/views/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Changenameview extends StatefulWidget {
  const Changenameview({Key? key}) : super(key: key);

  @override
  State<Changenameview> createState() => _ChangenameviewState();
}

class _ChangenameviewState extends State<Changenameview> {
  late final TextEditingController newname;
  @override
  void initState() {
    newname = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    newname.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final username = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change your name',
          style: TextStyle(color: Colors.purple),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.purple),
      ),
      body: Column(children: [
        const SizedBox(
          height: 50,
        ),
        Center(
          child: TextField(
            controller: newname,
            decoration: const InputDecoration(hintText: 'Your new name ...'),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        TextButton(
            onPressed: () async {
              await chatuserservice().ChangeChatusername(
                  oldname: username ?? '', newname: newname.text);
            },
            child: const Text(
              "Validate",
              style: TextStyle(color: Colors.purple),
            ))
      ]),
    );
  }
}
