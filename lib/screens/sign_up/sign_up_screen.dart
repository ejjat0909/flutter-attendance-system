import 'package:attendance_system/bloc/user_bloc.dart';
import 'package:attendance_system/constant.dart';
import 'package:attendance_system/model/default_response_model.dart';
import 'package:attendance_system/model/sign_up/sign_up_request_model.dart';
import 'package:attendance_system/public_components/button_primary.dart';
import 'package:attendance_system/public_components/space.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:attendance_system/public_components/input_decoration.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpController = TextEditingController();
  UserBloc registerBloc = UserBloc();
  SignUpRequestModel registerRequestModel = SignUpRequestModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(
          color: kPrimaryColor,
        ),
        title: Text(
          "Registration",
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
                      registerRequestModel.name = newValue;
                    },
                    decoration: textFieldInputDecoration(
                      "Name",
                      hintText: "Ex: Vimigo",
                      prefixIcon: Icon(
                        Iconsax.profile_2user,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  Space(10),
                  TextFormField(
                    cursorColor: kPrimaryColor,
                    onSaved: (newValue) {
                      registerRequestModel.email = newValue;
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
                    cursorColor: kPrimaryColor,
                    obscureText: true,
                    onSaved: (newValue) {
                      registerRequestModel.password = newValue;
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
                  Space(10),
                  TextFormField(
                    cursorColor: kPrimaryColor,
                    obscureText: true,
                    onSaved: (newValue) {
                      registerRequestModel.passwordConfirmation = newValue;
                    },
                    decoration: textFieldInputDecoration(
                      "Confirm Password",
                      hintText: "",
                      prefixIcon: Icon(
                        Iconsax.lock,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  Space(10),
                  ButtonPrimary(
                    "Sign Up",
                    onPressed: () {
                      if (validateAndSave()) {
                        registerProcess(registerRequestModel);
                      }
                    },
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

  Future<void> registerProcess(SignUpRequestModel registerRequestModel) async {
    DefaultResponseModel responseModel =
        await registerBloc.register(registerRequestModel);

    if (responseModel.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("register success"),
        ),
      );
      print("register success");
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseModel.message),
        ),
      );
    }
  }
}
