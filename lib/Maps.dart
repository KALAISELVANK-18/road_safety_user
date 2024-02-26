import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class Myapps extends StatefulWidget {
  const Myapps({Key? key}) : super(key: key);

  @override
  State<Myapps> createState() => _MyappState();
}

class _MyappState extends State<Myapps> {


  sendmeassage(String token,String boy,String title)async{

    final List<dynamic>data= await _getCurrentLocation();
    if(boy=="emergency"){
    try{
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String,String>{
          'Content-Type':'application/json',
          'Authorization':'key=AAAA8p3j6Z8:APA91bFiZ2bMCU1K2oZx0a0tJlg10CoEcNc5DyGgcRCRxJHG7yjGrRHF6F3WA6Urk0n2feHDW9EV7COPnOYWukEd7JBRAFhpJv7-XYCREhyHq-VDzQoM5oahjKXmQjubRBIQNdZVzVMW'
        },
        body: jsonEncode(
          <String,dynamic>{
            'priority':'high',
            'data':<String,dynamic>{
              'click_action':'FLUTTER_NOTIFICATION_CLICK',
              'status':'done',
              'body':boy,
              'title':title+",in ${data[1]}",
            },

            "notification":<String,dynamic>{
              "title":boy,
              "body":title+",in ${data[1]}",
              "android_channel_id":"dbnoti"
            },

            "to":"evP5iYbkR-yYZD78yhRdKJ:APA91bEBEvUR9Z5QN9eovJQf4a7S4az_ROrpgGVung_BU-cUCwRlWgJ8hZi3iJcRSWOoG7AvsSE_S4S_6tLmBixDm0GblnoDQyszrKpO_Gc69TjldEyuiIEJJ1kXg6EUGdyco7gckj6c",
          },
        ),
      );

      print("work finished");
    }

    catch(e){
      if(kDebugMode){
        print("error push notification");

      }
    }

    await FirebaseFirestore.instance.collection("notifications").doc().set({
      "location":data[1],
      "vehicleno":title,
      "type":"emergency",
      "status":0,
      "position":data[0],
      "timestamp": Timestamp.now(),
      "phone_no":7904006648
    });
    }
  }

  Future <void> bo(String user,String type)async {

    sendmeassage("evP5iYbkR-yYZD78yhRdKJ:APA91bEBEvUR9Z5QN9eovJQf4a7S4az_ROrpgGVung_BU-cUCwRlWgJ8hZi3iJcRSWOoG7AvsSE_S4S_6tLmBixDm0GblnoDQyszrKpO_Gc69TjldEyuiIEJJ1kXg6EUGdyco7gckj6c", type, "$user");
  }

  FlutterTts flutterTts = FlutterTts();


  GoogleMapController? mapController;
 // Location location = Location();
  bool isdirection=false;
  int limit=0;
  int chellan=0;
  bool istart=false;
  String origin="";
  String destination="";
  Set<Marker> markers = {};
  TextEditingController from=new TextEditingController(text:"your location");
  TextEditingController to=new TextEditingController();
  String? _currentAddress;
  Set<Polyline> polylines = {};
  Position? _currentPosition;
  double latitude = 0;
  double speed=0;
  double longitude = 0;
  FutureOr<void> _openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  FutureOr<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location services are disabled'),
            content: Text('Please enable location services to use this app.'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Open Settings'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _openLocationSettings(); // Open location settings
                },
              ),
            ],
          );
        },
      );
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }



  void _trackLocation() {
    Geolocator.getPositionStream(

        locationSettings:LocationSettings(accuracy:LocationAccuracy.bestForNavigation) )
        .listen((currentLocation) async{

        LatLng latLng = LatLng(currentLocation.latitude, currentLocation.longitude);
        if(istart==true){

          
          setState(() {
            speed=(currentLocation.speed)*3.6;
            if(speed>=20 && limit<=5){
              limit+=1;
            }
          });
          
          if(limit>0 && limit<=5 && chellan==0) {
            if(limit<4)
            await flutterTts.speak(
                "You have crossed the speed limit for ${limit} times..");
            else if(limit==4)
              await flutterTts.speak(
                  "This is the last warning, you have crossed the speed limit for ${limit} times..");
            else {
              await flutterTts.speak(
                  "You have exceeded the alerted speed limits, drive carefully!..");

              
                try{
                  
                  final data=await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email!).doc("personinfo").get();
                  
                  await http.post(
                    Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    headers: <String,String>{
                      'Content-Type':'application/json',
                      'Authorization':'key=AAAA8p3j6Z8:APA91bFiZ2bMCU1K2oZx0a0tJlg10CoEcNc5DyGgcRCRxJHG7yjGrRHF6F3WA6Urk0n2feHDW9EV7COPnOYWukEd7JBRAFhpJv7-XYCREhyHq-VDzQoM5oahjKXmQjubRBIQNdZVzVMW'
                    },
                    body: jsonEncode(
                      <String,dynamic>{
                        'priority':'high',
                        'data':<String,dynamic>{
                          'click_action':'FLUTTER_NOTIFICATION_CLICK',
                          'status':'done',
                          'body':"speed limit",
                          'title':"gone",
                        },
                        "notification":<String,dynamic>{
                          "title":"Speed limit",
                          "body":data.get("vehicle_number"),
                          "android_channel_id":"dbnoti"
                        },
                        "to":"evP5iYbkR-yYZD78yhRdKJ:APA91bEBEvUR9Z5QN9eovJQf4a7S4az_ROrpgGVung_BU-cUCwRlWgJ8hZi3iJcRSWOoG7AvsSE_S4S_6tLmBixDm0GblnoDQyszrKpO_Gc69TjldEyuiIEJJ1kXg6EUGdyco7gckj6c",
                      },
                    ),
                  );

                  await FirebaseFirestore.instance.collection("notifications").doc().set({
                  "phone_number":data.get("phone_number"),
                  "type":"speedlimit",
                  "vehicle_number":data.get("vehicle_number"),
                  "status":0,
                    "license_number":data.get("license_number"),
                  "timestamp": Timestamp.now()
                  });

                }

                catch(e){
                  if(kDebugMode){
                    print("error push notification");

                  }
                }


              }
            ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Container(
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                     color: Colors.redAccent
                   ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text('You have crossed the speed limit..',style: TextStyle(color: Colors.white),),
                  ),
                )));


          
          }
        _updateMarkerPosition(latLng);
        
        }
        else
          {
            print("iam out");
            return;
          }
        }
        );

 
  }

  void _updateMarkerPosition(LatLng latLng) {
    final MarkerId markerId = MarkerId('user_location');
    final Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    setState(() {
      markers.removeWhere((marker) => marker.markerId == markerId);
      markers.add(marker);
    });

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(latLng.latitude, latLng.longitude), 1000));
  }

  FutureOr<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition()
        .then((Position position) {
      setState(() => _currentPosition = position);

    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<List<dynamic>> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    List<dynamic> data=[];
    if (!hasPermission) return data;
    await Geolocator.getCurrentPosition()
        .then((Position position) async{
      data.add("${position.latitude},${position.longitude}");

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          Placemark currentPlace = placemarks[0];
          String address = '${currentPlace.street}, ${currentPlace.locality}, ${currentPlace.country}';
          print('Current Address: $address');
          data.add(address);
            print("we are on the way");
          // You can access other details from currentPlace like postalCode, name, etc.
        } else {
          print('No location details found');

        }
      } catch (e) {
        print('Error: $e');

      }


    }).catchError((e) {
      debugPrint(e);
    });
    return data;
  }

  Future<void> getDirections() async {

    String apiKey = 'AIzaSyDLo8dy5jkBPcvZyEgUyA88SGVyHllZgio';


    if(from.text!="" && to.text!=""){

    await Geolocator.getCurrentPosition()
        .then((Position position) {
            setState(() {
              origin="${position.latitude},${position.longitude}";

            });

          }).catchError((e) {
            debugPrint(e);
          });


      try {

        await geocoding.locationFromAddress(to.text).then((value){
          setState(() {

            destination = '${value.first.latitude},${value.first.longitude}';

            final MarkerId markerId = MarkerId('destination_location');
            final Marker marker = Marker(
              markerId: markerId,
              position: LatLng(value.first.latitude,value.first.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            );
            markers.removeWhere((marker) => marker.markerId == markerId);
            markers.add(marker);
          });
        });

      } catch (e) {
        print('Error: $e');
      }

    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {

      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> routes = data['routes'];

      if (routes.isNotEmpty) {

        // List<dynamic> legs = routes[0]['legs'];
        // for (var leg in legs) {
        //   List<dynamic> steps = leg['steps'];
        //   for (var step in steps) {
        //     String instruction = step['html_instructions'];
        //     double distance = step['distance']['value'] / 1000.0; // in kilometers
        //     print('Instruction: $instruction, Distance: $distance km');
        //     // Use Text-to-Speech to provide voice guidance for each instruction
        //     // Example: Use flutter_tts or another TTS package to speak the instructions
        //   }}


        List<LatLng> decodedRoutePoints = _decodePolyline(routes[0]['overview_polyline']['points']);
        setState(() {
          polylines.add(Polyline(
            polylineId: PolylineId('route'),
            points: decodedRoutePoints,
            color: Colors.blue,
            width: 5,
          ));
        });

        // Optional: Animate the camera to fit the bounds of the route
        if (mapController != null && decodedRoutePoints.isNotEmpty) {
          LatLngBounds bounds = _getBounds(decodedRoutePoints);
          mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
        }
      }


    } else {
      print('Failed to fetch directions. Status code: ${response.statusCode}');
    }}

  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double finalLat = lat / 1E5;
      double finalLng = lng / 1E5;
      points.add(LatLng(finalLat, finalLng));
    }
    return points;
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double minLat = points[0].latitude, maxLat = points[0].latitude;
    double minLng = points[0].longitude, maxLng = points[0].longitude;
    for (LatLng point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }
    return LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng));
  }


  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(2.0);
    flutterTts.setPitch(1.0);
    // TODO: implement initState
    _getCurrentPosition();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body:StreamBuilder<DocumentSnapshot>(
          stream:  FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email!).doc("personinfo").snapshots(),
          builder: (context, AsyncSnapshot snapshot) {



            if (snapshot.hasError) {

              return Text("${snapshot.error}");
            }
            else
            {

              if(snapshot.hasData)
              {

                return ListView(
                  physics: NeverScrollableScrollPhysics(),

                  children: [
                    Stack(children: [


                      Container(
                        height: 1000,
                        child: Stack(
                            children:[ SafeArea(

                              child:_currentPosition?.longitude!=null
                                  ? GoogleMap(

                                initialCameraPosition: CameraPosition(
                                  target: LatLng(_currentPosition!.latitude,_currentPosition!.longitude),
                                  zoom: 13,
                                ),
                                //markers:markers,

                                polylines: polylines,
                                markers: markers,
                              )
                                  : Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                              (istart==true)?Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(top:560),
                                  child: Row(
                                    children: [

                                      Card(
                                        shape: CircleBorder(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(14.0),
                                          child: Text("${speed.toStringAsFixed(0)}",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),
                                        ),),

                                      Text("Km/hr",style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),),

                                    ],
                                  ),
                                ),
                              ):SizedBox()
                            ]
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (!istart==true)?Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 5.0,
                                      blurRadius: 5.0,
                                      offset: Offset(0, 3), // changes the shadow position
                                    ),
                                  ],
                                  color: Colors.white,borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(Icons.share_location_outlined,color: Colors.blue,),
                                              ),
                                              SizedBox(
                                                child: Column(
                                                  children: [
                                                    Text(".\n.\n.\n",style: TextStyle(height: 0.5,fontWeight: FontWeight.bold,fontSize: 22,
                                                        color: Colors.greenAccent
                                                    ),),


                                                  ],
                                                ),),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(Icons.location_on_outlined,color: Colors.red,),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              Container(
                                                width: 200,
                                                height: 50,
                                                child: TextFormField(
                                                  keyboardType: TextInputType.text,
                                                  controller: from,
                                                  style: TextStyle(color: Colors.blueAccent,fontSize: 15),
                                                  decoration: InputDecoration(

                                                      labelStyle: TextStyle(
                                                          color: Colors.blueAccent
                                                      ),
                                                      filled: true, //<-- SEE HERE
                                                      fillColor: Colors.white,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.grey),
                                                          borderRadius: BorderRadius.circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.grey),
                                                          borderRadius: BorderRadius.circular(10)),
                                                      hintText: 'Current location'),
                                                ),
                                              ),
                                              SizedBox(height: 15,),
                                              Container(
                                                width: 200,
                                                height: 50,
                                                child: TextFormField(
                                                  onEditingComplete: (){
                                                    setState(() {
                                                      polylines={};
                                                      destination="";
                                                    });

                                                  },
                                                  style: TextStyle(color: Colors.black,fontSize: 16),
                                                  keyboardType: TextInputType.text,
                                                  controller: to,
                                                  decoration: InputDecoration(
                                                      filled: true, //<-- SEE HERE
                                                      fillColor: Colors.white,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.grey),
                                                          borderRadius: BorderRadius.circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.grey),
                                                          borderRadius: BorderRadius.circular(10)),
                                                      hintText: 'Destination'),
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 20,),
                                      ],
                                    ),

                                    TextButton(
                                      onPressed: ()async{
                                        setState(() {
                                          if(to.text!=""){
                                            istart=true;


                                            if(polylines.isEmpty){
                                              getDirections();
                                            }
                                          }});
                                        _trackLocation();
                                      },
                                      child: Container(

                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.blueAccent
                                        ),
                                        child: (istart!=true)?Padding(
                                          padding: const EdgeInsets.symmetric(horizontal:10,vertical: 10),
                                          child: Container(
                                            width: 70,
                                            child: Row(
                                              children: [
                                                Text("Start",style: TextStyle(color: Colors.white),),
                                                SizedBox(width: 10,),
                                                RippleAnimation(
                                                    color: Colors.cyanAccent,
                                                    delay: const Duration(milliseconds: 300),
                                                    repeat: true,
                                                    minRadius: 13,
                                                    ripplesCount: 2,
                                                    child: Icon(Icons.navigation,color: Colors.white,))
                                              ],
                                            ),
                                          ),
                                        ):SizedBox(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ):SizedBox(),

                          (istart==true)?Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: ()async{
                                  setState(() {
                                    istart=false;
                                    polylines={};
                                    markers.removeWhere((marker) => marker.markerId == "destination_location");
                                    markers.removeWhere((marker) => marker.markerId == "user_location");
                                    markers={};
                                    chellan=0;
                                    limit=0;
                                    speed=0;
                                  });

                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(Icons.close,color:Colors.black54,size: 30,),
                                  ),
                                ),
                              ),
                            ],
                          ):SizedBox(),
                          SizedBox(height: (istart==true)?340:400,),
                          Column(
                            children: [
                              SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: (!istart==true)?MainAxisAlignment.center:MainAxisAlignment.end,
                                  children: [
                                    Container(

                                      child: Padding(
                                        padding: EdgeInsets.only(top:(istart==true)?250:0),
                                        child: Container(
                                          child: TextButton(
                                            onPressed: ()async{
                                              showDialog<String>(

                                                  context: context,

                                                  builder: (BuildContext context) {

                                                    TextEditingController email=new TextEditingController();


                                                    return AlertDialog(

                                                      title: Column(
                                                        children: [

                                                          Center(child: Text("There is an emergency")),

                                                          TextButton(onPressed: (){
                                                            bo(snapshot.data!.get("vehicle_number"), "emergency");
                                                          }, child: Text("Click it!",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold,fontSize: 20),))

                                                        ],
                                                      ),


                                                    );}
                                              );


                                            },
                                            onLongPress: ()async{
                                              bo(snapshot.data!.get("vehicle_number"), "emergency");
                                            },
                                            child: Column(
                                              children: [
                                                Container(

                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey.withOpacity(0.2),
                                                          spreadRadius: 5.0,
                                                          blurRadius: 5.0,
                                                          offset: Offset(0, 3), // changes the shadow position
                                                        ),
                                                      ],
                                                      shape: BoxShape.circle,
                                                      color: Colors.redAccent
                                                  ),
                                                  child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical:12,horizontal: 12),
                                                      child: RippleAnimation(

                                                          child: Icon(Icons.emergency,color: Colors.white,),
                                                        color: Colors.deepOrange,
                                                        delay: const Duration(milliseconds: 300),
                                                        repeat: true,
                                                        minRadius: 20,
                                                        ripplesCount: 5,
                                                        duration: const Duration(milliseconds: 6 * 300),
                                                      )),
                                                ),
                                                Text("emergency!",style: TextStyle(
                                                  color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 18
                                                ),)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      )

                    ],),




                  ],

                );


              }

            }
            return Center(
              child: CircularProgressIndicator(),
            );

          }
      ),
    );
  }
}
