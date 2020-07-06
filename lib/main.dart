import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydration_tracker/initialQuestions.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  //var sharedPreferences = await SharedPreferences.getInstance();
  // runApp(Wrapper(
  //   sharedPreferences: sharedPreferences,
  // ));
  runApp(HydrationTracker(
      // sharedPreferences: sharedPreferences,
      ));
}

class HydrationTracker extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  HydrationTracker({Key key, this.sharedPreferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(
        primaryColor: Colors.blue,
      ),
      home: InitialQuestions(),
      // home: Wrapper(sharedPreferences: sharedPreferences,),
    );
  }
}
