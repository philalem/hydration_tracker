import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenderInfo extends StatefulWidget {
  GenderInfo({this.gender});

  String gender;
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
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => setState(() {
                      widget.gender = 'Female';
                    }),
                    color: widget.gender == 'Female' && widget.gender != null
                        ? Colors.blue
                        : Colors.white,
                    child: Text(
                      'Female',
                      style: TextStyle(
                        fontSize: 28,
                        color:
                            widget.gender == 'Female' && widget.gender != null
                                ? Colors.white
                                : Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => setState(() {
                      widget.gender = 'Male';
                    }),
                    color: widget.gender == 'Male' && widget.gender != null
                        ? Colors.blue
                        : Colors.white,
                    child: Text(
                      'Male',
                      style: TextStyle(
                        fontSize: 28,
                        color: widget.gender == 'Male' && widget.gender != null
                            ? Colors.white
                            : Colors.blue,
                      ),
                    ),
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
