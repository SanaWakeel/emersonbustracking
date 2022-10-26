import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:maps_curved_line/maps_curved_line.dart';
import '../utils/utils.dart';
import 'package:emersonbustracking/res/colors.dart';
// import 'package:geocoding/geocoding.dart';

// List<Location> locations =
//     await locationFromAddress("Gronausestraat 710, Enschede");

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
      // LatLng(31.497036952477234, 74.30338689365222); //lahore
      LatLng(31.491377441157386, 74.23256111536254); //lahore
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  // getFullAddress(destination);

  // void getFullAddress(location) async {
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(location.latitude, location.longitude);
  //
  //   var first = placemarks.first;
  //   print(
  //       ' ${first.locality}, ${first.administrativeArea},${first.subLocality}, ${first.subAdministrativeArea},${first.name}, ${first.thoroughfare}, ${first.subThoroughfare}');
  //   // return first;
  // }

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();
    Location location2 = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    currentLocation = await location.getLocation();
    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newlocation) {
      currentLocation = newlocation;
      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              zoom: 11.5,
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
      Utils.googleApiKey,
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

  final Set<Polyline> _polylines = Set();

  void drawCurvedLineOnMap() async {
    final LatLng sourcePoint =
        LatLng(sourceLocation.latitude, sourceLocation.longitude);
    final LatLng destinationPoint =
        LatLng(destination.latitude, destination.longitude);
    _polylines.add(Polyline(
      polylineId: const PolylineId("line 1"),
      visible: true,
      width: 2,
      //latlng is List<LatLng>
      patterns: [PatternItem.dash(30), PatternItem.gap(10)],
      points: MapsCurvedLines.getPointsOnCurve(sourcePoint, destinationPoint),
      // Invoke lib to get curved line points
      color: Colors.blue,
    ));
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "lib/res/images/bus_stop_pointer_128.png")
        .then((icon) {
      sourceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "lib/res/images/Destination_pin_128.png")
        .then((icon) {
      destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "lib/res/images/pin_128.png")
        .then((icon) {
      currentLocationIcon = icon;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // getCurrentLocation();
    setCustomMarkerIcon();
    // getPolyPoints();
    drawCurvedLineOnMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track Bus",
          style: TextStyle(color: AppColors.white, fontSize: 16),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(sourceLocation.latitude, sourceLocation.longitude),
            zoom: 11.5),
        // CameraPosition(target: sourceLocation, zoom: 13.5),
        polylines: _polylines,
        // polylines: {
        //   Polyline(
        //       polylineId: PolylineId("route"),
        //       points: polylineCoordinates,
        //       color: Colors.blue,
        //       width: 6),
        // },
        markers: {
          // Marker(
          //   markerId: const MarkerId("currentLocation"),
          //   icon: currentLocationIcon,
          //   position:
          //       LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          // ),
          Marker(
            markerId: const MarkerId("source"),
            icon: sourceIcon,
            position: sourceLocation,
            infoWindow: InfoWindow(
              //popup info
              title: 'source location ',
              snippet: 'My Custom Subtitle',
            ),
          ),
          Marker(
            markerId: const MarkerId("destination"),
            icon: destinationIcon,
            position: destination,
            infoWindow: InfoWindow(
              //popup info
              title: 'destination location ',
              snippet: 'My Custom Subtitle',
            ),
          ),
        },
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
      ),
    );
  }
}
