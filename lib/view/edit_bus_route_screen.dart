import 'package:flutter/material.dart';

import '../utils/utils.dart';

class EditBusRouteScreen extends StatefulWidget {
  final int busRouteNumber;
  final String sourceLocationName;
  final String sourceLocationLatitude;
  final String sourceLocationLongitude;
  final String destinationLocationName;
  final String destinationLocationLatitude;
  final String destinationLocationLongitude;
  final Function(int, String, double, double, String, double, double)
      onItemSaved;

  const EditBusRouteScreen(
      {required this.busRouteNumber,
      required this.sourceLocationName,
      required this.sourceLocationLatitude,
      required this.sourceLocationLongitude,
      required this.destinationLocationName,
      required this.destinationLocationLatitude,
      required this.destinationLocationLongitude,
      required this.onItemSaved});

  @override
  _EditBusRouteScreenState createState() => _EditBusRouteScreenState();
}

class _EditBusRouteScreenState extends State<EditBusRouteScreen> {
  final _formKey = GlobalKey<FormState>();
  FocusNode routeNumberFocusNode = FocusNode();
  FocusNode sourceLocationNameFocusNode = FocusNode();
  FocusNode sourceLocationLatitudeNode = FocusNode();
  FocusNode sourceLocationLongitudeFocusNode = FocusNode();
  FocusNode destinationLocationNameFocusNode = FocusNode();
  FocusNode destinationLocationLatitudeFocusNode = FocusNode();
  FocusNode destinationLocationLongitudeFocusNode = FocusNode();

  late TextEditingController _busRouteNumberController;
  late TextEditingController _sourceLocationNameController;
  late TextEditingController _sourceLocationLatitudeController;
  late TextEditingController _sourceLocationLongitudeController;
  late TextEditingController _destinationLocationNameController;
  late TextEditingController _destinationLocationLatitudeController;
  late TextEditingController _destinationLocationLongitudeController;

  @override
  void initState() {
    super.initState();
    _busRouteNumberController =
        TextEditingController(text: widget.busRouteNumber.toString());
    _sourceLocationNameController =
        TextEditingController(text: widget.sourceLocationName);
    _sourceLocationLatitudeController =
        TextEditingController(text: widget.sourceLocationLatitude);
    _sourceLocationLongitudeController =
        TextEditingController(text: widget.sourceLocationLongitude);
    _destinationLocationNameController =
        TextEditingController(text: widget.destinationLocationName);
    _destinationLocationLatitudeController =
        TextEditingController(text: widget.destinationLocationLatitude);
    _destinationLocationLongitudeController =
        TextEditingController(text: widget.destinationLocationLongitude);
  }

  @override
  void dispose() {
    _busRouteNumberController.dispose();
    _sourceLocationNameController.dispose();
    _sourceLocationLatitudeController.dispose();
    _sourceLocationLongitudeController.dispose();
    _destinationLocationNameController.dispose();
    _destinationLocationLatitudeController.dispose();
    _destinationLocationLongitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("Bus Route information"),
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
                controller: _busRouteNumberController,
                focusNode: routeNumberFocusNode,
                decoration: const InputDecoration(
                  hintText: "Root Number",
                  label: Text("Root Number"),
                  // prefixIcon: Icon(Icons.person),
                ),
                onFieldSubmitted: (value) {
                  Utils.fieldFocusChange(context, routeNumberFocusNode,
                      sourceLocationNameFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter root number";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: _sourceLocationNameController,
                focusNode: sourceLocationNameFocusNode,
                decoration: const InputDecoration(
                  hintText: "Source Location",
                  label: Text("Source Location"),
                  // prefixIcon: Icon(Icons.person),
                ),
                onFieldSubmitted: (value) {
                  Utils.fieldFocusChange(context, sourceLocationNameFocusNode,
                      sourceLocationLongitudeFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter Source Location";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: _sourceLocationLongitudeController,
                focusNode: sourceLocationLongitudeFocusNode,
                decoration: const InputDecoration(
                  hintText: "Source Location Longitude",
                  label: Text("Source Location Longitude"),
                  // prefixIcon: Icon(Icons.person),
                ),
                onFieldSubmitted: (value) {
                  Utils.fieldFocusChange(
                      context,
                      sourceLocationLongitudeFocusNode,
                      sourceLocationLatitudeNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter Source Location Longitude";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: _sourceLocationLatitudeController,
                focusNode: sourceLocationLatitudeNode,
                decoration: const InputDecoration(
                  hintText: "Source Location Latitude",
                  label: Text("Source Location Latitude"),
                  // prefixIcon: Icon(Icons.person),
                ),
                onFieldSubmitted: (value) {
                  Utils.fieldFocusChange(context, sourceLocationLatitudeNode,
                      destinationLocationNameFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter Source Latitude";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: _destinationLocationNameController,
                focusNode: destinationLocationNameFocusNode,
                decoration: const InputDecoration(
                  hintText: "destination Location",
                  label: Text("destination Location"),
                  // prefixIcon: Icon(Icons.person),
                ),
                onFieldSubmitted: (value) {
                  Utils.fieldFocusChange(
                      context,
                      destinationLocationNameFocusNode,
                      destinationLocationLatitudeFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter destination Location";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: _destinationLocationLatitudeController,
                focusNode: destinationLocationLatitudeFocusNode,
                decoration: const InputDecoration(
                  hintText: "destination Location Latitude",
                  label: Text("destination Location Latitude"),
                  // prefixIcon: Icon(Icons.person),
                ),
                onFieldSubmitted: (value) {
                  Utils.fieldFocusChange(
                      context,
                      destinationLocationLatitudeFocusNode,
                      destinationLocationLongitudeFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter destination Location Latitude";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: _destinationLocationLongitudeController,
                focusNode: destinationLocationLongitudeFocusNode,
                decoration: const InputDecoration(
                  hintText: "destination Location Longitude",
                  label: Text("destination Location Longitude"),
                  // prefixIcon: Icon(Icons.person),
                ),
                onFieldSubmitted: (value) {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter destination Location Longitude";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Utils.flushBarErrorMessage(
                    //     "Successfully log in", context);
                    // signUp();
                    widget.onItemSaved(
                      int.parse(_busRouteNumberController.text.toString()),
                      _sourceLocationNameController.text.toString(),
                      double.parse(
                          _sourceLocationLongitudeController.text.toString()),
                      double.parse(
                          _sourceLocationLatitudeController.text.toString()),
                      _destinationLocationNameController.text.toString(),
                      double.parse(_destinationLocationLongitudeController.text
                          .toString()),
                      double.parse(_destinationLocationLatitudeController.text
                          .toString()),
                    );
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
