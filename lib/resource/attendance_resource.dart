import 'dart:convert';

import 'package:attendance_system/model/attendance/add_attendance_request_model.dart';
import 'package:attendance_system/model/attendance/attendance_list_response_model.dart';
import 'package:attendance_system/model/attendance/attendance_model.dart';
import 'package:attendance_system/model/attendance/attendance_response_model.dart';
import 'package:attendance_system/model/default_response_model.dart';
import 'package:attendance_system/services/resources.dart';

class AttendanceResource {
  // Call Logout API to revoke the token
  static Resource getAttendanceList() {
    return Resource(
        url: 'blog',
        parse: (response) {
          return AttendanceListResponseModel(json.decode(response.body));
        });
  }

  static Resource addNewAttendance(
      AddAttendanceRequestModel addAttendanceRequestModel) {
    return Resource(
        url: 'blog',
        data: addAttendanceRequestModel.toJson(),
        parse: (response) {
          return DefaultResponseModel(json.decode(response.body));
        });
  }

  static Resource showAttendance(
      AttendanceModel attendanceModel) {
    return Resource(
        url: 'blog/${attendanceModel.id}',
        data: attendanceModel.toJson(),
        parse: (response) {
          return AttendanceResponseModel(json.decode(response.body));
        });
  }


   static Resource deleteAttendance(
      AttendanceModel attendanceModel) {
    return Resource(
        url: 'blog/${attendanceModel.id}',
        data: attendanceModel.toJson(),
        parse: (response) {
          return DefaultResponseModel(json.decode(response.body));
        });
  }
}
