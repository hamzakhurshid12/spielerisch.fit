import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spielerisch_fit/utils/ColorsHelper.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    new Future.delayed(const Duration(seconds: 3), () async {
      final result = await Navigator.pushNamed(context, '/home');
      if(result=="restart")
        this.build(context);
      else
        SystemNavigator.pop();
    });

    return Container(
      color: ColorHelper.backgroundCyan,
      child: SizedBox(
          height: 40,
          child: Image.asset("assets/images/logo-spielerisch-fit.png")
      ),
    );
  }
}
