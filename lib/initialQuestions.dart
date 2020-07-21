import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydratee/animatedIndexedStack.dart';
import 'package:hydratee/enterBottleName.dart';
import 'package:hydratee/genderInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'glass_of_water_icons.dart';
import 'my_flutter_app_icons.dart';

class InitialQuestions extends StatefulWidget {
  InitialQuestions({this.moveAppIndexToHome});

  final Function moveAppIndexToHome;

  @override
  _InitialQuestionsState createState() => _InitialQuestionsState();
}

class _InitialQuestionsState extends State<InitialQuestions> {
  List<bool> bottleSizeSelected = [false, false, false, false];
  int questionViewIndex = 0;
  Widget questionView;
  double amountSelected = 0;
  String gender;
  TextEditingController bottleNameController = TextEditingController();
  TextEditingController enteredAmount = TextEditingController();
  bool enabled = true;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    questionView = selectBottleSize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: AnimatedIndexedStack(
                index: questionViewIndex,
                children: <Widget>[
                  selectBottleSize(),
                  Center(
                      child: EnterBottleName(
                    choice: getChoice(),
                    bottleNameController: bottleNameController,
                  )),
                  GenderInfo(
                    genderFunction: initializeGender,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              left: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  if (questionViewIndex != 0)
                    CupertinoButton(
                      onPressed: () => navigateToPreviousPage(),
                      padding: EdgeInsets.zero,
                      child: Text(
                        'Back',
                        textScaleFactor: 1.0,
                      ),
                    ),
                  CupertinoButton(
                    onPressed: () => navigateToNextPage(bottleNameController),
                    padding: EdgeInsets.zero,
                    child: Text(
                      'Next',
                      textScaleFactor: 1.0,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initializeGender(String selectedGender) {
    setState(() {
      gender = selectedGender;
    });
  }

  void navigateToPreviousPage() {
    if (questionViewIndex == 1) {
      questionViewIndex = 0;
    } else if (questionViewIndex == 2) {
      questionViewIndex = 1;
    }
    setState(() {});
  }

  void navigateToNextPage(bottleNameController) async {
    if (gender != null && questionViewIndex == 2) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(
          'bottleInfo',
          jsonEncode({
            'name': bottleNameController.text,
            'amount':
                enabled ? double.parse(enteredAmount.text) : amountSelected,
          }));
      preferences.setString('personInfo', gender);
      widget.moveAppIndexToHome();
    } else if (bottleNameController.text != null &&
        bottleNameController.text != '' &&
        questionViewIndex == 1) {
      setState(() {
        focusNode.unfocus();
        questionViewIndex = 2;
      });
    } else if (((bottleSizeSelected[0] ||
                bottleSizeSelected[1] ||
                bottleSizeSelected[2] ||
                bottleSizeSelected[3]) ||
            enteredAmount.text.isNotEmpty && enabled) &&
        questionViewIndex == 0) {
      setState(() => questionViewIndex = 1);
    }
  }

  Container selectBottleSize() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'What size water bottle do you use most?',
            textScaleFactor: 1.0,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            softWrap: true,
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
            controller: enteredAmount,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            onTap: () => _enableTextField(),
            inputFormatters: [
              DecimalTextInputFormatter(intRange: 2, decimalRange: 2)
            ],
            placeholder: 'Or enter your own',
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
                  Text(
                    '8 oz',
                    textScaleFactor: 1.0,
                  ),
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
                    size: 140,
                    color:
                        bottleSizeSelected[1] ? Colors.blue : Colors.grey[300],
                  ),
                  Text(
                    '16 oz',
                    textScaleFactor: 1.0,
                  ),
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
                  Text(
                    '24 oz',
                    textScaleFactor: 1.0,
                  ),
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
                  Text(
                    '32 oz',
                    textScaleFactor: 1.0,
                  ),
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

  getChoice() {
    if (enabled && enteredAmount.text.isNotEmpty) {
      return double.parse(enteredAmount.text);
    }
    if (bottleSizeSelected[0]) {
      return 8.0;
    }
    if (bottleSizeSelected[1]) {
      return 16.0;
    }
    if (bottleSizeSelected[2]) {
      return 24.0;
    }
    if (bottleSizeSelected[3]) {
      return 32.0;
    }
    return 8.0;
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
