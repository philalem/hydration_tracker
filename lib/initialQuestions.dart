import 'dart:convert';

import 'package:hydratee/animatedIndexedStack.dart';
import 'package:hydratee/enterBottleName.dart';
import 'package:hydratee/genderInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                    gender: gender,
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
                      child: Text('Back'),
                    ),
                  CupertinoButton(
                    onPressed: () => navigateToNextPage(bottleNameController),
                    padding: EdgeInsets.zero,
                    child: Text('Next'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
    if (gender != null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(
          'bottleInfo',
          jsonEncode({
            'name': bottleNameController.text,
            'amount': amountSelected,
          }));
      preferences.setString('personInfo', jsonEncode({'gender': gender}));
      widget.moveAppIndexToHome();
      // Navigator.of(context).push(CupertinoPageRoute(
      //   builder: (context) => Home(),
      // ));
    } else if (bottleNameController.text != null &&
        bottleNameController.text != '' &&
        questionViewIndex == 1) {
      setState(() => questionViewIndex = 2);
    } else if (bottleSizeSelected[0] ||
        bottleSizeSelected[1] ||
        bottleSizeSelected[2] ||
        bottleSizeSelected[3]) {
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
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          bottleSizeButtons(),
          SizedBox(
            height: 20,
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
                    size: 140,
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
    switch (numberSelected) {
      case 0:
        setState(() {
          bottleSizeSelected[0] = !bottleSizeSelected[0];
          bottleSizeSelected[1] = false;
          bottleSizeSelected[2] = false;
          bottleSizeSelected[3] = false;
          if (bottleSizeSelected[0]) {
            amountSelected = 8;
          } else {
            amountSelected = 0;
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
            amountSelected = 16;
          } else {
            amountSelected = 0;
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
            amountSelected = 24;
          } else {
            amountSelected = 0;
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
          } else {
            amountSelected = 0;
          }
        });
        break;
      default:
        break;
    }
  }

  getChoice() {
    if (bottleSizeSelected[0]) {
      return 'Glass of water';
    }
    if (bottleSizeSelected[1]) {
      return '16 oz';
    }
    if (bottleSizeSelected[2]) {
      return '24 oz';
    }
    if (bottleSizeSelected[3]) {
      return '32 oz';
    }
    return 'Glass of water';
  }
}
