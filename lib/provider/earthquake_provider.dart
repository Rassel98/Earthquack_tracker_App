import 'dart:convert';

import 'package:eart_quith_app/model/earthquake_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class EarthquakeProvider extends ChangeNotifier{
  EarthquakeModel? earthquakeModel;
String from='2022-08-30',to='2022-08-31';
int minMagnitude=4;

  bool get getData=>earthquakeModel!=null;

  void setTime({required String newFrom, required String newTo,required int minMag}){
    from=newFrom;
    to=newTo;
    minMagnitude=minMag;
    getEarthquakeData();

  }

 void getEarthquakeData()async {

    print(from+to+minMagnitude.toString());

    final uri=Uri.parse('https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=$from&endtime=$to&minmagnitude=$minMagnitude');
    try{
      final response=await get(uri);
      final map=jsonDecode(response.body);
      if(response.statusCode==200){
        earthquakeModel=EarthquakeModel.fromJson(map);
        print(earthquakeModel!.features!.length);
        notifyListeners();
      }
      else{
        print(map['message']);
      }

    }catch(err){
      rethrow;
    }


  }
}