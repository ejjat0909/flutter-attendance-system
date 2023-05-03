import 'package:attendance_system/bloc/attendance_bloc.dart';
import 'package:attendance_system/bloc/user_bloc.dart';
import 'package:attendance_system/constant.dart';
import 'package:attendance_system/model/attendance/attendance_list_response_model.dart';
import 'package:attendance_system/model/attendance/attendance_model.dart';
import 'package:attendance_system/model/default_response_model.dart';
import 'package:attendance_system/model/user/user_model.dart';
import 'package:attendance_system/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePageScreen extends StatefulWidget {
  final UserModel userModel;
  const HomePageScreen({super.key, required this.userModel});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<AttendanceModel> listAttendance = [];

  void updateAttendanceList(AttendanceModel attendanceModel) {
    setState(() {
      listAttendance.add(attendanceModel);
    });
  }

  Future<AttendanceListResponseModel>? getAttendance() async {
    AttendanceBloc attendanceBloc = AttendanceBloc();
    // for auto update
    setState(() {});
    try {
      return await attendanceBloc.getListAttendance();
    } catch (e) {
      print(e);
    }
    return AttendanceListResponseModel({'': ''});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(color: Colors.transparent),
          actions: [
            IconButton(
                onPressed: () async {
                  UserBloc userBloc = UserBloc();
                  DefaultResponseModel responseModel = await userBloc.logout();

                  if (responseModel.isSuccess) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Logged out"),
                        ),
                      );
                      print("Logged out");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => SignInScreen()),
                          ),
                          (Route<dynamic> route) => false);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(responseModel.message),
                      ),
                    );
                    print("cannot Log out");
                  }
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ))
          ],
          title: Text(
            "Hi ${widget.userModel.name}",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<AttendanceListResponseModel>(
          future: getAttendance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isSuccess) {
                List<AttendanceModel> blogs = snapshot.data!.data!;
                return ListView.builder(
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: blogs.length,
                    itemBuilder: (context, index) {
                      AttendanceModel blogModel = blogs[index];
                      return Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: kPrimaryColor, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  blogModel.user!.name!,
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              blogModel.title!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10),
                            Text(
                              blogModel.body!,
                              textAlign: TextAlign.justify,
                            )
                          ],
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: Text("Something went wrong."),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            // Perform action when button is pressed
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => AddNewBlogPage()),
            // ).then((value) {
            //   getBlogs(); // Reload the data after adding a new item
            // });
          },
        ),
      ),
    );
  }
}
