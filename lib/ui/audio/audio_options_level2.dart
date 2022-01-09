import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spielerisch_fit/ui/vision/vision_home_screen.dart';
import 'package:spielerisch_fit/utils/ColorsHelper.dart';
import 'package:spielerisch_fit/utils/audio_data.dart';
import 'package:spielerisch_fit/utils/settings_corner_button.dart';

import 'audio_home_screen.dart';

class IntroAudio2 extends StatefulWidget {
  @override
  _IntroAudio2State createState() => _IntroAudio2State();
}

class _IntroAudio2State extends State<IntroAudio2> {
  String _modeDropDownValue = "Stroop";
  List _visionModes = ["Stroop", "Bear"];

  var _modesListMap = {
    "Stroop": VisionModeType.stroop,
    "Bear": VisionModeType.bear,
  };

  String _colorsDropDownValue = "1";
  List _colorsList = ["1", "2", "3"];

  var _colorsListMap = {
    "1": VisionColors.oneColor,
    "2": VisionColors.twoColors,
    "3": VisionColors.threeColors
  };

  String _durationFromDropDownValue = "1000";
  String _durationToDropDownValue = "1000";
  List _durationsList = [
    "1000",
    "1500",
    "2000",
    "2500",
    "3000",
    "3500",
    "4000"
  ];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.backgroundCyan,
      body: SafeArea(
          child: Stack(
        children: [
          Positioned.fill(
            top: 0.0,
            left: 0.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Audio Mode",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Open-Sans",
                      fontWeight: FontWeight.w800,
                      fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 28.0),
                ),
                buildSelectedAudiosDetailsRow(),
                buildDurationFromRow(),
                buildDurationToRow(),
                Padding(
                  padding: EdgeInsets.only(top: 28.0),
                ),
                buildStartButton(context),
              ],
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
          Positioned(
            top: 0.0,
            right: 0.0,
            child: GestureDetector(
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
          SettingsCornerButton(),
        ],
      )),
    );
  }

  TextButton buildStartButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        var durationFrom = double.parse(_durationFromDropDownValue);
        var durationTo = double.parse(_durationToDropDownValue);
        if(durationFrom>durationTo){
          final snackBar = SnackBar(content: Text('Please make sure "Duration to" is greater than or equal to "Duration from"!'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
        AudioHomePage.fromDuration = durationFrom;
        AudioHomePage.toDuration = durationTo;
        var result = await Navigator.of(context).pushNamed("/audio_home");
        if(result=="restart")
          Navigator.pop(context, result);
      },
      child: Text(
        "Start",
        style: TextStyle(color: Colors.white),
      ),
      style: TextButton.styleFrom(backgroundColor: ColorHelper.backgroundGreen),
    );
  }

  Row buildSelectedAudiosDetailsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "Audio: ",
            style: TextStyle(
                color: Colors.white, fontFamily: "Open-Sans", fontSize: 16),
            textAlign: TextAlign.right,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        Expanded(
          child: Row(
            children: [
              Text(
                AudioData.getSelectedAudioFiles().length.toString() +
                    " file(s) selected",
                style: TextStyle(
                    color: Colors.white, fontFamily: "Open-Sans", fontSize: 16),
                textAlign: TextAlign.left,
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontFamily: "Open-Sans",
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Row buildDurationFromRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "Duration from (ms): ",
            style: TextStyle(
                color: Colors.white, fontFamily: "Open-Sans", fontSize: 16),
            textAlign: TextAlign.right,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        Expanded(
          child: DropdownButton(
            hint: _durationFromDropDownValue == null
                ? Text(
                    'None',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Open-Sans",
                        fontSize: 16),
                  )
                : Text(
                    _durationFromDropDownValue,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Open-Sans",
                        fontSize: 16),
                  ),
            dropdownColor: ColorHelper.backgroundCyan,
            underline: SizedBox(),
            items: _durationsList
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Open-Sans",
                            fontSize: 16),
                      ),
                    ))
                .toList(),
            onChanged: (val) {
              setState(() {
                _durationFromDropDownValue = val;
              });
            },
          ),
        )
      ],
    );
  }

  Row buildDurationToRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "Duration to (ms): ",
            style: TextStyle(
                color: Colors.white, fontFamily: "Open-Sans", fontSize: 16),
            textAlign: TextAlign.right,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        Expanded(
          child: DropdownButton(
            hint: _durationToDropDownValue == null
                ? Text(
              'None',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Open-Sans",
                  fontSize: 16),
            )
                : Text(
              _durationToDropDownValue,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Open-Sans",
                  fontSize: 16),
            ),
            dropdownColor: ColorHelper.backgroundCyan,
            underline: SizedBox(),
            items: _durationsList
                .map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Open-Sans",
                    fontSize: 16),
              ),
            ))
                .toList(),
            onChanged: (val) {
              setState(() {
                _durationToDropDownValue = val;
              });
            },
          ),
        )
      ],
    );
  }
}
