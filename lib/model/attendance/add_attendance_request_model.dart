class AddAttendanceRequestModel {
  String? title;
  String? body;

  AddAttendanceRequestModel({this.title, this.body});

  AddAttendanceRequestModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}