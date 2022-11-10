import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isTrackingStart = false;

  double lat = 0;
  double lng = 0;

  late GoogleMapController googleMapController;

  void onMapCreated(GoogleMapController controller) async {
    googleMapController = controller;


    await googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(lat, lng),
          zoom: 5.0,
        ),
      ),
    );
  }

  getCurrentPosition() async {
    await Permission.location.request();

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      lat = position.latitude;
      lng = position.longitude;


      print("lat ------   $lat");
      print("lng ------   $lng");
    });

    await googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(lat, lng),
          zoom: 5.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Location"),
        centerTitle: true,
        elevation: 0,
        actions: [
          (isTrackingStart)
              ? IconButton(
            onPressed: () {
              setState(() {
                isTrackingStart = false;
              });
            },
            icon: const Icon(Icons.pause),
          )
              : IconButton(
            onPressed: () {
              setState(() {
                isTrackingStart = true;
              });
            },
            icon: Icon(Icons.play_arrow),
          ),
        ],
      ),
      body: GoogleMap(
        myLocationEnabled: isTrackingStart,
        mapType: MapType.satellite,
        onMapCreated: onMapCreated,

        initialCameraPosition: CameraPosition(
            target: LatLng(lat, lng), zoom: 11.0, tilt: 0, bearing: 0),
        // markers: {
        // Marker(
        //   markerId: MarkerId("marker_2"),
        //   position: LatLng(lat,lng),
        // ),
        // },
      ),
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //   getCurrentPosition();
      // },child: const Icon(Icons.location_searching),),
    );
  }
}
