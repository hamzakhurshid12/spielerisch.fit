import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spielerisch_fit/l10n/messages_all.dart';

class AppLocalization {

  static String chosenLanguageCode = "en_US";

  static Future<AppLocalization> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      chosenLanguageCode = localeName;
      return AppLocalization();
    });
  }

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  // list of locales
  String get heyWorld {
    return Intl.message(
      'Hey World',
      name: 'heyWorld',
      desc: 'Simpel word for greeting ',
    );
  }

  String get pushforyourluck {
    return Intl.message(
      "PUSH YOUR LUCK\nAND STAY\nPLAYFUL.FIT",
      name: 'pushforyourluck',
    );
  }

  String get start {
    return Intl.message(
      "START",
      name: 'start',
    );
  }
  String get stop {
    return Intl.message(
      "STOP",
      name: 'stop',
    );
  }
  String get stopwatch {
    return Intl.message(
      "STOPWATCH",
      name: 'stopwatch',
    );
  }
  String get timer {
    return Intl.message(
      "TIMER",
      name: 'timer',
    );
  }

  String get seconds {
    return Intl.message(
      "seconds",
      name: 'seconds',
    );
  }

  String get times {
    return Intl.message(
      "times",
      name: 'times',
    );
  }

  String get settingsMessage {
    return Intl.message(
      "We look forward to new partners and exercise-ideas!\n\nTo get your own spinner & ideas, more information and cooperation-requests:\nTom Holzer\ninfo@spielerisch.fit",
      name: 'settingsMessage',
    );
  }

  String get changeLanguage {
    return Intl.message(
      "Deutsch",
      name: 'changeLanguage',
    );
  }

}