// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, avoid_print, non_constant_identifier_names, annotate_overrides, prefer_const_constructors, sized_box_for_whitespace, empty_statements

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  ////variables
  var cl;
  var lat;
  var long;
  var kGooglePlex;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  var mymarkers = HashSet<Marker>();
  var mycircle = HashSet<Circle>();
  var elat;
  var elong;
  bool state = false; //state of earthquake which heppend or not
  var userid; //user id
  bool heroexist = false; //user id exists in hero collection or not
  var dlat; //disable latitude
  var dlong; //disable longtidue

  // _____________________________________________________________failed try________________________________________________________________
  // Widget updatemaps = Container(
  //   height: double.maxFinite,
  //   width: double.maxFinite,
  //   child: GoogleMap(
  //     mapType: MapType.normal,
  //     initialCameraPosition: CameraPosition(
  //       target: LatLng(29.4137128, 30.8656182),
  //       zoom: 18,
  //     ),
  //   ),
  // );

//_________________________________________________________________functions______________________________________________________________

//get location of the user (latitude, longtude )
  Future getlatlong() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    setState(() {
      lat = cl.latitude;
      long = cl.longitude;
      kGooglePlex = CameraPosition(
        target: LatLng(lat, long),
        zoom: 18,
      );
      // return cl;
    });
  }

  /// Determine the current position permission of the device. When the location services are not enabled or permissions are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    print(lat);
    print("__________________________________");
    print(long);
    print("__________________________________");
    return await Geolocator.getCurrentPosition();
  }

//listen function to get information about the earthquake
  listen() async {
    FirebaseFirestore.instance
        .collection('earthquake-B')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        // print("listen: ${element.data()}");
        state = element.data()['state'];
        print(state);
        print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTt");
        setState(() {});
        try {
          if (state == true) {
            elat = element.data()['lat'];
            elong = element.data()['long'];
            print(elat);
            print("++++++++++++++++++++++++++++++++++");
            print(elong);
            print("++++++++++++++++++++++++++++++++++");
          } else {
            elat = null;
            elong = null;
          }
        } catch (e) {
          print(e);
        }
      });
    });
    markeradd(state);
    markerremove(state);
  }

  //get user id fron firestore
  // get_user_id() async {
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     if (user != null) {
  //       userid = user.uid;
  //       print(user.uid);
  //       print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
  //     }
  //   });
  // }

// assurance about the user id exists in firestore's collection 'earthquake_B'
  // user_id_filter() async {
  //   DocumentReference ustate =
  //       FirebaseFirestore.instance.collection('earthquake-B').doc('hero');

  //   await ustate.get().then((value) => {
  //         (value.data() as Map<String, dynamic>)['userid'] == userid
  //             ? heroexist = true
  //             : heroexist = false
  //       });
  // }

  markeradd(newstate) async {
    setState(() {
      if (newstate == true) {
        //if recived lattitude no equal null then draw a circle and marker for the earthquake
        mymarkers.add(Marker(
          markerId: MarkerId("2"),
          position: LatLng(elat, elong),
          infoWindow: InfoWindow(title: " Earthquake"),
        ));
        mycircle.add(
          Circle(
            circleId: CircleId("2"),
            center: LatLng(elat, elong),
            radius: 4000,
            fillColor: Colors.red.withOpacity(0.3),
            strokeColor: Colors.red,
            strokeWidth: 2,
          ),
        );
      }
    });
  }

  markerremove(newstate) async {
    setState(() {
      if (newstate == false) {
        //if recived lattitude equal null then draw a circle and marker for the earthquake
        mymarkers.removeWhere((marker) => marker.markerId.value == "2");
        mycircle.removeWhere((circle) => circle.circleId.value == "2");
      }
    });
  }

  // void updategooglemapWidget(Widget newWidget) {
  //   setState(() {
  //     listen();
  //     updatemaps = newWidget;
  //   });
  // }

  String serverToken =
      'AAAAEIWYioc:APA91bFcw43QpM9NDylUGHJSS4PTdu4yCS-lN0NfGN2L1sslPkLcn3DkPizpzmQMfEAdz3W8nckIu9NBXOFq8iluu4urjXgdDH4CjHPOZ0sjrI8uAIfEUGt2-dGsr6uU7HI3ig-nnmis';
  sendnotify(String title, String body) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'please take a cover now',
            'title': 'Warning'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done'
          },
          'to': '/topics/earthquake',
        },
      ),
    );
  }

  // notification() {
  //   try {
  //     FirebaseMessaging.onMessage.listen((event) {
  //       Navigator.of(context).pushNamed("home");
  //       print('notyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy');
  //     });
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // notilisten() async {
  //   setState(() {
  //     if (state == true) {
  //       // var alert = sendnotify('aler', 'please cover your self');
  //       sendnotify('aler', 'please cover your self');
  //     } else {}
  //   });
  // }

  void initState() {
    super.initState();
    determinePosition();
    getlatlong();
    listen();
    // notilisten();
    // sendnotify('aler', 'please cover your self');
    // FirebaseMessaging.onMessage.listen((event) {
    //   Navigator.of(context).pushNamed("home");
    //   AwesomeDialog(
    //           context: context,
    //           title: "Warning!!",
    //           desc: "Warning!!",
    //           body: Column(
    //             children: const [
    //               Text('Warning!!'),
    //               Text("Earthquake was detected in fayoum")
    //             ],
    //           ),
    //           dialogType: DialogType.warning)
    //       .show();
    // });
    FirebaseMessaging.instance.getToken().then((value) => print(value));
    // get_user_id();
    // mymarkers.add(Marker(
    //   markerId: MarkerId("3"),
    //   position: LatLng(29.4137128, 30.8656182),
    //   infoWindow: InfoWindow(title: "My Marker"),
    // ));
  }

//_____________________________________________________________________________________________________________________

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         // // listen();
//         // int i = 1;
//         // while ( state == true || i == 2) {
//         //   sendnotify('aler', 'please cover your self');
//         //   i = i + 1;
//         //   break;
//         // }
//         updategooglemapWidget(Stack(children: [
//           Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: GoogleMap(
//             mapType: MapType.normal,
//             initialCameraPosition: kGooglePlex,
//             markers: mymarkers,
//             circles: mycircle,
//           ),
//         ),
//         Center(child: await sendnotify('alert', 'please cover your self'),)
//         ],));
//         // await notilisten();
//         // setState(() {});
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Earthquake Alert'),
//         ),
//         body: Center(
//           // child: updatemaps,
//           child: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: GoogleMap(
//             mapType: MapType.normal,
//             initialCameraPosition: kGooglePlex,
//             onMapCreated: (_controller) {
//               setState(() {
//                 mymarkers.add(Marker(markerId: MarkerId('1'),position: LatLng(lat, long)));
//               });
//             },
//             markers: mymarkers,
//             circles: mycircle,
//           ),
//         ),
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: Center(
        child: Stack(children: [
          kGooglePlex == null
              ? CircularProgressIndicator()
              : Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        setState(() {
                          listen();
                          mymarkers.add(Marker(
                              markerId: MarkerId("1"),
                              position: LatLng(lat, long)));
                          // if (elat != null) {
                          //   //if recived lattitude no equal null then draw a circle and marker for the earthquake
                          //   mymarkers.add(Marker(
                          //       markerId: MarkerId("2"),
                          //       position: LatLng(elat, elong)));
                          //   mycircle.add(
                          //     Circle(
                          //       circleId: CircleId("2"),
                          //       center: LatLng(elat, elong),
                          //       radius: 4000,
                          //       fillColor: Colors.red.withOpacity(0.3),
                          //       strokeColor: Colors.red,
                          //       strokeWidth: 2,
                          //     ),
                          //   );
                          // }
                          ;
                          // try {
                          //   if (heroexist = true) {
                          //     mymarkers.add(Marker(
                          //         markerId: MarkerId("3"),
                          //         position: LatLng(dlat, dlong)));
                          //   } else {}
                          //   ;
                          // } catch (e) {
                          //   print(e);
                          // }
                        });
                      },
                      markers: mymarkers,
                      circles: mycircle,
                    ),
                  ),
                ),
          Center(
            child: state == false
                ? null
                : GestureDetector(
                    onLongPress: () {
                      AwesomeDialog(
                              context: context,
                              title: "Warning!!",
                              desc: "Warning!!",
                              body: Column(
                                children: const [
                                  Text('Warning!!'),
                                  Text("Earthquake was detected in fayoum")
                                ],
                              ),
                              dialogType: DialogType.warning)
                          .show();
                      markeradd(state);
                      markerremove(state);
                      sendnotify('alert', 'please take a cover now');
                    },
                    // child: Text("Show Awesome Dialog"),
                  ),
          )
        ]),
      ),
    );
  }
}
