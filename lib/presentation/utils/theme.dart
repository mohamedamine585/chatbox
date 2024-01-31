import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme = ThemeData(
    backgroundColor: const Color.fromARGB(255, 65, 184, 69),
    textTheme: TextTheme(
        headline1: GoogleFonts.aDLaMDisplay(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        headline3: GoogleFonts.aDLaMDisplay(color: Colors.white, fontSize: 15),
        bodyText1: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 176, 145, 145),
            fontWeight: FontWeight.bold)),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(Color.fromARGB(255, 255, 255, 255)),
            textStyle:
                MaterialStatePropertyAll(TextStyle(color: Colors.white)))),
    buttonTheme:
        ButtonThemeData(buttonColor: Color.fromARGB(255, 54, 173, 58)));
