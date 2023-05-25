import 'dart:convert';

import 'package:etrack/models/lctn_data.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';


















class LocTracker{

  var location=new Location();
  var _serviceEnabled;
  var _permissionGranted;

  void initilaiseService() async{
    _serviceEnabled=await location.serviceEnabled();
    if(!_serviceEnabled){
      _serviceEnabled=await location.requestService();
      if(!_serviceEnabled){
        return;
      }
    }
  }

  void permissionForService() async{
    _permissionGranted=await location.hasPermission();
    if(_permissionGranted==PermissionStatus.denied){
      _permissionGranted=await location.requestPermission();
      if(_permissionGranted !=PermissionStatus.granted){
        return;
      }
    }
  }

  Future<LocationDataFormat> currentLocationAccess() async{
    var currentLocation = await location.getLocation();
    print(currentLocation.toString());
    LocationDataFormat loctnDta=LocationDataFormat(lat: currentLocation.latitude!, long: currentLocation.longitude!);
    return loctnDta;
  }

  Future<List<addressResolution>> getLocations(String address) async{
    Uri uri=Uri.parse("https://geocode.maps.co/search?q=${address}");
    var locationsJSON=await http.get(uri);

    List<addressResolution> _locations=jsonDecode(locationsJSON.body).map<addressResolution>((val){
      return addressResolution(lat: double.parse(val["lat"]), long: double.parse(val["lon"]), placeName: val["display_name"]);

    }).toList();

   return _locations;
  }
}








