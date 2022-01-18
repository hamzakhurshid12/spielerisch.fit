
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../main.dart';

class ExercisesData {
  static String dataStr = "{}";
  static var dataJson;
  static List dataKeysList;
  static List<Exercise> dataRecordsEn;
  static List<Exercise> dataRecordsDe;
  static var partnersMap;
  static var partnersUrlsMap;
  static var _partnersMapJsonStr = '{"tsvhb_vb": 16, "ruthofer": 6, "physioehrenh": 15, "cyclist": 4, "kulmx": 8, "loeherz": 9, "mentalshop": 13, "annamariafitness": 18, "crossfithb": 3, "physiokohlauser": 7, "vkimpuls": 17, "alive365": 1, "neuroboxen": 12, "fitboxen": 11}';
  static var _partnersUrlsJsonStr = '{"1": "https://www.alive656.com/club/villach/", "2": "https://www.asvoewien.at/", "3": "https://www.crossfit-hartberg.at/", "4": "https://www.der-cyclist.com/", "5": "https://www.dreifuenf.at", "6": "https://www.facebook.com/fitnessgabiruthofer/", "7": "https://physiotherapie-kohlhauser.at/", "8": "https://www.kulmx.at/", "9": "https://www.loewinnenherz.com/", "10": "https://www.binaerschmiede.at/", "11": "https://www.fitboxen.at/", "12": "https://www.neuroboxen.com/", "13": "https://www.mentalshop.at/", "14": "https://www.polizeisv-wien.at/", "15": "http://www.physio-ehrenhoefer.at/", "16": "https://volleyball.tsv-hb.net/", "17": "https://www.vk-impuls.at/"}';
  static int selectedExerciseType = 0;
  static List exerciseTypes = ['All', 'Fitness', 'Boxing', 'Fitboxen', 'Partner', 'Mobility', 'Atmung', 'Achtsamkeit', 'Crossfit'];

  static Future<String> getDataFromServer() async {
    try {
      var uriResponse = await http.get(
          Uri.parse("http://localhost/projects/exercises.json"));
          //Uri.parse("https://spielerisch.fit/exercises.json"));
      var responseStr = utf8.decode(uriResponse.bodyBytes);
      prefs.setString("exercises_json", responseStr);
      prefs.commit();
      return responseStr;
    } on SocketException catch (e){
      if(prefs.containsKey("exercises_json")){
        return prefs.getString("exercises_json");
      } else {
        return null;
      }
    }
  }

  static void load() async {
    partnersMap = json.decode(_partnersMapJsonStr);
    partnersUrlsMap = json.decode(_partnersUrlsJsonStr);
    dataStr = await getDataFromServer();
    dataRecordsEn = List<Exercise>();
    dataRecordsDe = List<Exercise>();
    if(dataStr==null){
      return;
    }
    dataJson = json.decode(dataStr)["exercises"];
    dataKeysList = dataJson.keys.toList();
    for(var x=0; x<dataKeysList.length;x++){
      //Bypassing all exercises which are not in the selected exercise category
      if(_getExerciseType()!='All'){ //only bypass some if a category other than 'All' is selected
        int _selectedExerciseIndex = exerciseTypes.indexOf(_getExerciseType());
        if(dataJson[dataKeysList[x]]['type']!=_selectedExerciseIndex)
          continue;
      }
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

  static String _getExerciseType(){
    if(prefs.containsKey('selectedExerciseType'))
      return prefs.getString('selectedExerciseType');
    else
      return 'All';
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