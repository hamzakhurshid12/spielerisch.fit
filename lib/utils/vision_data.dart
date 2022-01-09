import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../main.dart';

class VisionData {
  static String dataStr = "{}";
  static var dataJson;
  static List dataKeysList;
  static List<VisionMode> dataRecordsEn;
  static List<VisionMode> dataRecordsDe;


  static Future<String> getDataFromServer() async {
    try {
      var uriResponse = await http.get(
          Uri.parse("http://localhost/projects/modes.json"));
          //Uri.parse("https://spielerisch.fit/modes.json"));

      var responseStr = utf8.decode(uriResponse.bodyBytes);
      prefs.setString("vision_json", responseStr);
      prefs.commit();
      return responseStr;
    } on SocketException catch (e){
      if(prefs.containsKey("vision_json")){
        return prefs.getString("vision_json");
      } else {
        return null;
      }
    }
  }

  static void load() async {
    dataStr = await getDataFromServer();
    dataRecordsEn = List<VisionMode>();
    dataRecordsDe = List<VisionMode>();
    if(dataStr==null){
      return;
    }
    dataJson = json.decode(dataStr)["modes"];
    dataKeysList = dataJson.keys.toList();
    for(var x=0; x<dataKeysList.length;x++){
      //Bypassing all exercises which are not in the selected exercise category
      if(dataJson[dataKeysList[x]]["de"]["title"]!="" && dataJson[dataKeysList[x]]["de"]["title"]!=null) {
        var y = new VisionMode(
            dataJson[dataKeysList[x]]["de"]["title"],
            dataJson[dataKeysList[x]]["de"]["description"],
            dataJson[dataKeysList[x]]["de"]["img_base64"],
            dataJson[dataKeysList[x]]["de"]["images"],
            );
        dataRecordsDe.add(y);
      }
      if(dataJson[dataKeysList[x]]["en"]["title"]!="" && dataJson[dataKeysList[x]]["en"]["title"]!=null) {
        var y = new VisionMode(
          dataJson[dataKeysList[x]]["en"]["title"],
          dataJson[dataKeysList[x]]["en"]["description"],
          dataJson[dataKeysList[x]]["en"]["img_base64"],
          dataJson[dataKeysList[x]]["en"]["images"],
        );
        dataRecordsEn.add(y);
      }
    }
  }


}

class VisionMode {
  String title;
  String description;
  List<dynamic> imgBase64;
  List<dynamic> imgUrls;

  VisionMode(this.title, this.description, this.imgBase64, this.imgUrls);
}
