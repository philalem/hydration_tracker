import 'package:hydratee/glass_of_water_icons.dart';
import 'package:hydratee/my_flutter_app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnterBottleName extends StatefulWidget {
  EnterBottleName({this.choice, this.bottleNameController});

  final String choice;
  final TextEditingController bottleNameController;
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
          Text(
            'Enter a nickname for your bottle.',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      widget.choice == 'Glass of water'
                          ? GlassOfWater.glassofwater
                          : MyFlutterApp.water_bottle,
                      size: 100,
                      color: Colors.blue,
                    ),
                    Text(widget.choice),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoTextField(
                  controller: widget.bottleNameController,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(color: Colors.blue, width: 1)),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.done,
                  maxLines: 1,
                  minLines: 1,
                  maxLength: 30,
                  placeholder: 'Ex: Blue Hydroflask',
                  placeholderStyle: TextStyle(color: Colors.black54),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
