import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydration_tracker/initialQuestions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(
        primaryColor: Colors.blue,
      ),
      home: InitialQuestions(),
    );
  }
}
