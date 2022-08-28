import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Accountsettingsview extends StatefulWidget {
  const Accountsettingsview({Key? key}) : super(key: key);

  @override
  State<Accountsettingsview> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Accountsettingsview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.purple),
        backgroundColor: Colors.white,
        title: const Text(
          'Account settings',
          style: const TextStyle(color: Colors.purple),
        ),
      ),
    );
  }
}
