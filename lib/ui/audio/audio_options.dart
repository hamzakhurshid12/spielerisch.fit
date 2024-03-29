import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spielerisch_fit/ui/vision/vision_home_screen.dart';
import 'package:spielerisch_fit/utils/ColorsHelper.dart';
import 'package:spielerisch_fit/utils/audio_data.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:spielerisch_fit/utils/settings_corner_button.dart';

import 'audio_home_screen.dart';

class IntroAudio extends StatefulWidget {

  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  _IntroAudioState createState() => _IntroAudioState();
}

class _IntroAudioState extends State<IntroAudio> {

  List<Widget> animalsWidgets;
  List<Widget> birdsWidgets;
  List<Widget> hertzWidgets;
  List<Widget> punchesWidgets;
  List<Widget> sfxWidgets;
  List<Widget> shortMelodiesWidgets;

  List<List<Widget>> allAudioWidgets;

  String _modeDropDownValue = "Stroop";
  List _visionModes = ["Stroop", "Bear"];

  String _colorsDropDownValue = "1";
  List _colorsList = ["1", "2", "3"];

  String _durationDropDownValue = "1 second";
  List _durationsList = [
    "1 second",
    "1.5 seconds",
    "2 seconds",
    "2.5 seconds",
    "3 seconds",
    "3.5 seconds",
    "4 seconds"
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

  Map isAudioListChecked = {"isAllAnimalsChecked": false,
    "isAllBirdsChecked": false,
    "isAllHertzChecked": false,
    "isAllPunchesChecked": false,
    "isAllSfxChecked": false,
    "isAllShortMelodiesChecked": false,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initializeAudioWidgets();

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
                Padding(
                  padding: EdgeInsets.only(top: 28.0),
                ),
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
                  padding: EdgeInsets.only(top: 10.0),
                ),
                Text(
                  "Please select the audio files",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Open-Sans",
                      fontWeight: FontWeight.w800,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 28.0),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: allAudioWidgets.length,
                      itemBuilder: (_, index)  => Column(
                        children: allAudioWidgets[index],
                      ),
                  ),
                ),
                buildStartButton(context),
                Padding(
                  padding: EdgeInsets.only(top: 28.0),
                ),
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

  Widget buildStartButton(BuildContext context) {
    return SizedBox(
      width: 100.0,
      child: TextButton(
        onPressed: () async {
          if(AudioData.getSelectedAudioFiles().length==0){
            final snackBar = SnackBar(content: Text('Please select audio files to continue!'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            final result = await Navigator.of(context).pushNamed('/audio_intro_level_2');
            if (result == "restart")
              Navigator.of(context).pop(result);
          }
        },
        child: Text(
          "Continue",
          style: TextStyle(color: Colors.white),
        ),
        style: TextButton.styleFrom(backgroundColor: ColorHelper.backgroundGreen),
      ),
    );
  }

  void initializeAudioWidgets(){
    animalsWidgets = buildAudioSelectionWidgetSubList(AudioData.animalsMap, "isAllAnimalsChecked", "Animals");
    birdsWidgets = buildAudioSelectionWidgetSubList(AudioData.birdsMap, "isAllBirdsChecked", "Birds");
    hertzWidgets = buildAudioSelectionWidgetSubList(AudioData.hertzMap, "isAllHertzChecked", "Hertz");
    punchesWidgets = buildAudioSelectionWidgetSubList(AudioData.punchesMap, "isAllPunchesChecked", "Punches");
    sfxWidgets = buildAudioSelectionWidgetSubList(AudioData.sfxMap, "isAllSfxChecked", "SFX");
    shortMelodiesWidgets = buildAudioSelectionWidgetSubList(AudioData.shortMelodiesMap, "isAllShortMelodiesChecked", "Short Melodies");

    allAudioWidgets = [animalsWidgets, birdsWidgets, hertzWidgets, punchesWidgets, sfxWidgets, shortMelodiesWidgets];
  }

  List<Widget> buildAudioSelectionWidgetSubList(List<Map<String, dynamic>> audiosMap, String allCheckedVar, String name){
    var output = audiosMap.map((e) =>
        ListTile(
          leading: GestureDetector(
            onTap: () {
              this.setState(() {
                e["isChecked"] = !e["isChecked"];
                print("Toggled Checkbox");
              });
            },
            child: Icon(
              e["isChecked"]? Icons.check_box : Icons.check_box_outline_blank,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: Text(
            e["filename"],
            style: TextStyle(color: Colors.white),
          ),
          trailing: GestureDetector(
            onTap: () async {
              await widget.audioPlayer?.stop();
              widget.audioPlayer = await widget.audioCache.play(e["path"]);
              e["isPlaying"] = true;
            },
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
    ).toList();
    output.insert(0,
      ListTile(
        leading: GestureDetector(
          onTap: () {
            this.setState(() {
              isAudioListChecked[allCheckedVar] = !isAudioListChecked[allCheckedVar];
              for(var x=0; x<audiosMap.length; x++){
                if(isAudioListChecked[allCheckedVar])
                  audiosMap[x]["isChecked"] = true;
                else
                  audiosMap[x]["isChecked"] = false;
              }
            });
          },
          child: Icon(
            isAudioListChecked[allCheckedVar]? Icons.check_box : Icons.check_box_outline_blank,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Open-Sans",
              fontWeight: FontWeight.w800,
              fontSize: 18),
        ),
      ),
    );

    return output;
  }
}
