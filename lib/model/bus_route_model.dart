class BusRouteModel {
  String? id, sourceLocationName, destinationLocationName;
  double? sourceLocationLongitude,
      destinationLocationLongitude,
      destinationLocationLatitude,
      sourceLocationLatitude;
  int? timeStamp, busRouteNumber;

  BusRouteModel(
      {this.id,
      this.busRouteNumber,
      this.sourceLocationName,
      this.destinationLocationName,
      this.sourceLocationLongitude,
      this.destinationLocationLongitude,
      this.destinationLocationLatitude,
      this.sourceLocationLatitude,
      this.timeStamp});

  // SignUpModel.fromJson(Map json)
  BusRouteModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        busRouteNumber = json['busRouteNumber'],
        sourceLocationName = json['sourceLocationName'],
        sourceLocationLatitude = json['sourceLocationLatitude'],
        sourceLocationLongitude = json['sourceLocationLongitude'],
        destinationLocationName = json['destinationLocationName'],
        destinationLocationLatitude = json['destinationLocationLatitude'],
        destinationLocationLongitude = json['destinationLocationLongitude'],
        timeStamp = json['timeStamp'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'busRouteNumber': busRouteNumber,
        'sourceLocationName': sourceLocationName,
        'sourceLocationLatitude': sourceLocationLatitude,
        'sourceLocationLongitude': sourceLocationLongitude,
        'destinationLocationName': destinationLocationName,
        'destinationLocationLatitude': destinationLocationLatitude,
        'destinationLocationLongitude': destinationLocationLongitude,
        'timeStamp': timeStamp,
      };
}
