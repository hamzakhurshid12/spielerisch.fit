import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roller_list/roller_list.dart';
import 'package:spielerisch_fit/locale/app_localization.dart';
import 'package:spielerisch_fit/utils/ColorsHelper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:spielerisch_fit/main.dart';

//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spielerisch_fit/utils/exercises_data.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.analytics, this.observer})
      : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isMachineRunning = false;
  bool isMachineDirty = false;
  var VALUES = [35, 40, 10, 45, 15, 50, 20, 55, 25, 60, 30];
  var TIMESSECONDS;

  final leftRoller = new GlobalKey<RollerListState>();
  final middleRoller = new GlobalKey<RollerListState>();
  final rightRoller = new GlobalKey<RollerListState>();
  Timer rotator;
  Random _random = new Random();
  static const _ROTATION_DURATION = Duration(milliseconds: 5000);

  List<Widget> values;
  List<Widget> timesseconds;
  List<Widget> excercisesRollerItems;

  List jsonKeys;

  List<Exercise> chosenLanguageRecords;

  double screenWidth;
  double screenHeight;

  int selectedDuration;
  String selectedTimesSeconds;
  Exercise selectedExercise;

  String clockCaption = "";
  String clockDuration = "";

  Timer stopWatchTimer;
  String clockType = "stopwatch";

  GlobalKey machineKey;
  ScrollController _scrollController = new ScrollController();
  Widget infoPic;
  bool infoPicIsVisible = false;

  Widget currentVisionWidgetOnScreen = Container();
  int visionModeWidgetsRollingIndex = 0;

  @override
  void initState() {
    super.initState();
    /*FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: "ic_launcher",
              ),
            ));
      }
    });*/

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

    clockCaption = AppLocalization
        .of(MyApp.navKey.currentContext)
        .stopwatch;
    clockDuration = "00 : 00 : 00 : 00";

    chosenLanguageRecords = AppLocalization.chosenLanguageCode == "de_DE"
        ? ExercisesData.dataRecordsDe
        : ExercisesData.dataRecordsEn;
    excercisesRollerItems = chosenLanguageRecords
        .map((e) =>
        Padding(
          padding: EdgeInsets.all(2.0),
          child: Center(
            child: Text(
              e.shortname
                  .replaceAll("<br/>", "\n")
                  .replaceAll("</br>", "\n")
                  .replaceAll("<br>", "\n"),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorHelper.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ))
        .toList();

    excercisesRollerItems.insert(
        0,
        Padding(
          padding: EdgeInsets.all(2.0),
          child: Image.asset(
            "assets/images/slotmachine-start-overlay.png",
          ),
        ));

    values = VALUES
        .map((val) =>
        Padding(
          padding: EdgeInsets.all(2.0),
          child: Center(
            child: Text(
              val.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorHelper.red,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ))
        .toList();

    values.insert(
        0,
        Padding(
          padding: EdgeInsets.all(2.0),
          child: Image.asset(
            "assets/images/slotmachine-start-overlay.png",
          ),
        ));

    TIMESSECONDS = [
      AppLocalization
          .of(MyApp.navKey.currentContext)
          .seconds,
      AppLocalization
          .of(MyApp.navKey.currentContext)
          .times,
      AppLocalization
          .of(MyApp.navKey.currentContext)
          .seconds,
      AppLocalization
          .of(MyApp.navKey.currentContext)
          .times,
      AppLocalization
          .of(MyApp.navKey.currentContext)
          .seconds,
      AppLocalization
          .of(MyApp.navKey.currentContext)
          .times,
      AppLocalization
          .of(MyApp.navKey.currentContext)
          .seconds,
      AppLocalization
          .of(MyApp.navKey.currentContext)
          .times,
      AppLocalization
          .of(MyApp.navKey.currentContext)
          .seconds,
      AppLocalization
          .of(MyApp.navKey.currentContext)
          .times,
      AppLocalization
          .of(MyApp.navKey.currentContext)
          .seconds,
      AppLocalization
          .of(MyApp.navKey.currentContext)
          .times
    ];
    timesseconds = TIMESSECONDS
        .map<Widget>((val) =>
        Padding(
          padding: EdgeInsets.all(2.0),
          child: Center(
            child: Text(
              val,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorHelper.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ))
        .toList();
    timesseconds.insert(
        0,
        Padding(
          padding: EdgeInsets.all(2.0),
          child: Image.asset(
            "assets/images/slotmachine-start-overlay.png",
          ),
        ));

    //setting initial screen image for vision mode
    currentVisionWidgetOnScreen = Image.asset(
      "assets/images/slotmachine-start-overlay-single-window.png",
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double machineWidth = screenWidth;
    double machineHeight = machineWidth * 1.06;
    return Scaffold(
      backgroundColor: ColorHelper.backgroundCyan,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Stack(
            children: [
              Positioned(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          AppLocalization
                              .of(context)
                              .pushforyourluck,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Open-Sans",
                              fontWeight: FontWeight.w800,
                              fontSize: 16),
                          textAlign: TextAlign.center,
                        )),
                    AppLocalization.chosenLanguageCode == "de_DE"
                        ? Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: SizedBox(
                          height: 40,
                          child: Image.asset(
                              "assets/images/logo-spielerisch-fit.png")),
                    )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: _slotMachineNormalMode(
                          machineWidth, machineHeight),
                    ),
                    (selectedExercise == null || clockType == "")
                        ? Container()
                        : Padding(
                      padding: EdgeInsets.all(machineWidth * 0.04),
                      child: Text(
                        selectedDuration.toString() +
                            " " +
                            selectedTimesSeconds +
                            "\n" +
                            selectedExercise.shortname
                                .replaceAll("\n", " "),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Open-Sans",
                            fontWeight: FontWeight.w200,
                            fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    (selectedExercise == null ||
                        selectedExercise.info == "" ||
                        clockType == "")
                        ? Container()
                        : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: machineWidth * 0.04),
                      child: Text(
                        selectedExercise.info,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Open-Sans",
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    //<-------------------- ICONS ROW ----------------------------------->
                    (!isMachineDirty || clockType == "")
                        ? Container()
                        : Padding(
                      padding: EdgeInsets.all(machineWidth * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //<-------------------- Refresh Icon ----------------------------------->
                          GestureDetector(
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: Image.asset(
                                  "assets/images/reload_icon.png"),
                            ),
                            onTap: () {
                              normalModeMachineOnTap();
                            },
                          ),
                          //<-------------------- Info Pic Icon ----------------------------------->
                          infoPic == null
                              ? Container()
                              : Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: GestureDetector(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: Image.asset(
                                    "assets/images/camera_icon.png"),
                              ),
                              onTap: () {
                                setState(() {
                                  infoPicIsVisible =
                                  !infoPicIsVisible;
                                  Future.delayed(
                                      Duration(milliseconds: 100),
                                          () {
                                        _scrollController.animateTo(
                                            _scrollController.position
                                                .maxScrollExtent,
                                            duration: Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeOut);
                                      });
                                });
                              },
                            ),
                          ),
                          //<-------------------- Video Link Icon ----------------------------------->
                          selectedExercise.link == "" ||
                              selectedExercise.link == null
                              ? Container()
                              : Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: GestureDetector(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: Image.asset(
                                    "assets/images/info_icon.png"),
                              ),
                              onTap: () async {
                                if (await canLaunch(
                                    selectedExercise.link))
                                  await launch(
                                      selectedExercise.link);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    //<-------------------- Info Picture ----------------------------------->
                    (infoPic == null || !infoPicIsVisible)
                        ? Container()
                        : Padding(
                        padding: EdgeInsets.all(machineWidth * 0.04),
                        child: infoPic),
                    //<-------------------- Partner ----------------------------------->
                    (!isMachineDirty || clockType == "")
                        ? Container() : selectedExercise.partner == "" ||
                        ExercisesData.partnersMap[selectedExercise.partner] ==
                            null
                        ? Container()
                        : SizedBox(
                        width: machineWidth * 0.6,
                        child: Image.asset(
                            "assets/images/partner (" + ExercisesData
                                .partnersMap[selectedExercise.partner]
                                .toString() + ").png")
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0.0,
                right: 0.0,
                child: GestureDetector(
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Color.fromRGBO(148, 189, 60, 1.0),
                    child: Image.asset("assets/images/menu_icon.png"),
                  ),
                  onTap: () async {
                    final result =
                    await Navigator.of(context).pushNamed('/settings');
                    if (result == "restart") Navigator.of(context).pop(result);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slotMachineNormalMode(double machineWidth, double machineHeight) {
    return Stack(
      children: [
        // ----------------- Machine ----------------------------------//
        SizedBox(
          width: machineWidth,
          height: machineHeight,
          child: GestureDetector(
            child: Image.asset(isMachineRunning
                ? "assets/images/spinner-big-running.png"
                : "assets/images/spinner-big.png"),
            onTap: () {
              normalModeMachineOnTap();
            },
          ),
        ),

        // -----------------Left Roller----------------------------------//
        Positioned(
          top: machineHeight * 0.255,
          left: machineWidth * 0.23,
          child: IgnorePointer(
            child: RollerList(
              height: machineHeight * 0.14,
              width: machineWidth * 0.14,
              items: values,
              initialIndex: 1,
              dividerThickness: 0.0,
              visibilityRadius: 0.0,
              scrollType: ScrollType.bothDirections,
              key: leftRoller,
              onSelectedIndexChanged: (value) {
                _finishRotating();
              },
            ),
          ),
        ),

        // -----------------Center Roller----------------------------------//
        Positioned(
          top: machineHeight * 0.255,
          left: machineWidth * 0.43,
          child: IgnorePointer(
            child: RollerList(
              height: machineHeight * 0.14,
              width: machineWidth * 0.14,
              items: timesseconds,
              initialIndex: 1,
              dividerThickness: 0.0,
              visibilityRadius: 0.0,
              scrollType: ScrollType.bothDirections,
              key: middleRoller,
              onSelectedIndexChanged: (value) {
                _finishRotating();
              },
            ),
          ),
        ),

        // -----------------Right Roller----------------------------------//
        Positioned(
          top: machineHeight * 0.255,
          left: machineWidth * 0.62,
          child: IgnorePointer(
            child: RollerList(
              height: machineHeight * 0.14,
              width: machineWidth * 0.14,
              items: excercisesRollerItems,
              initialIndex: 1,
              dividerThickness: 0.0,
              visibilityRadius: 0.0,
              scrollType: ScrollType.bothDirections,
              key: rightRoller,
              onSelectedIndexChanged: (value) {
                _finishRotating();
              },
            ),
          ),
        ),
        // ----------------- Clock ----------------------------------//
        Positioned.fill(
          //Heading
          top: machineHeight * 0.68,
          child: Text(
            clockCaption,
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Open-Sans",
                fontWeight: FontWeight.w800,
                fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        Positioned.fill(
          // Timer
          top: machineHeight * 0.73,
          child: Text(
            clockDuration,
            style: TextStyle(
                color: Color.fromRGBO(204, 204, 204, 1.0),
                fontFamily: "Open-Sans",
                fontWeight: FontWeight.w800,
                fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        // ----------------- Buttons ----------------------------------//
        Positioned.fill(
          //Buttons
          top: machineHeight * 0.8,
          left: machineWidth * 0.3,
          child: Row(children: [
            Material(
              child: InkWell(
                child: SizedBox(
                  width: machineWidth * 0.18,
                  height: machineHeight * 0.08,
                  child: Center(
                    child: Text(
                      clockType == "" ? "" : "START",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Open-Sans",
                          fontWeight: FontWeight.w800,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  if (clockType == "stopwatch") {
                    stopWatchTimer = getStopWatch();
                  } else {
                    stopWatchTimer = getExerciseTimer();
                  }
                },
              ),
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(left: machineWidth * 0.035),
            ),
            Material(
              child: InkWell(
                child: SizedBox(
                  width: machineWidth * 0.18,
                  height: machineHeight * 0.08,
                  child: Center(
                    child: Text(
                      clockType == "stopwatch"
                          ? "STOP"
                          : (clockType == "" ? "" : "RESET"),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Open-Sans",
                          fontWeight: FontWeight.w800,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  if (stopWatchTimer != null) {
                    stopWatchTimer.cancel();
                    stopWatchTimer = null;
                  }
                  if (clockType != "stopwatch") setClockTimerValues();
                },
              ),
              color: Colors.transparent,
            ),
          ]),
        ),
      ],
    );
  }

  void _rotateRoller(final roller, int maxLimit, int rollerID) {
    int selectedIndex = _random.nextInt(maxLimit);
    final rotationTarget = selectedIndex + maxLimit * 3;
    roller.currentState?.smoothScrollToIndex(rotationTarget,
        duration: _ROTATION_DURATION, curve: Curves.elasticOut);
    switch (rollerID) {
      case 0:
        selectedDuration = VALUES[selectedIndex];
        break;
      case 1:
        selectedTimesSeconds = TIMESSECONDS[selectedIndex];
        break;
      case 2:
        selectedExercise = chosenLanguageRecords[selectedIndex];
        selectedExercise.shortname = selectedExercise.shortname
            .replaceAll("<br/>", "\n")
            .replaceAll("</br>", "\n")
            .replaceAll("<br>", "\n");
        selectedExercise.info = selectedExercise.info
            .replaceAll("<br/>", "\n")
            .replaceAll("</br>", "\n")
            .replaceAll("<br>", "\n");
        break;
    }
  }

  void _finishRotating() {
    //rotator?.cancel();
  }

  Timer getStopWatch() {
    NumberFormat formatter = new NumberFormat("00");
    if (stopWatchTimer != null) {
      stopWatchTimer.cancel();
      stopWatchTimer = null;
    }
    int centiSeconds = 0;
    return Timer.periodic(new Duration(milliseconds: 100), (Timer timer) {
      centiSeconds += 10;
      final int CENTISECONDS_IN_A_SECOND = 100;
      final int SECONDS_IN_A_MINUTE = 60;
      final int MINUTES_IN_AN_HOUR = 60;
      int seconds = centiSeconds ~/ CENTISECONDS_IN_A_SECOND;
      int minutes = seconds ~/ SECONDS_IN_A_MINUTE;
      int hours = minutes ~/ MINUTES_IN_AN_HOUR;
      setState(() {
        clockDuration = formatter.format(hours % 24) +
            " : " +
            formatter.format(minutes % 60) +
            " : " +
            formatter.format(seconds % 60) +
            " : " +
            formatter.format(centiSeconds % 100);
      });
    });
  }

  Timer getExerciseTimer() {
    if (selectedDuration == null) {
      return null;
    }
    NumberFormat formatter = new NumberFormat("00");
    if (stopWatchTimer != null) {
      stopWatchTimer.cancel();
      stopWatchTimer = null;
    }
    int remainingSeconds = selectedDuration;
    int remaningDeciSeconds = remainingSeconds * 100;
    return Timer.periodic(new Duration(milliseconds: 100), (Timer timer) {
      if (remaningDeciSeconds == 0) {
        timer.cancel();
        return;
      }
      remaningDeciSeconds -= 10;
      final int CENTISECONDS_IN_A_SECOND = 100;
      int seconds = remaningDeciSeconds ~/ CENTISECONDS_IN_A_SECOND;
      setState(() {
        clockDuration = formatter.format(seconds) +
            " : " +
            formatter.format(remaningDeciSeconds % 100);
      });
    });
  }

  void setClockTimerValues() {
    setState(() {
      if (selectedDuration == null) {
        clockDuration = "00 : 00 : 00 : 00";
        return;
      }
      NumberFormat formatter = new NumberFormat("00");
      clockDuration = clockType == "stopwatch"
          ? "00 : 00 : 00 : 00"
          : formatter.format(selectedDuration) + " : 00";
    });
  }

  void normalModeMachineOnTap() {
    if (!this.isMachineRunning)
      setState(() {
        this.isMachineRunning = !this.isMachineRunning;
        if (!isMachineDirty) {
          isMachineDirty = true;
          values.removeAt(0);
          timesseconds.removeAt(0);
          excercisesRollerItems.removeAt(0);
        }
        _scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
        infoPicIsVisible = false;
        clockCaption = "";
        clockDuration = "";
        clockType = "";
        _rotateRoller(leftRoller, VALUES.length, 0);
        _rotateRoller(middleRoller, TIMESSECONDS.length, 1);
        _rotateRoller(rightRoller, excercisesRollerItems.length, 2);
        if (stopWatchTimer != null) {
          stopWatchTimer.cancel();
          stopWatchTimer = null;
        }
        new Timer.periodic(
          //Machine running timer
          _ROTATION_DURATION,
              (Timer timer) {
            setState(() {
              this.isMachineRunning = !this.isMachineRunning;
              print(selectedDuration);
              print(selectedTimesSeconds);
              print(selectedExercise.shortname);
              print(selectedExercise.info);
              timer.cancel();
              loadInfoPic();
              clockType = selectedTimesSeconds ==
                  AppLocalization
                      .of(MyApp.navKey.currentContext)
                      .seconds
                  ? "clock"
                  : "stopwatch";
              clockCaption = clockType == "stopwatch"
                  ? AppLocalization
                  .of(MyApp.navKey.currentContext)
                  .stopwatch
                  : AppLocalization
                  .of(MyApp.navKey.currentContext)
                  .timer;
              setClockTimerValues();
            });
            Future.delayed(Duration(milliseconds: 200), () {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            });
          },
        );
      });
  }

  void loadInfoPic() {
    infoPicIsVisible = false;
    if (selectedExercise != null) {
      if (selectedExercise.info_pic != "") {
        infoPic = SizedBox(
            width: 64,
            height: 64,
            child: Image.network("https://spielerisch.fit" +
                selectedExercise.info_pic.substring(1)));
        return;
      }
    }
    infoPic = null;
  }
}