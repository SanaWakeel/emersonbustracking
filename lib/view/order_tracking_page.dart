import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import '../utils/utils.dart';

class BusTrackingView extends StatefulWidget {
  const BusTrackingView({Key? key}) : super(key: key);

  @override
  State<BusTrackingView> createState() => _BusTrackingViewState();
}

class _BusTrackingViewState extends State<BusTrackingView> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation =
      LatLng(31.49470267942731, 74.31815207927605); //lahore
  // LatLng(37.33500926,-122.03272188);
  static const LatLng destination =
      // LatLng(37.33429383,-122.06600055);
      LatLng(31.497036952477234, 74.30338689365222); //lahore
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon=BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon=BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon=BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocation = location;
    });
    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newlocation) {
      currentLocation = newlocation;
      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newlocation.latitude!,
                newlocation.longitude!,
              ))));
      setState(() {});
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Utils.google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    debugPrint("Api Response1: $result");
    if (result.points.isNotEmpty) {
      debugPrint("Api Response: $result");
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );

      setState(() {});
    }
  }

  void setCustomMarkerIcon(){
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "lib/res/images/bus_stop_pointer_128.png").then((icon){
      sourceIcon=icon;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "lib/res/images/Destination_pin_128.png").then((icon){
      destinationIcon=icon;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "lib/res/images/pin_128.png").then((icon){
      currentLocationIcon=icon;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();
    setCustomMarkerIcon();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Track Bus",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: currentLocation == null
          ? const Center(
              child: Text("Loading"),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  zoom: 13.5),
              // CameraPosition(target: sourceLocation, zoom: 13.5),
              polylines: {
                Polyline(
                    polylineId: PolylineId("route"),
                    points: polylineCoordinates,
                    color: Colors.blue,
                    width: 6),
              },
              markers: {
                Marker(
                  markerId: MarkerId("currentLocation"),
                  icon: currentLocationIcon,
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
                Marker(markerId: MarkerId("source"),
                    icon: sourceIcon,
                    position: sourceLocation),
                Marker(
                    markerId: MarkerId("destination"),
                    icon: destinationIcon,
                    position: destination),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
    );
  }
}
