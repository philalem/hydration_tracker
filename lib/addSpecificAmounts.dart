import 'dart:convert';
import 'dart:math' as math;

import 'package:hydratee/glass_of_water_icons.dart';
import 'package:hydratee/my_flutter_app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddSpecificAmount extends StatefulWidget {
  final Map<String, dynamic> todaysAmount;
  AddSpecificAmount({this.todaysAmount}) : assert(todaysAmount != null);

  @override
  _AddSpecificAmountState createState() => _AddSpecificAmountState();
}

class _AddSpecificAmountState extends State<AddSpecificAmount> {
  List<bool> bottleSizeSelected = [false, false, false, false];
  double amountSelected = 0.0;
  bool enabled = true;
  int questionViewIndex = 0;
  Widget questionView;
  TextEditingController enteredAmount = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    questionView = selectBottleSize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        middle: Text('Add or remove water', textScaleFactor: 1.0),
        trailing: focusNode.hasFocus
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  focusNode.unfocus();
                  setState(() {});
                },
                child: Text('Done'),
              )
            : null,
      ),
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            selectBottleSize(),
          ],
        ),
      ),
    );
  }

  Container selectBottleSize() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            'Select a common amount',
            textScaleFactor: 1.0,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          bottleSizeButtons(),
          SizedBox(
            height: 20,
          ),
          Text(
            'Or enter your own',
            textScaleFactor: 1.0,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
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
            controller: enteredAmount,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            inputFormatters: [
              DecimalTextInputFormatter(intRange: 3, decimalRange: 2)
            ],
            onTap: () => _enableTextField(),
            placeholder: 'Ex: 12.5s',
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
                    onPressed: () => _addAmount(),
                    color: Colors.blue,
                    child: Text(
                      'Add',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _removeAmount(),
                    color: Colors.red,
                    child: Text(
                      'Remove',
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
                  Text('8 oz', textScaleFactor: 1.0),
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
                  Text('16 oz', textScaleFactor: 1.0),
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
                  Text('24 oz', textScaleFactor: 1.0),
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
                  Text('32 oz', textScaleFactor: 1.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _addAmount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (amountSelected != 0.0 || enteredAmount.text.isNotEmpty) {
      if (enabled) {
        if (widget.todaysAmount['amount'] + double.parse(enteredAmount.text) >
            240.0) {
          widget.todaysAmount['amount'] = 240.0;
          showMaxAmountAlert();
        } else {
          widget.todaysAmount['amount'] =
              widget.todaysAmount['amount'] + double.parse(enteredAmount.text);
          Navigator.of(context).pop();
        }
      } else {
        if (widget.todaysAmount['amount'] + amountSelected > 240.0) {
          widget.todaysAmount['amount'] = 240.0;
          showMaxAmountAlert();
        } else {
          widget.todaysAmount['amount'] =
              widget.todaysAmount['amount'] + amountSelected;
          Navigator.of(context).pop();
        }
      }
      preferences.setString('todaysAmount', jsonEncode(widget.todaysAmount));
    }
  }

  _removeAmount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (amountSelected != 0.0 || enteredAmount.text.isNotEmpty) {
      if (enabled) {
        if (widget.todaysAmount['amount'] - double.parse(enteredAmount.text) <
            0.0) {
          widget.todaysAmount['amount'] = 0.0;
        } else {
          widget.todaysAmount['amount'] =
              widget.todaysAmount['amount'] - double.parse(enteredAmount.text);
        }
      } else {
        if (widget.todaysAmount['amount'] - amountSelected < 0.0) {
          widget.todaysAmount['amount'] = 0.0;
        } else {
          widget.todaysAmount['amount'] =
              widget.todaysAmount['amount'] - amountSelected;
        }
      }
      Navigator.of(context).pop();
      preferences.setString('todaysAmount', jsonEncode(widget.todaysAmount));
    }
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

  void showMaxAmountAlert() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Maximum Intake Reached", textScaleFactor: 1.0),
          content: Text("You have reached the maximum water intake (240 oz).",
              textScaleFactor: 1.0),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Okay", textScaleFactor: 1.0),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  _enableTextField() {
    enabled = true;
    bottleSizeSelected = [false, false, false, false];
    focusNode.requestFocus();
    setState(() {});
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange, this.intRange})
      : assert(decimalRange == null || decimalRange > 0),
        assert(intRange == null || intRange > 0);

  final int decimalRange;
  final int intRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value.contains(".") &&
              value.substring(0, value.indexOf(".")).length > intRange ||
          !value.contains(".") && value.length > intRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
