import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spielerisch_fit/locale/app_localization.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(148, 189, 60, 1.0),
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
                              AppLocalization.chosenLanguageCode == "de_DE"
                                  ? AppLocalization.load(Locale("en", "US"))
                                  : AppLocalization.load(Locale("de", "DE"));
                              Navigator.of(context).pop("restart");
                            },
                          ),
                        ),
                      ],
                    ),
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
          ]),
        ));
  }
}
