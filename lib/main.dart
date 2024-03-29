import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:spielerisch_fit/locale/app_localization.dart';
import 'package:spielerisch_fit/ui/audio/audio_home_screen.dart';
import 'package:spielerisch_fit/ui/audio/audio_options.dart';
import 'package:spielerisch_fit/ui/audio/audio_options_level2.dart';
import 'package:spielerisch_fit/ui/home_screen.dart';
import 'package:spielerisch_fit/ui/intro_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:spielerisch_fit/ui/partners_screen.dart';
import 'package:spielerisch_fit/ui/settings_screen.dart';
import 'package:spielerisch_fit/ui/vision/intro_options.dart';
import 'package:spielerisch_fit/ui/vision/vision_home_screen.dart';
import 'package:spielerisch_fit/utils/exercises_data.dart';
import 'package:spielerisch_fit/utils/vision_data.dart';

import 'locale/AppLocalizationDelegate.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'default_channel', // id
  'Default Notifications', // title
  description: 'This channel is used for notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

AppLocalizationDelegate _localeOverrideDelegate =
    AppLocalizationDelegate(Locale('de', 'DE'));

SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  prefs = await SharedPreferences.getInstance();
  await ExercisesData.load();
  await VisionData.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  static var navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    if (prefs.containsKey("selectedLanguage")) {
      prefs.getString("selectedLanguage") == "de_DE"
          ? AppLocalization.load(Locale("de", "DE"))
          : AppLocalization.load(Locale("en", "US"));
    } else {
      AppLocalization.load(Locale("de", "DE"));
    }

    precacheImage(
      Image.asset("assets/images/spinner-single-window-big-running.png").image,
      context,
    );
    precacheImage(
      Image.asset("assets/images/spinner-single-window-big.png").image,
      context,
    );

    return MaterialApp(
      navigatorKey: navKey, // GlobalKey()
      initialRoute: '/',
      routes: {
        '/': (context) => IntroScreen(),
        '/home': (context) =>
            MyHomePage(analytics: analytics, observer: observer),
        '/settings': (context) => SettingsScreen(),
        '/partners': (context) => PartnersScreen(),
        '/vision_intro': (context) => IntroVision(),
        '/vision_home' : (context) => VisionHomePage(analytics: analytics,
            observer: observer),
        '/audio_intro' : (context) => IntroAudio(),
        '/audio_intro_level_2' : (context) => IntroAudio2(),
        '/audio_home' : (context) => AudioHomePage(analytics: analytics,
            observer: observer),
      },
      supportedLocales: [const Locale('en', 'US'), const Locale('de', 'DE')],
      localizationsDelegates: [
        _localeOverrideDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
