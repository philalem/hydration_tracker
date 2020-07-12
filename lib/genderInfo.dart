import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenderInfo extends StatefulWidget {
  GenderInfo({this.gender});

  final String gender;
  @override
  _GenderInfoState createState() => _GenderInfoState();
}

class _GenderInfoState extends State<GenderInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Please select your gender.',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: CupertinoButton(
                    onPressed: () => print('Woman'),
                    child: Text('Woman'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: CupertinoButton(
                    onPressed: () => print('Woman'),
                    child: Text('Woman'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
