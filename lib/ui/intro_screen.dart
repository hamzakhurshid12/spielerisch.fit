import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spielerisch_fit/utils/ColorsHelper.dart';
import 'package:spielerisch_fit/utils/default_white_text_button.dart';
import 'package:spielerisch_fit/utils/exercises_data.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IntroScreen extends StatelessWidget {
  bool isInternetConnected = true;
  static bool isVisionModeActive = false;
  bool isAudioModeActive = false;

  @override
  Widget build(BuildContext context) {
    new Future.delayed(const Duration(seconds: 5), () async {
      if(!(ExercisesData.dataRecordsDe.length > 0 || ExercisesData.dataRecordsEn.length > 0)) {
        await Fluttertoast.showToast(
            msg: "No data synchronised for offline use.\nPlease turn on your internet connection to continue!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black12,
            textColor: Colors.white,
            fontSize: 16.0
        );
        await ExercisesData.load();
      }
    });

    return Container(
      color: ColorHelper.backgroundCyan,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
              child: Image.asset("assets/images/logo-spielerisch-fit.png"),
          ),
          Positioned(
            bottom: 40,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                DefaultWhiteTextButton(
                  text: "Vision Mode",
                  onTap: () async {
                    IntroScreen.isVisionModeActive = true;
                    await Navigator.pushNamed(context, '/vision_intro');
                    IntroScreen.isVisionModeActive = false;
                  },
                ),
                DefaultWhiteTextButton(
                  text: "Normal Mode",
                  onTap: () async {
                    IntroScreen.isVisionModeActive = true;
                    await Navigator.pushNamed(context, '/home');
                  },
                ),
                DefaultWhiteTextButton(
                  text: "Audio Mode",
                  onTap: () async {
                    IntroScreen.isVisionModeActive = true;
                    await Navigator.pushNamed(context, '/audio_intro');
                    IntroScreen.isVisionModeActive = false;
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


