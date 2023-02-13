class SignUpModel {
  String? firstName, lastName, id, email, deviceToken, registrationNo;
  int? role, age, timeStamp;

  SignUpModel(
      {this.firstName,
      this.lastName,
      this.registrationNo,
      this.id,
      this.email,
      this.deviceToken,
      this.role,
      this.age,
      this.timeStamp});

  // SignUpModel.fromJson(Map json)
  SignUpModel.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        registrationNo = json['registrationNo'],
        id = json['id'],
        email = json['email'],
        deviceToken = json['deviceToken'],
        role = json['role'],
        age = json['age'],
        timeStamp = json['timeStamp'];

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'registrationNo': registrationNo,
        'id': id,
        'email': email,
        'deviceToken': deviceToken,
        'role': role,
        'age': age,
        'timeStamp': timeStamp,
      };
}
