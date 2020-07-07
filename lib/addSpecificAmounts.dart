import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydration_tracker/glass_of_water_icons.dart';
import 'package:hydration_tracker/my_flutter_app_icons.dart';

class AddSpecificAmount extends StatefulWidget {
  @override
  _AddSpecificAmountState createState() => _AddSpecificAmountState();
}

class _AddSpecificAmountState extends State<AddSpecificAmount> {
  List<bool> bottleSizeSelected = [false, false, false, false];
  int questionViewIndex = 0;
  Widget questionView;

  @override
  void initState() {
    questionView = selectBottleSize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController bottleNameController = TextEditingController();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        middle: Text('Add a specific amount of water'),
        trailing: CupertinoButton(
          onPressed: () => print('Save pressed'),
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          CupertinoTextField(
            placeholder: 'Ex: 12.5s',
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
    switch (numberSelected) {
      case 0:
        setState(() {
          bottleSizeSelected[0] = !bottleSizeSelected[0];
          bottleSizeSelected[1] = false;
          bottleSizeSelected[2] = false;
          bottleSizeSelected[3] = false;
        });
        break;
      case 1:
        setState(() {
          bottleSizeSelected[0] = false;
          bottleSizeSelected[1] = !bottleSizeSelected[1];
          bottleSizeSelected[2] = false;
          bottleSizeSelected[3] = false;
        });
        break;
      case 2:
        setState(() {
          bottleSizeSelected[0] = false;
          bottleSizeSelected[1] = false;
          bottleSizeSelected[2] = !bottleSizeSelected[2];
          bottleSizeSelected[3] = false;
        });
        break;
      case 3:
        setState(() {
          bottleSizeSelected[0] = false;
          bottleSizeSelected[1] = false;
          bottleSizeSelected[2] = false;
          bottleSizeSelected[3] = !bottleSizeSelected[3];
        });
        break;
      default:
        break;
    }
  }

  getChoice() {
    if (bottleSizeSelected[0]) {
      return '16 oz';
    }
    if (bottleSizeSelected[1]) {
      return '24 oz';
    }
    if (bottleSizeSelected[2]) {
      return '32 oz';
    }
    return 'Glass of water';
  }
}
