import 'package:flutter/cupertino.dart';
import 'package:spielerisch_fit/utils/ColorsHelper.dart';
import 'package:url_launcher/url_launcher.dart';

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
                GestureDetector(
                  onTap: () async {await launch("https://www.alive656.com/club/villach/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (1).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://www.asvoewien.at/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (2).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://www.crossfit-hartberg.at/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (3).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://www.der-cyclist.com/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (4).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://www.dreifuenf.at/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (5).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://www.facebook.com/fitnessgabiruthofer/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (6).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://physiotherapie-kohlhauser.at/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (7).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://www.kulmx.at/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (8).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://www.loewinnenherz.com/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (9).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://www.binaerschmiede.at/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (10).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://www.fitboxen.at/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (11).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://www.neuroboxen.com/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (12).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://www.mentalshop.at/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (13).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://www.polizeisv-wien.at/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (14).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("http://www.physio-ehrenhoefer.at/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (15).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://volleyball.tsv-hb.net/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (16).png"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {await launch("https://www.vk-impuls.at/");},
                  child: SizedBox(
                    child: Image.asset("assets/images/partner (17).png"),
                  ),
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
