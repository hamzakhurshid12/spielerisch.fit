import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumberInputTextField extends StatelessWidget {
  NumberInputTextField({
    Key key, this.onChangeTextField, this.text,
  }) : super(key: key);

  final TextEditingController controller = TextEditingController();
  final Function onChangeTextField;
  String text = "";

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      onChangeTextField(controller.text);
    });
    controller.text = text;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          hintText: 'e.g. 1000, 5500',
          hintStyle: TextStyle(color: Colors.white)
      ),
      style: TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
    );
  }
}