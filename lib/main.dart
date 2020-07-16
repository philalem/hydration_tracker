import 'package:flutter/services.dart';
import 'package:hydratee/existingUserWrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  scheduleNotificationsForTheWeek();
  runApp(Hydratee());
}

Future scheduleNotificationsForTheWeek() async {
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });
  SharedPreferences preferences = await SharedPreferences.getInstance();
  DateTime today = DateTime.now();
  int differenceDays = await checkIfAWeekHasPassed(preferences, today);
  if (differenceDays < 1) {
    return;
  }
  preferences.setString(
      'lastDateToScheduleNotifications', today.toIso8601String());
  await scheduleNotificationsForNextSevenDays(today, differenceDays);
}

Future scheduleNotificationsForNextSevenDays(
    DateTime today, int differenceDays) async {
  int differencePlusOne = differenceDays + 1;
  for (int i = 1; i < differencePlusOne; i++) {
    var scheduledNotificationDateTime =
        DateTime(today.year, today.month, today.day + i, 6, 30);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Hydratee',
        'Hydratee',
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

Future<int> checkIfAWeekHasPassed(
    SharedPreferences preferences, DateTime today) async {
  String lastScheduledDate =
      preferences.getString('lastDateToScheduleNotifications');
  if (lastScheduledDate == null) {
    return 7;
  }
  DateTime storedDate =
      DateTime.parse(restrictFractionalSeconds(lastScheduledDate));
  return storedDate.difference(today).inDays;
}

String restrictFractionalSeconds(String dateTime) =>
    dateTime.replaceFirstMapped(RegExp("(\\.\\d{6})\\d+"), (m) => m[1]);

class Hydratee extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  Hydratee({Key key, this.sharedPreferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return CupertinoApp(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.blue,
          brightness: Brightness.light),
      home: Wrapper(),
    );
  }
}
