import 'package:attendance_system/bloc/attendance_bloc.dart';
import 'package:attendance_system/constant.dart';
import 'package:attendance_system/model/attendance/add_attendance_request_model.dart';
import 'package:attendance_system/model/attendance/attendance_model.dart';
import 'package:attendance_system/model/default_response_model.dart';
import 'package:attendance_system/public_components/button_secondary.dart';
import 'package:attendance_system/public_components/input_decoration%20copy.dart';
import 'package:attendance_system/public_components/space.dart';
import 'package:flutter/material.dart';

class AddAttendanceScreen extends StatefulWidget {
  final Function(AttendanceModel)? attendanceModel;
  const AddAttendanceScreen({super.key, this.attendanceModel});

  @override
  State<AddAttendanceScreen> createState() => _AddAttendanceScreenState();
}

class _AddAttendanceScreenState extends State<AddAttendanceScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AttendanceBloc attendanceBloc = AttendanceBloc();
  AddAttendanceRequestModel addAttendanceRequestModel =
      AddAttendanceRequestModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(
          color: kPrimaryColor,
        ),
        title: const Text(
          "Add New Attendance",
          style: TextStyle(
            color: kPrimaryColor,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // dalam children  ade list of Widgets
                children: [
                  TextFormField(
                    cursorColor: kPrimaryColor,
                    onSaved: (newValue) {
                      addAttendanceRequestModel.title = newValue;
                    },
                    decoration: textFieldInputDecoration("Title",
                        hintText: "Title (required)"),
                  ),
                  Space(10),
                  TextFormField(
                    cursorColor: kPrimaryColor,
                    maxLines: 5,
                    onSaved: (newValue) {
                      addAttendanceRequestModel.body = newValue;
                    },
                    decoration: textFieldInputDecoration("",
                        hintText: "Description (required)"),
                  ),
                  Space(50),
                  ButtonSecondary(
                      onPressed: () {
                        if (validateAndSave()) {
                          addNewBlogProcess(addAttendanceRequestModel);
                        }
                      },
                      text: "Add New Attendance")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> addNewBlogProcess(
      AddAttendanceRequestModel addAttendanceRequestModel) async {
    DefaultResponseModel responseModel =
        await attendanceBloc.addNewAttendance(addAttendanceRequestModel);

    if (responseModel.isSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("add new attendance success"),
          ),
        );
        print("add new attendance success");

        Navigator.pop(context, responseModel.data);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseModel.message),
        ),
      );
    }
  }
}
