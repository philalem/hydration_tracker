import 'dart:convert';
import 'dart:math' as math;

import 'package:hydratee/glass_of_water_icons.dart';
import 'package:hydratee/initialQuestions.dart';
import 'package:hydratee/my_flutter_app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeBottleNameAndSize extends StatefulWidget {
  final String name;
  final double size;
  ChangeBottleNameAndSize({this.name, this.size})
      : assert(name != null),
        assert(size != null);

  @override
  _ChangeBottleNameAndSizeState createState() =>
      _ChangeBottleNameAndSizeState();
}

class _ChangeBottleNameAndSizeState extends State<ChangeBottleNameAndSize> {
  List<bool> bottleSizeSelected = [false, false, false, false];
  double amountSelected = 0;
  int questionViewIndex = 0;
  Widget questionView;
  TextEditingController enteredName;
  TextEditingController enteredAmount;
  FocusNode focusNode = FocusNode();
  bool enabled = false;

  @override
  void initState() {
    enteredName = TextEditingController(text: widget.name);
    enteredAmount = TextEditingController();
    updatePreSelection();
    questionView = selectBottleSize();
    super.initState();
  }

  updatePreSelection() {
    double previousSelection = widget.size;
    if (previousSelection == 8.0) {
      bottleSizeSelected[0] = true;
    } else if (previousSelection == 16.0) {
      bottleSizeSelected[1] = true;
    } else if (previousSelection == 24.0) {
      bottleSizeSelected[2] = true;
    } else if (previousSelection == 32.0) {
      bottleSizeSelected[3] = true;
    } else {
      enabled = true;
      enteredAmount = TextEditingController(text: previousSelection.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        middle: Text('Edit your bottle selection'),
        trailing: CupertinoButton(
          onPressed: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            if (amountSelected != 0 ||
                enteredName.text != null ||
                enteredName.text != '') {
              preferences.setString(
                  'bottleInfo',
                  jsonEncode({
                    'name': enteredName.text,
                    'amount': enabled
                        ? double.parse(enteredAmount.text)
                        : amountSelected,
                  }));
            }
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
          child: Text('Save'),
        ),
      ),
      child: SafeArea(
        child: selectBottleSize(),
      ),
    );
  }

  Container selectBottleSize() {
    //TODO: add the text for custom amounts
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            'Size',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          bottleSizeButtons(),
          SizedBox(
            height: 20,
          ),
          CupertinoTextField(
            focusNode: focusNode,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.blue, width: 1)),
            ),
            autofocus: false,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            minLines: 1,
            placeholderStyle: TextStyle(color: Colors.black54),
            style: TextStyle(
              color: Colors.black,
            ),
            onTap: () => _enableTextField(),
            controller: enteredAmount,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            inputFormatters: [
              DecimalTextInputFormatter(intRange: 2, decimalRange: 2)
            ],
            placeholder: 'Or enter your own',
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Nickname',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          CupertinoTextField(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.blue, width: 1)),
            ),
            autofocus: false,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            minLines: 1,
            maxLength: 30,
            placeholderStyle: TextStyle(color: Colors.black54),
            style: TextStyle(
              color: Colors.black,
            ),
            controller: enteredName,
            placeholder: 'Ex: Blue Hydroflask',
          ),
        ],
      ),
    );
  }

  Row bottleSizeButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            child: CupertinoButton(
              onPressed: () => _updateBottleSelection(0),
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    GlassOfWater.glassofwater,
                    size: 100,
                    color:
                        bottleSizeSelected[0] ? Colors.blue : Colors.grey[300],
                  ),
                  Text('8 oz'),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            child: CupertinoButton(
              onPressed: () => _updateBottleSelection(1),
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    MyFlutterApp.water_bottle,
                    size: 150,
                    color:
                        bottleSizeSelected[1] ? Colors.blue : Colors.grey[300],
                  ),
                  Text('16 oz'),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            child: CupertinoButton(
              onPressed: () => _updateBottleSelection(2),
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    MyFlutterApp.water_bottle,
                    size: 170,
                    color:
                        bottleSizeSelected[2] ? Colors.blue : Colors.grey[300],
                  ),
                  Text('24 oz'),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            child: CupertinoButton(
              onPressed: () => _updateBottleSelection(3),
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    MyFlutterApp.water_bottle,
                    size: 200,
                    color:
                        bottleSizeSelected[3] ? Colors.blue : Colors.grey[300],
                  ),
                  Text('32 oz'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _updateBottleSelection(numberSelected) {
    focusNode.unfocus();
    enteredAmount.clear();
    switch (numberSelected) {
      case 0:
        setState(() {
          bottleSizeSelected[0] = !bottleSizeSelected[0];
          bottleSizeSelected[1] = false;
          bottleSizeSelected[2] = false;
          bottleSizeSelected[3] = false;
          if (bottleSizeSelected[0]) {
            enabled = false;
            amountSelected = 8;
          } else {
            amountSelected = 0;
            enabled = true;
          }
        });
        break;
      case 1:
        setState(() {
          bottleSizeSelected[0] = false;
          bottleSizeSelected[1] = !bottleSizeSelected[1];
          bottleSizeSelected[2] = false;
          bottleSizeSelected[3] = false;
          if (bottleSizeSelected[1]) {
            enabled = false;
            amountSelected = 16;
          } else {
            amountSelected = 0;
            enabled = true;
          }
        });
        break;
      case 2:
        setState(() {
          bottleSizeSelected[0] = false;
          bottleSizeSelected[1] = false;
          bottleSizeSelected[2] = !bottleSizeSelected[2];
          bottleSizeSelected[3] = false;
          if (bottleSizeSelected[2]) {
            enabled = false;
            amountSelected = 24;
          } else {
            amountSelected = 0;
            enabled = true;
          }
        });
        break;
      case 3:
        setState(() {
          bottleSizeSelected[0] = false;
          bottleSizeSelected[1] = false;
          bottleSizeSelected[2] = false;
          bottleSizeSelected[3] = !bottleSizeSelected[3];
          if (bottleSizeSelected[3]) {
            amountSelected = 32;
            enabled = false;
          } else {
            amountSelected = 0;
            enabled = true;
          }
        });
        break;
      default:
        break;
    }
  }

  _enableTextField() {
    enabled = true;
    bottleSizeSelected = [false, false, false, false];
    focusNode.requestFocus();
    setState(() {});
  }
}
