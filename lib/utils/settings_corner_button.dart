import 'package:flutter/cupertino.dart';


class SettingsCornerButton extends StatelessWidget {
  const SettingsCornerButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0.0,
      right: 0.0,
      child: GestureDetector(
        child: Container(
          width: 40,
          height: 40,
          color: Color.fromRGBO(148, 189, 60, 1.0),
          child: Image.asset("assets/images/menu_icon.png"),
        ),
        onTap: () async {
          final result =
          await Navigator.of(context).pushNamed('/settings');
          if (result == "restart") Navigator.of(context).pop(result);
        },
      ),
    );
  }
}