import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'ColorsHelper.dart';

class DefaultWhiteTextButton extends StatelessWidget {
  const DefaultWhiteTextButton({
    Key key, this.onTap, this.text,
  }) : super(key: key);

  final Function onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(kIsWeb? 10.0: 0.0),
        child: Container(
          height: 50,
          width: kIsWeb? 300 : 180,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [BoxShadow(blurRadius: 4, color: Colors.blueGrey, offset: Offset(3,3),),],
          ),
          child: Text(
            text,
            style: TextStyle(color: ColorHelper.backgroundCyan),
          ),
        ),
      ),
    );
  }
}