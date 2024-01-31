import 'package:chat/presentation/utils.dart';
import 'package:chat/presentation/utils/theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenWidth = MediaQuery.of(context).size.width;
    ScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black, const Color.fromARGB(255, 78, 16, 89)],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: ScreenHeight * 0.05,
              ),
              Text(
                "Chatbox",
                style: theme.textTheme.headline1,
              ),
              SizedBox(
                height: ScreenHeight * 0.15,
              ),
              Container(
                padding: EdgeInsets.only(left: ScreenWidth * 0.05),
                height: ScreenHeight * 0.35,
                child: Text(
                  "Connect to friends",
                  style: GoogleFonts.abrilFatface(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 50),
                ),
              ),
              SizedBox(
                height: ScreenHeight * 0.05,
              ),
              Container(
                width: ScreenWidth * 0.9,
                padding: EdgeInsetsDirectional.only(start: ScreenWidth * 0.15),
                child: Row(
                  children: [
                    IconButton(
                      style: ButtonStyle(),
                      onPressed: () {},
                      icon: Icon(
                        EvaIcons.google,
                      ),
                    ),
                    SizedBox(
                      width: ScreenWidth * 0.1,
                    ),
                    IconButton(onPressed: () {}, icon: Icon(EvaIcons.facebook)),
                    SizedBox(
                      width: ScreenWidth * 0.1,
                    ),
                    IconButton(onPressed: () {}, icon: Icon(EvaIcons.twitter))
                  ],
                ),
              ),
              SizedBox(
                height: ScreenHeight * 0.05,
              ),
              Row(
                children: [
                  SizedBox(
                    width: ScreenWidth * 0.15,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    width: ScreenWidth * 0.3,
                    child: Divider(
                      height: ScreenWidth * 0.1,
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                  Text(
                    "OR",
                    style: theme.textTheme.headline3,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    width: ScreenWidth * 0.3,
                    child: Divider(
                      height: ScreenWidth * 0.1,
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenHeight * 0.05,
              ),
              Container(
                width: ScreenWidth * 0.8,
                height: ScreenHeight * 0.06,
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Sign up to Chatbox",
                      style: theme.textTheme.bodyText1,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
