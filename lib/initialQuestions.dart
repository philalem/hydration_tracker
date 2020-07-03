import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitialQuestions extends StatefulWidget {
  InitialQuestions();

  @override
  _InitialQuestionsState createState() => _InitialQuestionsState();
}

class _InitialQuestionsState extends State<InitialQuestions> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'What size water bottle do you use most?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(5),
                          child: CupertinoButton(
                            padding: EdgeInsets.all(0),
                            color: Colors.grey[100],
                            child: Icon(CupertinoIcons.battery_full),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Text('16 oz')],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(5),
                          child: CupertinoButton(
                            padding: EdgeInsets.all(0),
                            color: Colors.grey[100],
                            child: Icon(CupertinoIcons.battery_full),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Text('24 oz')],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(5),
                          child: CupertinoButton(
                            padding: EdgeInsets.all(0),
                            color: Colors.grey[100],
                            child: Icon(CupertinoIcons.battery_full),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Text('32 oz')],
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
