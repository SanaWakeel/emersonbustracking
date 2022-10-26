class SignUpModel {
  String? firstName, lastName, id, email, deviceToken;
  int? role, age, timeStamp;

  SignUpModel(
      {this.firstName,
      this.lastName,
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
        id = json['id'],
        email = json['email'],
        deviceToken = json['deviceToken'],
        role = json['role'],
        age = json['age'],
        timeStamp = json['timeStamp'];

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'id': id,
        'email': email,
        'deviceToken': deviceToken,
        'role': role,
        'age': age,
        'timeStamp': timeStamp,
      };
}
