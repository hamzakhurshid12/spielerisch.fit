import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:spielerisch_fit/locale/app_localization.dart';
import 'package:spielerisch_fit/utils/ColorsHelper.dart';
import 'package:spielerisch_fit/utils/audio_data.dart';
import 'package:spielerisch_fit/utils/blink_widget.dart';

import '../../main.dart';

class AudioHomePage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  static double fromDuration;
  static double toDuration;
  static double totalDuration;

  const AudioHomePage({Key key, this.analytics, this.observer})
      : super(key: key);

  @override
  _AudioHomePageState createState() => _AudioHomePageState();
}

class _AudioHomePageState extends State<AudioHomePage> {
  bool isMachineRunning = false;
  bool isMachineDirty = false;
  var VALUES = [35, 40, 10, 45, 15, 50, 20, 55, 25, 60, 30];
  var TIMESSECONDS;
  Timer rotator;
  static var _random = new Random();

  List<Widget> values;
  List<Widget> timesseconds;
  List<Widget> excercisesRollerItems;

  List jsonKeys;

  double screenWidth;
  double screenHeight;

  int selectedDuration;
  String selectedTimesSeconds;

  String clockCaption = "";
  String clockDuration = "";

  Timer stopWatchTimer;
  Timer visionRollingTimer;
  bool isVisionRollingTimerRunning;

  GlobalKey machineKey;
  ScrollController _scrollController = new ScrollController();
  Widget infoPic;
  bool infoPicIsVisible = false;

  Widget currentVisionWidgetOnScreen = Container();
  int visionModeWidgetsRollingIndex = 0;
  List<Widget> selectedRollerWidgetList;

  double totalSelectedSeconds = AudioHomePage.fromDuration / 1000;

  List<Widget> visionModeOneColorWidgets;
  List<Widget> visionTwoColorWidgets;
  List<Widget> visionThreeColorWidgets;
  List<Widget> visionBearWidgets;

  bool isFullScreen = false;

  List<Map<String, dynamic>> selectedAudioFiles;

  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    if(!kIsWeb) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
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
                  channelDescription: channel.description,
                  icon: "ic_launcher",
                ),
              ));
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
      });
    }

    clockDuration = "00 : 00";

    //setting initial screen image for vision mode
    currentVisionWidgetOnScreen = Image.asset(
      "assets/images/slotmachine-start-overlay-single-window.png",
    );

    selectedAudioFiles = AudioData.getSelectedAudioFiles();
    toggleWidgetLists();
  }

  @override
  void dispose() {
    super.dispose();
    if (stopWatchTimer != null) {
      stopWatchTimer.cancel();
      stopWatchTimer = null;
    }
    isVisionRollingTimerRunning = false;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (kIsWeb){
      if(screenWidth>1500)
        screenWidth = screenWidth * 0.3;
      else if (screenWidth>1000)
        screenWidth = screenWidth * 0.5;
    }
    double machineWidth = screenWidth;
    double machineHeight = machineWidth * 1.06;
    toggleWidgetLists();

    return Scaffold(
      backgroundColor: ColorHelper.backgroundCyan,
      body: SafeArea(
        child: SingleChildScrollView(
            controller: _scrollController,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              AppLocalization.of(context).pushforyourluck,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _slotMachineVisionMode(
                                  machineWidth, machineHeight),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  isFullScreen
                      ? Positioned.fill(
                          top: 0.0,
                          left: 0.0,
                          child: IgnorePointer(
                            child: Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: currentVisionWidgetOnScreen,
                            ),
                          ),
                        )
                      : Container(),
                  isFullScreen
                      ? buildFullScreenClock(machineWidth, machineHeight)
                      : Container(),
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
                        if (result == "restart")
                          Navigator.of(context).pop(result);
                      },
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    child: GestureDetector(
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Color.fromRGBO(148, 189, 60, 1.0),
                        child: Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 40.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                          onTap: () {
                            toggleFullScreen();
                          },
                          child: Container(
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                            width: screenWidth * 0.35,
                            height: screenHeight * 0.045,
                            child: Center(
                                child: Text(
                              "FULLSCREEN",
                              style: TextStyle(
                                color: ColorHelper.backgroundCyan,
                              ),
                              textAlign: TextAlign.center,
                            )),
                          )),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Positioned buildFullScreenClock(double machineWidth, double machineHeight) {
    return Positioned(
      top: 0.0,
      left: 0.0,
      child: Container(
        width: screenWidth * 0.5,
        height: screenHeight * 0.15,
        color: Color.fromRGBO(0, 0, 0, 0.2),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            Text(
              clockDuration,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Open-Sans",
                  fontWeight: FontWeight.w800,
                  fontSize: 32),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                children: [
                  Material(
                    child: InkWell(
                      child: SizedBox(
                        width: machineWidth * 0.18,
                        height: machineHeight * 0.08,
                        child: Center(
                          child: Text(
                            "START",
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
                        visionModeMachineOnTap();
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
                            "STOP",
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
                        stopClock();
                      },
                    ),
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void stopClock() async {
    await stopAudioPlayer();
    if (stopWatchTimer != null) {
      stopWatchTimer.cancel();
      stopWatchTimer = null;
    }
    isVisionRollingTimerRunning = false;
    setState(() {
      this.isMachineRunning = !this.isMachineRunning;
      setClockTimerValues();
      currentVisionWidgetOnScreen = Image.asset(
        "assets/images/slotmachine-start-overlay-single-window.png",
      );
    });
  }

  void toggleWidgetLists() {
    visionModeOneColorWidgets = [
      Container(
        color: Color.fromRGBO(255, 0, 0, 1.0),
      ),
      Container(
        color: Color.fromRGBO(0, 255, 0, 1.0),
      ),
      Container(
        color: Color.fromRGBO(0, 0, 255, 1.0),
      ),
      Container(
        color: Color.fromRGBO(255, 255, 0, 1.0),
      ),
    ];

    visionBearWidgets = [
      Icon(
        Icons.music_note,
        size: 72.0,
      ),
    ];
    selectedRollerWidgetList = visionBearWidgets;
  }

  void toggleFullScreen() {
    setState(() {
      print("Full screen toggled");
      isFullScreen = !isFullScreen;
      if (isFullScreen) {
        SystemChrome.setEnabledSystemUIOverlays([]);
      } else {
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      }
    });
  }

  Future<void> getVisionRollingTimer() async {
    isVisionRollingTimerRunning = true;
    while (isVisionRollingTimerRunning) {
      if(AudioHomePage.toDuration == AudioHomePage.fromDuration){
        totalSelectedSeconds = AudioHomePage.fromDuration;
      } else {
        totalSelectedSeconds = (_random.nextInt(
            (AudioHomePage.toDuration - AudioHomePage.fromDuration).round()) +
            AudioHomePage.fromDuration);
      }
      totalSelectedSeconds = (totalSelectedSeconds - totalSelectedSeconds%100)/1000; //removing milliseconds and centiseconds
      if(stopWatchTimer==null) {
        stopWatchTimer = getStopWatchTimer();
      }
      await Future.delayed(new Duration(milliseconds: (totalSelectedSeconds * 1000).round()), () async {
        print("Another time period started!");
        int nextIndex = _random.nextInt(selectedAudioFiles.length);
        Map<String, dynamic> nextAudio = selectedAudioFiles[nextIndex];
        await stopAudioPlayer();
        audioPlayer = await audioCache.loop(nextAudio["path"]);
        print("Another time period passed!");
        setState(() {
          currentVisionWidgetOnScreen = Container();
        });
        Future.delayed(new Duration(milliseconds: 200), () {
          setState(() {
            currentVisionWidgetOnScreen = Icon(
                Icons.music_note,
                size: 72.0,
              );
          });
        });
      });
    }
  }

  Future<void> stopAudioPlayer() async {
    //audioCache.clearCache();
    await audioPlayer?.stop();
    await audioPlayer?.release();
    await audioPlayer?.dispose();
    audioCache = AudioCache();
  }

  Timer getStopWatchTimer() {
    NumberFormat formatter = new NumberFormat("00");
    if (stopWatchTimer != null) {
      stopWatchTimer.cancel();
      stopWatchTimer = null;
    }

    double currentTotalSelectedSeconds = totalSelectedSeconds;
    int milliSeconds = (totalSelectedSeconds * 1000).round();
    return Timer.periodic(new Duration(milliseconds: 100), (Timer timer) {
      milliSeconds -= 100;
      if (milliSeconds < 0 || currentTotalSelectedSeconds!= totalSelectedSeconds) {
        milliSeconds = (totalSelectedSeconds * 1000).round();
        currentTotalSelectedSeconds = totalSelectedSeconds;
      }
      int seconds = milliSeconds ~/ 1000;
      setState(() {
        clockDuration = formatter.format(seconds % 60) +
            "." +
            formatter.format((milliSeconds % 1000)/10);
      });
    });
  }

  Widget _slotMachineVisionMode(double machineWidth, double machineHeight) {
    return Stack(
      children: [
        // ----------------- Machine ----------------------------------//
        SizedBox(
          width: machineWidth,
          height: machineHeight,
          child: GestureDetector(
            child: Image.asset(isMachineRunning
                ? "assets/images/spinner-single-window-big-running.png"
                : "assets/images/spinner-single-window-big.png"),
            onTap: () {
              visionModeMachineOnTap();
            },
          ),
        ),

        // -----------------Roller----------------------------------//
        Positioned(
          top: machineHeight * 0.18,
          left: machineWidth * 0.2395,
          child: IgnorePointer(
            child: Container(
              height: machineHeight * 0.2855,
              width: machineWidth * 0.512,
              child: currentVisionWidgetOnScreen,
            ),
          ),
        ),
        // ----------------- Clock ----------------------------------//
        isMachineDirty
            ? Positioned.fill(
                // Timer
                top: machineHeight * 0.695,
                child: Text(
                  clockDuration,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Open-Sans",
                      fontWeight: FontWeight.w800,
                      fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              )
            : Container(),
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
                      "START",
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
                  visionModeMachineOnTap();
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
                      "STOP",
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
                  stopClock();
                },
              ),
              color: Colors.transparent,
            ),
          ]),
        ),
        Positioned( //Pre-loading the image asset to avoid flickering
          // upon loading of asset first-time during runtime
          top: 0.0,
          left: 0.0,
          child: Container(
              width: 0.0,
              height: 0.0,
              child: Image.asset("assets/images/spinner-big-running.png")
          ),
        ),
      ],
    );
  }

  void visionModeMachineOnTap() {
    if (!this.isMachineRunning)
      setState(() {
        this.isMachineRunning = !this.isMachineRunning;
        if (!isMachineDirty) {
          isMachineDirty = true;
        }
        infoPicIsVisible = false;
        clockDuration = "";

        currentVisionWidgetOnScreen = selectedRollerWidgetList[0];
        getVisionRollingTimer();
      });
  }

  void setClockTimerValues() {
    NumberFormat formatter = new NumberFormat("00");
    int centiSeconds = (totalSelectedSeconds * 100).round();
    final int CENTISECONDS_IN_A_SECOND = 100;
    int seconds = centiSeconds ~/ CENTISECONDS_IN_A_SECOND;
    clockDuration = formatter.format(seconds % 60) +
        "." +
        formatter.format(centiSeconds % 100);
  }

  String getRandomColorName() {
    List<String> colors = ["RED", "GREEN", "YELLOW", "BLUE"];
    int randomNum = _random.nextInt(120) % 4;
    return colors[randomNum];
  }
}
