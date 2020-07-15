import 'package:hydratee/animatedIndexedStack.dart';
import 'package:hydratee/home.dart';
import 'package:hydratee/initialQuestions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  Wrapper();

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int appIndex = 0;

  int moveAppIndexToHome() {
    setState(() => appIndex = 1);
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SharedPreferences>(
      stream: SharedPreferences.getInstance().asStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.getString('bottleInfo') == null) {
            return Align(
              alignment: Alignment.center,
              child: AnimatedIndexedStack(
                index: appIndex,
                children: <Widget>[
                  InitialQuestions(moveAppIndexToHome: moveAppIndexToHome),
                  Home(),
                ],
              ),
            );
          }
          return Home();
        } else {
          return Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }
      },
    );
  }
}
