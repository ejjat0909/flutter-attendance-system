import 'package:attendance_system/model/default_response_model.dart';
import 'package:attendance_system/model/sign_in/sign_in_request_model.dart';
import 'package:attendance_system/model/sign_up/sign_up_request_model.dart';
import 'package:attendance_system/model/user/user_response_model.dart';
import 'package:attendance_system/resource/user_resource.dart';
import 'package:attendance_system/services/web_services.dart';

class UserBloc {
  // register
  Future<DefaultResponseModel> register(
      SignUpRequestModel signUpRequestModel) async {
    return await Webservice.post(UserResource.register(signUpRequestModel));
  }

// login
  Future<UserResponseModel> login(SignInRequestModel signInRequestModel) async {
    return await Webservice.post(UserResource.login(signInRequestModel));
  }

// logout
  Future<DefaultResponseModel> logout() async {
    return await Webservice.get(UserResource.logout());
  }
}