import 'package:attendance_system/bloc/attendance_bloc.dart';
import 'package:attendance_system/constant.dart';
import 'package:attendance_system/helpers/general_method.dart';
import 'package:attendance_system/model/attendance/attendance_list_response_model.dart';
import 'package:attendance_system/model/attendance/attendance_model.dart';
import 'package:attendance_system/public_components/input_decoration.dart';
import 'package:attendance_system/screens/view_attendance/view_attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';

class SearchPageScreen extends StatefulWidget {
  final List<AttendanceModel> attendanceModel;
  const SearchPageScreen({super.key, required this.attendanceModel});

  @override
  State<SearchPageScreen> createState() => _SearchPageScreenState();
}

class _SearchPageScreenState extends State<SearchPageScreen> {
  List<AttendanceModel> attendanceModelList = [];

  Future<AttendanceListResponseModel>? getAttendance() async {
    AttendanceBloc attendanceBloc = AttendanceBloc();

    void updateAttendanceList(AttendanceModel attendanceModel) {
      setState(() {
        attendanceModelList.add(attendanceModel);
      });
    }

    // for auto update
    setState(() {});
    try {
      return await attendanceBloc.getListAttendance();
    } catch (e) {
      print(e);
    }
    return AttendanceListResponseModel({'': ''});
  }

  void _onSearchTextChanged(String keyword) {
    setState(() {
      attendanceModelList = widget.attendanceModel.where((myAttendanceModel) {
        return myAttendanceModel.title!
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            myAttendanceModel.body!
                .toLowerCase()
                .contains(keyword.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAttendance();
    
    attendanceModelList = widget.attendanceModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhite,
        leading: BackButton(color: kPrimaryColor),
        elevation: 0,
        title: TextFormField(
          cursorColor: kPrimaryColor,
          onChanged: (value) {
            _onSearchTextChanged(value);
          },
          decoration: textFieldInputDecoration("", hintText: "Search..."),
          style: TextStyle(color: kBlack),
        ),
      ),
      body: FutureBuilder<AttendanceListResponseModel>(
          future: getAttendance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isSuccess) {
                List<AttendanceModel> attendance = snapshot.data!.data!;
                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: attendanceModelList.length,
                    itemBuilder: (context, index) {
                      return ScaleTap(
                        onPressed: () {
                          navigateTo(
                            context,
                            ViewAttendanceScreen(
                              attendanceModel: attendanceModelList[index],
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: kPrimaryColor, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                attendanceModelList[index].title!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 10),
                              Text(
                                attendanceModelList[index].body!,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text("Something went wrong."),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            }
          }),
    );
  }
}
