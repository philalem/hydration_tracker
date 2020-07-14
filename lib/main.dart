import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydration_tracker/existingUserWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  scheduleNotificationsForTheWeek();
  runApp(HydrationTracker());
}

Future scheduleNotificationsForTheWeek() async {
  if (await checkIfAWeekHasPassed() == 0) {
    return;
  }
  for (int i = 0; i < 7; i++) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var scheduledNotificationDateTime = DateTime.now().add(Duration(days: i));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Hydrate',
        'Hydration App',
        'An app to help you track your water intake quickly and efficiently.');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        i,
        'Hydration reminder',
        'Remember to start your day off with some water!',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
}

Future<int> checkIfAWeekHasPassed() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String lastScheduledDate =
      preferences.getString('lastDateToScheduleNotifications');
  DateTime today = DateTime.now();
  DateTime storedDate =
      DateTime.parse(restrictFractionalSeconds(lastScheduledDate));
  if (storedDate == null) {
    return 1;
  }
  return storedDate.difference(today).inDays == 7 ? 1 : 0;
}

String restrictFractionalSeconds(String dateTime) =>
    dateTime.replaceFirstMapped(RegExp("(\\.\\d{6})\\d+"), (m) => m[1]);

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
