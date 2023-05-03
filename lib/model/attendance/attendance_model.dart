

import 'package:attendance_system/model/user/user_model.dart';

class AttendanceModel {
  int? id;
  String? title;
  String? body;
  UserModel? user;

  AttendanceModel({this.id, this.title, this.body, this.user});

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}