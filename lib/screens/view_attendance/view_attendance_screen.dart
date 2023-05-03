import 'package:attendance_system/bloc/attendance_bloc.dart';
import 'package:attendance_system/constant.dart';
import 'package:attendance_system/model/attendance/attendance_model.dart';
import 'package:attendance_system/model/default_response_model.dart';
import 'package:attendance_system/public_components/space.dart';
import 'package:attendance_system/public_components/theme_app_bar%20copy.dart';
import 'package:attendance_system/public_components/theme_snack_bar%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:iconsax/iconsax.dart';

class ViewAttendanceScreen extends StatefulWidget {
  final AttendanceModel attendanceModel;
  const ViewAttendanceScreen({super.key, required this.attendanceModel});

  @override
  State<ViewAttendanceScreen> createState() => _ViewAttendanceScreenState();
}

class _ViewAttendanceScreenState extends State<ViewAttendanceScreen> {
  AttendanceBloc attendanceBloc = AttendanceBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemeAppBar(
        "View Attendance",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: kPrimaryColor, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Attendance by ",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        Text(
                          widget.attendanceModel.user!.name!,
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Text(
                      widget.attendanceModel.title!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Space(20),
                    Text(
                      widget.attendanceModel.body!,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Space(10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: ScaleTap(
          onPressed: () {
            deleteAttendance(widget.attendanceModel);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Iconsax.trash4,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Delete Attendance",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteAttendance(AttendanceModel attendanceModel) async {
    DefaultResponseModel responseModel =
        await attendanceBloc.deleteAttendance(attendanceModel);

    if (responseModel.isSuccess) {
      if (mounted) {
        ThemeSnackBar.showSnackBar(context, "Successfully Delete Attendance");
        Navigator.pop(context, responseModel.data);
      }
    } else {
      if (mounted) {
        ThemeSnackBar.showSnackBar(context, responseModel.message);
      }
    }
  }
}
