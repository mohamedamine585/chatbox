import 'package:chat/views/consts.dart';
import 'package:flutter/material.dart';

class Firstview extends StatefulWidget {
  const Firstview({Key? key}) : super(key: key);

  @override
  State<Firstview> createState() => _FirstviewState();
}

class _FirstviewState extends State<Firstview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          const SizedBox(
            height: 100,
          ),
          const Center(
            child: const Text('Stream',
                style: TextStyle(color: Colors.purple, fontSize: 40)),
          ),
          const SizedBox(
            height: 100,
          ),
          const Image(image: NetworkImage(chat_bubble_url)),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginswitch, (route) => false);
              },
              child:
                  const Text('Log in', style: TextStyle(color: Colors.purple))),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerview, (route) => false);
              },
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.purple),
              )),
          const SizedBox(
            height: 22,
            width: 80,
          ),
          Row(
            children: [
              const SizedBox(
                child: SizedBox(width: 300),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.info)),
            ],
          ),
        ]),
      ),
    );
  }
}
