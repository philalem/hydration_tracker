import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenderInfo extends StatefulWidget {
  GenderInfo({this.genderFunction});

  final Function genderFunction;
  @override
  _GenderInfoState createState() => _GenderInfoState();
}

class _GenderInfoState extends State<GenderInfo> {
  String selectedGender;

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
                    onPressed: () => setSelectedGender('Female'),
                    color: selectedGender == 'Female' && selectedGender != null
                        ? Colors.blue
                        : Colors.white,
                    child: Text(
                      'Female',
                      style: TextStyle(
                        fontSize: 28,
                        color:
                            selectedGender == 'Female' && selectedGender != null
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
                    onPressed: () => setSelectedGender('Male'),
                    color: selectedGender == 'Male' && selectedGender != null
                        ? Colors.blue
                        : Colors.white,
                    child: Text(
                      'Male',
                      style: TextStyle(
                        fontSize: 28,
                        color:
                            selectedGender == 'Male' && selectedGender != null
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

  void setSelectedGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
    widget.genderFunction(selectedGender);
  }
}
