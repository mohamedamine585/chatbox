import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showerrordialog({
  required BuildContext context,
  required String title,
  required String text,
  required String keybutton,
}) {
  return showDialog<bool>(
    context: context,
    builder: ((context) {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 219, 210, 210),
        title: Text('$title'),
        content: Text(text),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                keybutton,
                style: const TextStyle(color: Colors.purple),
              )),
        ],
      );
    }),
  );
}

Future<bool?> showgenericdialog({
  required BuildContext context,
  required String title,
  required String text,
  required String truekeybutton,
  required String falsekeybutton,
}) {
  return showDialog<bool>(
    context: context,
    builder: ((context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 240, 233, 233),
        title: Text(
          title,
          style: TextStyle(color: Colors.purple),
        ),
        content: Text(text),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                falsekeybutton,
                style: const TextStyle(color: Colors.red),
              )),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                truekeybutton,
                style: const TextStyle(color: Colors.purple),
              ))
        ],
      );
    }),
  );
}
