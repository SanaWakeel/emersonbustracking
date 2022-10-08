import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import '../utils/utils.dart';
import 'package:maps_curved_line/maps_curved_line.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Set<Polyline> _polylines = Set();

  final LatLng _point1 = const LatLng(12.947437, 77.681345);
  final LatLng _point2 = const LatLng(12.948767, 77.689120);

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

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();

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

    // Location location = Location();
    // await location.getLocation().then((location) {
    //   currentLocation = location;
    // });
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

  static const LatLng _center = LatLng(31.49470267942731, 74.31815207927605);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

//add your lat and lng where you wants to draw polyline
  final LatLng _lastMapPosition = _center;

  // List<LatLng> latlng2 = new List<LatLng>();
  final LatLng _new = const LatLng(31.49470267942731, 74.31815207927605);
  final LatLng _news = const LatLng(31.491377441157386, 74.23256111536254);

  final latlng = [
    const LatLng(31.49470267942731, 74.31815207927605),
    const LatLng(31.491377441157386, 74.23256111536254),
  ];

  //call this method on button click that will draw a polyline and markers

  void _onAddMarkerButtonPressed() {
    // getDistanceTime();
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        //_lastMapPosition is any coordinate which should be your default
        //position when map opens up
        position: _lastMapPosition,
        infoWindow: const InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      _polyline.add(Polyline(
        polylineId: PolylineId(_lastMapPosition.toString()),
        visible: true,
        //latlng is List<LatLng>
        points: latlng,
        color: Colors.blue,
      ));
    });
  }

  // latlng2.add(_new);
  // latlng.add(_news);

  @override
  void initState() {
    // TODO: implement initState
    // getCurrentLocation();
    // setCustomMarkerIcon();
    // getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _polylines.add(Polyline(
      polylineId: const PolylineId("line 1"),
      visible: true,
      width: 2,
      //latlng is List<LatLng>
      patterns: [PatternItem.dash(30), PatternItem.gap(10)],
      points: MapsCurvedLines.getPointsOnCurve(_point1, _point2),
      // Invoke lib to get curved line points
      color: Colors.blue,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track Bus",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: GoogleMap(
        //that needs a list<Polyline>
        polylines: _polylines,
        markers: _markers,
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
        // onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        // onCameraMove: _onCameraMove,
        initialCameraPosition: const CameraPosition(
            target: LatLng(12.947437, 77.681345), zoom: 13.5),

        mapType: MapType.normal,
      ),
    );
  }
}
