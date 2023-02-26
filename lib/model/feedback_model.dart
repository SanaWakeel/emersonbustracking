class FeedbackModel {
  String? feedback, id, registrationNo;
  int? timeStamp;

  FeedbackModel({this.feedback, this.registrationNo, this.id, this.timeStamp});

  // SignUpModel.fromJson(Map json)
  FeedbackModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        feedback = json['feedback'],
        registrationNo = json['registrationNo'],
        timeStamp = json['timeStamp'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'feedback': feedback,
        'registrationNo': registrationNo,
        'timeStamp': timeStamp,
      };
}
