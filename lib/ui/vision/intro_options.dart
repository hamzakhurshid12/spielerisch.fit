import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spielerisch_fit/ui/vision/vision_home_screen.dart';
import 'package:spielerisch_fit/utils/ColorsHelper.dart';
import 'package:spielerisch_fit/utils/settings_corner_button.dart';

class IntroVision extends StatefulWidget {
  @override
  _IntroVisionState createState() => _IntroVisionState();
}

class _IntroVisionState extends State<IntroVision> {
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


  var _durationListMap = {
    "1 second": 1.0,
    "1.5 seconds": 1.5,
    "2 seconds": 2.0,
    "2.5 seconds": 2.5,
    "3 seconds": 3.0,
    "3.5 seconds": 3.5,
    "4 seconds": 4.0
  };

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
                  "Vision Mode",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Open-Sans",
                      fontWeight: FontWeight.w800,
                      fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 28.0),
                  child: buildModeSelectionRow(),
                ),
                _modeDropDownValue == "Stroop"
                    ? buildColorsSelectionRow()
                    : Container(),
                _modeDropDownValue == "Stroop"
                    ? buildDurationFromRow()
                    : Container(),
                _modeDropDownValue == "Stroop"
                    ? buildDurationToRow()
                    : Container(),
                Padding(
                  padding: EdgeInsets.only(top: 28.0),
                ),
                buildStartButton(context),
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
        VisionHomePage.totalDuration = 1.0;
        VisionHomePage.fromDuration = durationFrom;
        VisionHomePage.toDuration = durationTo;
        VisionHomePage.visionModeColors = _colorsListMap[_colorsDropDownValue];
        VisionHomePage.visionModeType = _modesListMap[_modeDropDownValue];
        var result = await Navigator.of(context).pushNamed("/vision_home");
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

  Row buildModeSelectionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "Mode: ",
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
            hint: _modeDropDownValue == null
                ? Text(
                    'None',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Open-Sans",
                        fontSize: 16),
                  )
                : Text(
                    _modeDropDownValue,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Open-Sans",
                        fontSize: 16),
                  ),
            dropdownColor: ColorHelper.backgroundCyan,
            underline: SizedBox(),
            items: _visionModes
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
                _modeDropDownValue = val;
              });
            },
          ),
        )
      ],
    );
  }

  Row buildColorsSelectionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "Colors: ",
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
            hint: _colorsDropDownValue == null
                ? Text(
                    'None',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Open-Sans",
                        fontSize: 16),
                  )
                : Text(
                    _colorsDropDownValue,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Open-Sans",
                        fontSize: 16),
                  ),
            dropdownColor: ColorHelper.backgroundCyan,
            underline: SizedBox(),
            items: _colorsList
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
                _colorsDropDownValue = val;
              });
            },
          ),
        )
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
