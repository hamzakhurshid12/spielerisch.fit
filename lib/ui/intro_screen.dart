import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spielerisch_fit/utils/ColorsHelper.dart';
import 'package:spielerisch_fit/utils/exercises_data.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IntroScreen extends StatelessWidget {
  bool isInternetConnected = true;
  static bool isVisionModeActive = false;
  bool isAudioModeActive = false;

  @override
  Widget build(BuildContext context) {
    new Future.delayed(const Duration(seconds: 5), () async {
      if(ExercisesData.dataRecordsDe.length > 0 || ExercisesData.dataRecordsEn.length > 0) {
        if(!IntroScreen.isVisionModeActive){
          final result = await Navigator.pushNamed(context, '/home');
          if(result=="restart")
            this.build(context);
          else
            SystemNavigator.pop();
        }
      } else {
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
        Future.delayed(Duration(seconds: 5),(){
          this.build(context);
        });
      }
    });

    return Container(
      color: ColorHelper.backgroundCyan,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
              child: Image.asset("assets/images/logo-spielerisch-fit.png")),
          Positioned(
            bottom: 40,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        IntroScreen.isVisionModeActive = true;
                        final result = await Navigator.pushNamed(context, '/vision_intro');
                        if(result=="restart")
                          this.build(context);
                        else
                          SystemNavigator.pop();
                        IntroScreen.isVisionModeActive = false;
                        this.build(context);
                      },
                      child: Text(
                        "Vision mode",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        IntroScreen.isVisionModeActive = true;
                        final result = await Navigator.pushNamed(context, '/audio_intro');
                        if(result=="restart")
                          this.build(context);
                        else
                          SystemNavigator.pop();
                        IntroScreen.isVisionModeActive = false;
                        this.build(context);
                      },
                      child: Text(
                        "Audio mode",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
