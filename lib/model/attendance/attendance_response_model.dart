import 'package:attendance_system/helpers/base_api_response.dart';
import 'package:attendance_system/model/attendance/attendance_model.dart';


class AttendanceResponseModel extends BaseAPIResponse<AttendanceModel, Null> {
  AttendanceResponseModel(fullJson) : super(fullJson);

  @override
  dataToJson(AttendanceModel? data) {
    if (this.data != null) {
      return this.data!.toJson();
    }
    return null;
  }

  @override
  errorsToJson(Null errors) {
    return null;
  }

  @override
  AttendanceModel? jsonToData(Map<String, dynamic>? json) {
    return json!["data"] != null ? AttendanceModel.fromJson(json["data"]) : null;
  }

  @override
  Null jsonToError(Map<String, dynamic> json) {
    return null;
  }
}