import 'package:flutter/cupertino.dart';
import 'package:spielerisch_fit/utils/ColorsHelper.dart';

class PartnersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorHelper.backgroundCyan,
      child: SafeArea( child:Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 10.0),),
                SizedBox(
                  child: Image.asset("assets/images/partner (1).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (2).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (3).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (4).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (5).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (6).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (7).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (8).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (9).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (10).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (11).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (12).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (13).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (14).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (15).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (16).png"),
                ),
                SizedBox(
                  child: Image.asset("assets/images/partner (17).png"),
                ),
              ],
            ),
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
        ],
      ),
    ),
    );
  }
}
