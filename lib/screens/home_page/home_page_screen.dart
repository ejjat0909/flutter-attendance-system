import 'package:attendance_system/bloc/attendance_bloc.dart';
import 'package:attendance_system/bloc/user_bloc.dart';
import 'package:attendance_system/constant.dart';
import 'package:attendance_system/helpers/general_method.dart';
import 'package:attendance_system/model/attendance/attendance_list_response_model.dart';
import 'package:attendance_system/model/attendance/attendance_model.dart';
import 'package:attendance_system/model/default_response_model.dart';
import 'package:attendance_system/model/user/user_model.dart';
import 'package:attendance_system/public_components/space.dart';
import 'package:attendance_system/public_components/theme_snack_bar%20copy.dart';
import 'package:attendance_system/screens/add_attendance/add_attendance_screen.dart';
import 'package:attendance_system/screens/search_page/search_page_screen.dart';
import 'package:attendance_system/screens/sign_in/sign_in_screen.dart';
import 'package:attendance_system/screens/view_attendance/view_attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:attendance_system/public_components/space.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class HomePageScreen extends StatefulWidget {
  final UserModel userModel;
  const HomePageScreen({super.key, required this.userModel});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<AttendanceModel> listAttendance = [];
  String formattedTime = "1 second ago";
  DateTime dateTime = DateTime.now();
  bool isSwitchedOn = true;

  void updateAttendanceList(AttendanceModel attendanceModel) {
    setState(() {
      listAttendance.add(attendanceModel);
    });
  }

  void loadData() async {
    AttendanceListResponseModel? response = await getAttendance();
    if (response != null && response.isSuccess) {
      setState(() {
        listAttendance = response.data!;
      });
    }
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

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAttendance();
    loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    //use minScrollExtent because reverse:true in listview
    if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      ThemeSnackBar.showSnackBar(
          context, "You have reached the end of the list");
      print("end scroll");
    }
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
              onPressed: () {
                navigateTo(
                  context,
                  SearchPageScreen(
                    attendanceModel: listAttendance,
                  ),
                );
              },
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
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
                color: Colors.red,
              ),
            ),
          ],
          title: Text(
            "Hi ${widget.userModel.name}",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              children: [
                Switch(
                  // This bool value toggles the switch.
                  value: isSwitchedOn,
                  activeColor: kPrimaryColor,
                  onChanged: (bool value) {
                    // This is called when the user toggles the switch.
                    setState(() {
                      isSwitchedOn = value;
                    });
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Switch on/off the toggle to change the time format",
                  style: TextStyle(
                    color: isSwitchedOn ? kPrimaryColor : kGrey,
                    fontSize: 12,
                  ),
                )
              ],
            ),
            Expanded(
              child: FutureBuilder<AttendanceListResponseModel>(
                future: getAttendance(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isSuccess) {
                      List<AttendanceModel> attendance = snapshot.data!.data!;
                      return ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: attendance.length,
                          itemBuilder: (context, index) {
                            AttendanceModel attendanceModel = attendance[index];
                            return ScaleTap(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewAttendanceScreen(
                                            attendanceModel: attendanceModel,
                                          )),
                                ).then((value) {
                                  getAttendance(); // Reload the data after adding a new item
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: kPrimaryColor, width: 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          attendanceModel.user!.name!,
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        ScaleTap(
                                          onPressed: () {
                                            showBottomSheet(context);
                                          },
                                          child: Icon(
                                            Iconsax.menu,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      attendanceModel.title!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      attendanceModel.body!,
                                      textAlign: TextAlign.justify,
                                    ),
                                    Space(10),
                                    Text(
                                      isSwitchedOn
                                          ? "1 second ago"
                                          : DateFormat('dd MMM yyyy, h:mm a')
                                              .format(dateTime),
                                      style: const TextStyle(
                                        color: kGrey,
                                        fontSize: 10,
                                      ),
                                    )
                                  ],
                                ),
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
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            // Perform action when button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddAttendanceScreen()),
            ).then((value) {
              getAttendance(); // Reload the data after adding a new item
            });
          },
        ),
      ),
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 75,
          padding: EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  ThemeSnackBar.showSnackBar(context, "Link Attendance Copied");
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  //  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Iconsax.share,
                        color: kPrimaryColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Share Attendance"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
