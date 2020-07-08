import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydration_tracker/existingUserWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(HydrationTracker());
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
      home: Wrapper(),
    );
  }
}
