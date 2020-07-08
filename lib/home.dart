import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydration_tracker/addSpecificAmounts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _duration = Duration(milliseconds: 400);

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isShowingMainData;
  Widget animatedChild;
  bool ableToPress = true;
  Map<String, dynamic> todaysAmount;
  double todaysDifference = 104;
  Map<String, dynamic> bottleInfo;
  SharedPreferences preferences;
  double percent = 0.0;
  double dailyAmount = 104;
  List<String> amounts;

  @override
  void initState() {
    animatedChild = Text(
      'Add',
      style: TextStyle(
        color: Colors.white,
      ),
    );
    super.initState();
  }

  Future<Map<String, dynamic>> getStoredData() async {
    preferences = await SharedPreferences.getInstance();
    DateTime date = DateTime.now();
    amounts = preferences.getStringList('amounts') ?? [];
    var todaysJsonAmount = preferences.getString('todaysAmount');
    todaysAmount = todaysJsonAmount == null
        ? {'amount': 0.0, 'date': date.toIso8601String()}
        : jsonDecode(todaysJsonAmount);
    DateTime storedDate =
        DateTime.parse(restrictFractionalSeconds(todaysAmount['date']));
    if (date.day != storedDate.day ||
        date.month != storedDate.month ||
        date.year != storedDate.year) {
      amounts.add(jsonEncode(todaysAmount));
      todaysAmount = {'amount': 0.0, 'date': date.toIso8601String()};
    }
    percent =
        todaysAmount['amount'] / 104 > 1 ? 1.0 : todaysAmount['amount'] / 104;
    var bottleJsonInfo = preferences.getString('bottleInfo');
    bottleInfo = bottleJsonInfo != null
        ? jsonDecode(preferences.getString('bottleInfo'))
        : {
            'name': 'water cup',
            'amount': 8,
          };
    todaysDifference = dailyAmount - todaysAmount['amount'];
    return todaysAmount;
  }

  String restrictFractionalSeconds(String dateTime) =>
      dateTime.replaceFirstMapped(RegExp("(\\.\\d{6})\\d+"), (m) => m[1]);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    const IconData threeDots = const IconData(0xf46a,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Dashboard'),
            backgroundColor: Colors.transparent,
            trailing: CupertinoButton(
              onPressed: () => print('pressed the dots'),
              padding: EdgeInsets.zero,
              child: Icon(
                threeDots,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                FutureBuilder(
                    future: getStoredData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Align(
                          alignment: Alignment.center,
                          child: CupertinoActivityIndicator(),
                        );
                      }
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    'Today\'s water intake',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CircularPercentIndicator(
                              radius: width - 160,
                              animation: true,
                              animationDuration: 1200,
                              animateFromLastPercent: true,
                              lineWidth: 15.0,
                              percent: percent,
                              center: Container(
                                width: width - 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "${(percent * 100).floor().toInt()}% hydrated",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26.0),
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        todaysDifference > 0
                                            ? "${((percent - 1).abs() * 100).ceil().toInt()}% to go!"
                                            : "Awesome job!",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              circularStrokeCap: CircularStrokeCap.butt,
                              backgroundColor: Colors.grey,
                              progressColor: Colors.blue,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Goal: ${dailyAmount} oz'),
                            Text('Amount today: ${todaysAmount['amount']} oz'),
                            Text(
                                'Amount remaining: ${todaysDifference > 0 ? todaysDifference.toString() : 0.toString()} oz'),
                            SizedBox(
                              height: 20,
                            ),
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'Add your ${bottleInfo['name']} to your daily intake',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CupertinoButton(
                              color: Colors.blue,
                              onPressed: () async {
                                if (ableToPress) {
                                  setState(() {
                                    todaysAmount['amount'] +=
                                        bottleInfo['amount'];
                                    percent = todaysAmount['amount'] / 104 > 1
                                        ? 1.0
                                        : todaysAmount['amount'] / 104;
                                    ableToPress = false;
                                    animatedChild = Icon(
                                      Icons.check,
                                      size: 20,
                                    );
                                  });
                                  preferences.setString(
                                      'todaysAmount', jsonEncode(todaysAmount));
                                  switchBackAfterThreeSeconds();
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  AnimatedSwitcher(
                                    child: animatedChild,
                                    duration: _duration,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => Navigator.of(context)
                                  .push(CupertinoPageRoute(
                                    builder: (context) => AddSpecificAmount(
                                      todaysAmount: todaysAmount,
                                    ),
                                  ))
                                  .then((value) => setState(() => print(
                                      'Refreshing page after pop back over.'))),
                              child: Text(
                                'Or add a another amount',
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            AspectRatio(
                              aspectRatio: 1.53,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(18)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[600],
                                      Colors.blue,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          'Water Intake Over Time',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 16.0, left: 6.0),
                                        child: LineChart(
                                          sampleData1(),
                                          swapAnimationDuration:
                                              const Duration(milliseconds: 250),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future switchBackAfterThreeSeconds() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      animatedChild = Text(
        'Add',
        style: TextStyle(
          color: Colors.white,
        ),
      );
      ableToPress = true;
    });
  }

  LineChartData sampleData1() {
    return LineChartData(
      extraLinesData: ExtraLinesData(horizontalLines: [
        HorizontalLine(
          dashArray: [5],
          label: HorizontalLineLabel(
            style: TextStyle(
              color: Colors.amber,
              fontSize: 18,
            ),
            labelResolver: (_) => "Goal",
            alignment: Alignment.topLeft,
            show: true,
          ),
          color: Colors.amber,
          y: 104,
        )
      ]),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              DateTime date =
                  DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
              String month = DateFormat.MMMM().format(date);
              String day = DateFormat.d().format(date);
              String year = DateFormat.y().format(date);
              return LineTooltipItem(
                  '${spot.y} oz\n$month ${day}, $year', TextStyle());
            }).toList();
          },
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: false,
          reservedSize: 22,
          textStyle: TextStyle(
            color: Colors.grey[200],
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Colors.grey[200],
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          interval: 40,
          margin: 10,
          reservedSize: 40,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[400],
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      maxY: 200,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<FlSpot> getHydrationData() {
    List<FlSpot> allAmounts = amounts.map((pastAmount) {
      var decodedAmount = jsonDecode(pastAmount);
      return FlSpot(
          DateTime.parse(restrictFractionalSeconds(decodedAmount['date']))
              .millisecondsSinceEpoch
              .toDouble(),
          todaysAmount['amount']);
    }).toList();

    allAmounts.add(FlSpot(
        DateTime.parse(restrictFractionalSeconds(todaysAmount['date']))
            .millisecondsSinceEpoch
            .toDouble(),
        todaysAmount['amount']));
    return allAmounts;
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: getHydrationData(),
      isCurved: true,
      colors: [
        Colors.grey[200],
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
    ];
  }
}
