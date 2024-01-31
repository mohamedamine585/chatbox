import 'package:chat/presentation/pages/HomePage.dart';
import 'package:chat/presentation/utils/theme.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: theme,
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}
