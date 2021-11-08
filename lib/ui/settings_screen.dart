import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spielerisch_fit/locale/app_localization.dart';
import 'package:spielerisch_fit/utils/ColorsHelper.dart';
import 'package:spielerisch_fit/utils/exercises_data.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _dropDownValue;

  @override
  void initState() {
    super.initState();
    if(prefs.containsKey("selectedExerciseType")){
      _dropDownValue = prefs.getString("selectedExerciseType");
    } else {
      _dropDownValue = 'All';
      prefs.setString('selectedExerciseType', 'All');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorHelper.backgroundGreen,
        body: SafeArea(
          child: Stack(children: [
            Positioned(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              top: 0.0,
              left: 0.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalization.of(context).settingsMessage,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Open-Sans",
                                fontWeight: FontWeight.w200,
                                fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(28.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Text(
                              AppLocalization.of(context).changeLanguage,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Open-Sans",
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              if(AppLocalization.chosenLanguageCode == "de_DE"){
                                AppLocalization.load(Locale("en", "US"));
                                prefs.setString("selectedLanguage", 'en_US');
                              } else {
                                AppLocalization.load(Locale("de", "DE"));
                                prefs.setString("selectedLanguage", 'de_DE');
                              }
                              prefs.commit();
                              Navigator.of(context).pop("restart");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(28.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                              "Exercises type: ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Open-Sans",
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        Expanded(
                            child: DropdownButton(
                              hint: _dropDownValue == null
                                  ? Text('Type', style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Open-Sans",
                                  fontSize: 16))
                                  : Text(
                                _dropDownValue, style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Open-Sans",
                                  fontSize: 16),
                              ),
                              dropdownColor: ColorHelper.backgroundGreen,
                              underline: SizedBox(),
                              items: ExercisesData.exerciseTypes.map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e, style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Open-Sans",
                                    fontSize: 16),
                                ),
                              )).toList(),
                              onChanged: (val){
                                setState(() {
                                  _dropDownValue = val;
                                  prefs.setString('selectedExerciseType', _dropDownValue);
                                  ExercisesData.load();
                                  Navigator.of(context).pop("restart");
                                });
                              },
                            ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(28.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await launch('https://www.spielerisch.fit/legal');
                          },
                          child: Text(
                            "Legal",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Open-Sans",
                                fontSize: 16,
                                decoration: TextDecoration.underline
                            ),
                            textAlign: TextAlign.center,
                          )
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () async {
                              await launch('https://www.spielerisch.fit/privacy');
                          },
                          child: Text(
                            "Privacy",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Open-Sans",
                                fontSize: 16,
                                decoration: TextDecoration.underline
                            ),
                            textAlign: TextAlign.center,
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child:GestureDetector(
                child: Container(
                  width: 40,
                  height: 40,
                  child: Image.asset("assets/images/close_icon.png"),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(
              bottom: 20.0,
              left: 0.0,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      child: Text(
                        "Partners",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Open-Sans",
                            fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed("/partners");
                      },
                    ),
                ],
              ),
            ),
          ]),
        ));
  }
}
