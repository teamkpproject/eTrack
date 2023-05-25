import "dart:convert";
import "dart:math";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:etrack/MapFiles/location_tracker.dart";
import "package:etrack/constants/textDesigns.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart" as latLng;
import "package:provider/provider.dart";
import "package:url_launcher/url_launcher.dart";
import '../../../models/lctn_data.dart';
import "../../../models/user.dart";


















class MapLoc extends StatefulWidget {

  List<UserData> locations;
  String building;
  String userName;

  MapLoc({required this.locations,required this.building,required this.userName});

  @override
  State<MapLoc> createState() => _MapLocState();
}

class _MapLocState extends State<MapLoc> {

  var _location=LocTracker();
  List<addressResolution> _locationFromNames=[];
  List<LocationDataFormat> _locationsMarked=[];


  LocationDataFormat loctnDta=LocationDataFormat(lat: 11.876176, long: 75.374351);
  LocationDataFormat _searchLocation=LocationDataFormat(lat: 11.2450558, long: 75.7754716);

  MapController _mapController=MapController();

  List<Marker> _markers=[];
  double zoom=18;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _location.initilaiseService();
    _location.permissionForService();
    getLocation();
    List<UserData> locations=widget.locations;
    for(int i=0;i<locations.length;i++){
      _locationsMarked.add(LocationDataFormat(lat: locations[i].lat, long: locations[i].long));
    }
  }

  //for getting hint
  void getPlacesFromNames(val) async{
    _locationFromNames=await LocTracker().getLocations(val);
    setState(() {

    });
  }

  void addMarker(latLng.LatLng location){
    _locationsMarked.add(LocationDataFormat(lat: location.latitude, long: location.longitude));
    setState(() {

    });
  }

  void reNavigate(double lat,double long) {
    print("Renavigating");
    _locationFromNames=[];
    _searchLocation=LocationDataFormat(lat: lat, long: long);
    _mapController.move(latLng.LatLng(lat, long), zoom);
    setState(() {


    });
  }
  void getLocation() async{
    loctnDta=await _location.currentLocationAccess();
    print('latitude ${loctnDta.lat} longitude ${loctnDta.long}');
    _searchLocation=LocationDataFormat(lat: loctnDta.lat, long: loctnDta.long);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          FlutterMap(
            mapController: _mapController,
          options:MapOptions(
              onTap: (tapPosition,point)=>{
                print(point.toString()),
                _mapController.move(latLng.LatLng(point.latitude, point.longitude), zoom),
                getLocation(),
                addMarker(point),
              },
              center:latLng.LatLng(_searchLocation.lat,_searchLocation.long),
              zoom:zoom,
              ),
              children: [
                  TileLayer(
                  urlTemplate: 'https://c.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers:List.generate(_locationsMarked.length, (index)  {
                      return Marker(
                          point:latLng.LatLng(_locationsMarked[index].lat, _locationsMarked[index].long) ,
                          width: 50,
                          height: 50,
                          builder: (BuildContext context){
                            return IconButton(
                              icon: Icon(Icons.location_on),
                              onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        content: Row(
                                          children: [
                                            ElevatedButton(
                                              child:Text("Remove Marker"),
                                              onPressed: (){
                                                _locationsMarked.removeAt(index);
                                                setState(() {

                                                });
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                );
                              },
                            );
                          }
                      );
                    })
                  ),
              ],
              nonRotatedChildren: [
              RichAttributionWidget(attributions: [
                TextSourceAttribution(
                'Open Street Map Contibutors',
                onTap: ()=>launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                )
                ])
              ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 50,),
                  TextFormField(
                    onChanged: (val){
                      getPlacesFromNames(val);
                    },
                    decoration: textStyle.copyWith(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search Location'
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*0.05*_locationFromNames.length,
                    child: ListView.builder(
                        itemCount: _locationFromNames.length,
                        itemBuilder: (context,index){
                          print('location ${index} ${_locationFromNames[index].placeName}');
                      return Card(
                        child: ListTile(
                          onTap: (){
                            print('lat ${_locationFromNames[index].lat} long ${_locationFromNames[index].long}');
                            reNavigate(_locationFromNames[index].lat, _locationFromNames[index].long);
                          },
                          tileColor: Colors.white,
                          title: Text(_locationFromNames[index]==null?'Error':_locationFromNames[index].placeName),
                        ),
                      );
                    }),
                  ),

                  Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      child: Text("Complete"),
                      onPressed: () async{

                        DateTime now=DateTime.now();
                        String date="${now.day}-${now.month}-${now.year}";

                        print("date ${date}");
                        List<int> value=[];
                        List<GeoPoint> geoPoints=[];
                        List<bool> isVisited=[];
                        List<String> checkpoints=[];
                        for(int i=0;i<_locationsMarked.length;i++){
                          value.add(i);
                          checkpoints.add("checkpoint${i+1}");
                          geoPoints.add(GeoPoint(_locationsMarked[i].lat, _locationsMarked[i].long));
                          isVisited.add(false);
                        }
                        print(" ${checkpoints.length} ${geoPoints.length} ${isVisited.length}");
                        var mapLocationsList=value.map((e) => [geoPoints[e],isVisited[e]]).toList();
                        var mapLocations=Map.fromIterables(checkpoints, mapLocationsList);
                        var mapNoCheckpoints=Map.fromIterables({"no_checkpoints"}, [checkpoints.length]);
                        var mapData={};

                        mapData.addAll(mapLocations);
                        mapData.addAll(mapNoCheckpoints);

                        await FirebaseFirestore.instance.collection("admins").doc(widget.building).collection("users").doc(widget.userName).collection("date").doc(date).set(
                           Map.from(mapData));

                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],

      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
    );
  }
}
