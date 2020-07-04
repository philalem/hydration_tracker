import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydration_tracker/home.dart';
import 'package:hydration_tracker/initialQuestions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  Wrapper({Key key, this.sharedPreferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sharedPreferences == null) {
      return InitialQuestions();
    }
    return Home();
  }
}
