import 'package:attendance_system/bloc/user_bloc.dart';
import 'package:attendance_system/constant.dart';
import 'package:attendance_system/helpers/general_method.dart';
import 'package:attendance_system/model/sign_in/sign_in_request_model.dart';
import 'package:attendance_system/model/user/user_response_model.dart';
import 'package:attendance_system/public_components/button_primary.dart';
import 'package:attendance_system/public_components/input_decoration.dart';
import 'package:attendance_system/public_components/space.dart';
import 'package:attendance_system/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax/iconsax.dart';
import 'package:attendance_system/screens/home_page/home_page_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserBloc loginBloc = UserBloc();
  SignInRequestModel signInRequestModel = SignInRequestModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                mainAxisAlignment: MainAxisAlignment.center,
                // dalam children  ade list of Widgets
                children: [
                  const Text(
                    "MyAttendance",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Manage Your Attendance",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Space(30),
                  TextFormField(
                    cursorColor: kPrimaryColor,
                    onSaved: (newValue) {
                      signInRequestModel.email = newValue;
                    },
                    decoration: textFieldInputDecoration(
                      "Email",
                      hintText: "Ex: something@vimigo.com",
                      prefixIcon: Icon(
                        Iconsax.sms,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  Space(10),
                  TextFormField(
                    obscureText: true,
                    cursorColor: kPrimaryColor,
                    onSaved: (newValue) {
                      signInRequestModel.password = newValue;
                    },
                    decoration: textFieldInputDecoration(
                      "Password",
                      hintText: "",
                      prefixIcon: Icon(
                        Iconsax.lock,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  Space(30),
                  ButtonPrimary(
                    "Login",
                    onPressed: () {
                      if (validateAndSave()) {
                        loginProcess(signInRequestModel);
                      }
                      // navigate to home page
                    },
                  ),
                  Space(10),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Dont have any account? ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            // text recognzier rich text flutter
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // navigation
                                navigateTo(
                                  context,
                                  SignUpScreen(),
                                );
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const RegisterPage(),
                                //   ),
                                // );
                                print('Sign Up Page');
                              }),
                      ],
                    ),
                  )
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

  Future<void> loginProcess(SignInRequestModel signInRequestModel) async {
    UserResponseModel responseModel = await loginBloc.login(signInRequestModel);

    if (responseModel.isSuccess) {
      // untuk set access token
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("access_token", responseModel.data!.accessToken!);

      // what to do when success?
      if (mounted) {
        print("login");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageScreen(userModel: responseModel.data!),
          ),
        );
      }
    } else {
      // not successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseModel.message),
        ),
      );
    }
  }
}
