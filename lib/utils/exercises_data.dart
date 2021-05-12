
import 'dart:convert';
import 'package:http/http.dart' as http;

class ExercisesData {
  static String dataStr = "{}";
  static var dataJson;
  static List dataKeysList;
  static List<Exercise> dataRecordsEn;
  static List<Exercise> dataRecordsDe;

  static Future<String> getDataFromServer() async {
    var uriResponse = await http.get(Uri.parse("https://spielerisch.fit/exercises.json"));
    return utf8.decode(uriResponse.bodyBytes);
  }

  static void load() async {
    dataStr = await getDataFromServer();
    dataJson = json.decode(dataStr)["exercises"];
    dataKeysList = dataJson.keys.toList();
    dataRecordsEn = List<Exercise>();
    dataRecordsDe = List<Exercise>();
    for(var x=0; x<dataKeysList.length;x++){
      if(dataJson[dataKeysList[x]]["de"]["shortname"]=="")
        continue;
      if(dataJson[dataKeysList[x]]["de"]["shortname"]!="" && dataJson[dataKeysList[x]]["de"]["shortname"]!=null) {
        var y = new Exercise.name(
            dataJson[dataKeysList[x]]["type"],
            dataJson[dataKeysList[x]]["info-pic"],
            dataJson[dataKeysList[x]]["partner"],
            dataJson[dataKeysList[x]]["force"],
            dataJson[dataKeysList[x]]["multiplicator"],
            dataJson[dataKeysList[x]]["de"]["shortname"],
            dataJson[dataKeysList[x]]["de"]["name"],
            dataJson[dataKeysList[x]]["de"]["info"],
            dataJson[dataKeysList[x]]["de"]["link"],
            dataJson[dataKeysList[x]]["de"]["link-test"],
            dataJson[dataKeysList[x]]["de"]["link-info"]);
        dataRecordsDe.add(y);
      }
      if(dataJson[dataKeysList[x]]["en"]["shortname"]!="" && dataJson[dataKeysList[x]]["en"]["shortname"]!=null) {
        var y = new Exercise.name(
            dataJson[dataKeysList[x]]["type"],
            dataJson[dataKeysList[x]]["info-pic"],
            dataJson[dataKeysList[x]]["partner"],
            dataJson[dataKeysList[x]]["force"],
            dataJson[dataKeysList[x]]["multiplicator"],
            dataJson[dataKeysList[x]]["en"]["shortname"],
            dataJson[dataKeysList[x]]["en"]["name"],
            dataJson[dataKeysList[x]]["en"]["info"],
            dataJson[dataKeysList[x]]["en"]["link"],
            dataJson[dataKeysList[x]]["en"]["link-test"],
            dataJson[dataKeysList[x]]["en"]["link-info"]);
        dataRecordsEn.add(y);
      }
    }
  }
}

class Exercise{
  var type;
  var info_pic;
  var partner;
  var force;
  var multiplicator;
  var shortname;
  var name;
  var info;
  var link;
  var link_test;
  var link_info;

  Exercise.name(
      this.type,
      this.info_pic,
      this.partner,
      this.force,
      this.multiplicator,
      this.shortname,
      this.name,
      this.info,
      this.link,
      this.link_test,
      this.link_info,
      );
}