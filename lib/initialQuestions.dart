import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitialQuestions extends StatefulWidget {
  InitialQuestions();

  @override
  _InitialQuestionsState createState() => _InitialQuestionsState();
}

class _InitialQuestionsState extends State<InitialQuestions> {
  List<bool> bottleSizeSelected = [false, false, false];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: selectBottleSize(),
      ),
    );
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
            CupertinoButton(
              onPressed: () => print('water'),
              padding: EdgeInsets.all(0),
              child: Text(
                'Or use a default glass of water.',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            bottleSizeButtons(),
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
                          CupertinoIcons.add,
                          size: 150,
                          color: bottleSizeSelected[0]
                              ? Colors.blue
                              : Colors.grey[300],
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
                    onPressed: () => _updateBottleSelection(1),
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          CupertinoIcons.add,
                          size: 170,
                          color: bottleSizeSelected[1]
                              ? Colors.blue
                              : Colors.grey[300],
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
                    onPressed: () => _updateBottleSelection(2),
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          CupertinoIcons.add,
                          size: 200,
                          color: bottleSizeSelected[2]
                              ? Colors.blue
                              : Colors.grey[300],
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
        });
        break;
      case 1:
        setState(() {
          bottleSizeSelected[0] = false;
          bottleSizeSelected[1] = !bottleSizeSelected[1];
          bottleSizeSelected[2] = false;
        });
        break;
      case 2:
        setState(() {
          bottleSizeSelected[0] = false;
          bottleSizeSelected[1] = false;
          bottleSizeSelected[2] = !bottleSizeSelected[2];
        });
        break;
      default:
        break;
    }
  }
}
