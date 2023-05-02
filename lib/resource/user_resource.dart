import 'dart:convert';

import 'package:attendance_system/model/default_response_model.dart';
import 'package:attendance_system/model/sign_in/sign_in_request_model.dart';
import 'package:attendance_system/model/sign_up/sign_up_request_model.dart';
import 'package:attendance_system/model/user/user_response_model.dart';
import 'package:attendance_system/services/resources.dart';

class UserResource {
  // post register

  static Resource register(SignUpRequestModel signUpRequestModel) {
    return Resource(
      url: 'register',
      data: signUpRequestModel.toJson(),
      parse: (response) {
        // return response model
        return DefaultResponseModel(
          json.decode(response.body),
        );
      },
    );
  }

  static Resource login(SignInRequestModel signInRequestModel) {
    return Resource(
      url: 'login',
      data: signInRequestModel.toJson(),
      parse: (response) {
        // return user response model
        return UserResponseModel(
          json.decode(response.body),
        );
      },
    );
  }

    static Resource logout() {
    return Resource(
      url: 'logout',
      parse: (response) {
        // return response model
        return DefaultResponseModel(
          json.decode(response.body),
        );
      },
    );
  }
}