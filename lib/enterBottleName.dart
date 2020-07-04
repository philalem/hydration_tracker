import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnterBottleName extends StatefulWidget {
  EnterBottleName({this.choice});

  final String choice;
  @override
  _EnterBottleNameState createState() => _EnterBottleNameState();
}

class _EnterBottleNameState extends State<EnterBottleName> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      CupertinoIcons.add,
                      size: 100,
                      color: Colors.blue,
                    ),
                    Text('32 oz'),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoTextField(
                  placeholder: "Ex: Blue Hydroflask",
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
