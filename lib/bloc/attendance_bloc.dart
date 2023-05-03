import 'package:attendance_system/model/attendance/add_attendance_request_model.dart';
import 'package:attendance_system/model/attendance/attendance_list_response_model.dart';
import 'package:attendance_system/model/attendance/attendance_model.dart';
import 'package:attendance_system/model/attendance/attendance_response_model.dart';
import 'package:attendance_system/model/default_response_model.dart';
import 'package:attendance_system/services/web_services.dart';
import 'package:attendance_system/resource/attendance_resource.dart';

class AttendanceBloc {
  Future<AttendanceListResponseModel> getListAttendance() async {
    return await Webservice.get(AttendanceResource.getAttendanceList());
  }

  Future<DefaultResponseModel> addNewAttendance(
      AddAttendanceRequestModel addAttendanceRequestModel) async {
    return await Webservice.post(
        AttendanceResource.addNewAttendance(addAttendanceRequestModel));
  }

  Future<AttendanceResponseModel> showAttendance(
      AttendanceModel attendanceModel) async {
    return await Webservice.get(
        AttendanceResource.showAttendance(attendanceModel));
  }

   Future<DefaultResponseModel> deleteAttendance(
      AttendanceModel attendanceModel) async {
    return await Webservice.delete(
        AttendanceResource.deleteAttendance(attendanceModel));
  }
}
