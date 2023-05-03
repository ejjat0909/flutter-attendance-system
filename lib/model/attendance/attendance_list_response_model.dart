import 'package:attendance_system/helpers/base_api_response.dart';
import 'package:attendance_system/model/attendance/attendance_model.dart';


class AttendanceListResponseModel
    extends BaseAPIResponse<List<AttendanceModel>, Null> {
  AttendanceListResponseModel(fullJson) : super(fullJson);

  @override
  dataToJson(List<AttendanceModel>? data) {
    if (this.data != null) {
      return this.data?.map((v) => v.toJson()).toList();
    }
    return null;
  }

  @override
  errorsToJson(Null errors) {
    return null;
  }

  @override
  List<AttendanceModel>? jsonToData(Map<String, dynamic>? json) {
    if (json != null) {
      data = [];

      json["data"].forEach((v) {
        data!.add(AttendanceModel.fromJson(v));
      });

      return data!;
    }

    return null;
  }

  @override
  Null jsonToError(Map<String, dynamic> json) {
    return null;
  }
}