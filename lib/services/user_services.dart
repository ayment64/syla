import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:syla/models/user_model.dart';
import 'package:syla/shared/Interceptors/jwt_inerceptor.dart';
import 'package:syla/shared/contents/url_constants.dart';

import 'auth_services.dart';

class UserServices {
  Dio dio = Api().dio;
  Future<User> refreshUser() async {
    var url = '${dotenv.env['BACKEND_BASE_URL']}/$fetchUser';
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        return User.fromJson(response.data["data"]["data"]["user"]);
      }
      return User();
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          return User();
        } else {}
        return User();
      } else {
        return User();
      }
    }
  }

  Future<dynamic> updateUser(User user) async {
    var url = '${dotenv.env['BACKEND_BASE_URL']}/$updateUserUrl';

    try {
      final response = await dio.post(url, data: user.toJson());
      setUser(user: json.encode(response.data["data"]));
      if (response.statusCode == 200) {
        return "user updated successfully";
      }
      return "something went wrong";
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          return e.response!.data['message'] ?? "Something went wrong";
        }
        return e.response!.data['message'] ?? "Something went wrong";
      } else {
        // Handle other types of errors
        return e.toString();
      }
    }
  }

  Future<ServiceResponse> sendForgotPasswordMessage(String phoneNumber) async {
    String url = "${dotenv.env['BACKEND_BASE_URL']}/$forgotPasswordUrl";
    try {
      final response = await dio.post(url, data: {"phoneNumber": phoneNumber});
      if (response.data["data"]) {
        setUser(user: json.encode(response.data["data"]));
      }
      if (response.statusCode == 200) {
        return ServiceResponse(
            success: true, message: "Profile Updated successfully");
      }
      return ServiceResponse(success: false, message: "Something went wrong");
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          return ServiceResponse(
              success: false,
              message: e.response!.data['message'] ?? "Something went wrong");
        }
        return ServiceResponse(
            success: false,
            message: e.response!.data['message'] ?? "Something went wrong");
      } else {
        // Handle other types of errors
        return ServiceResponse(success: true, message: e.toString());
      }
    }
  }

  Future<ServiceResponse> changePassword(
    String oldPassword,
    String password,
    String confirmPassword,
  ) async {
    String url = "${dotenv.env['BACKEND_BASE_URL']}/$updatePasseord";
    try {
      final response = await dio.post(url, data: {
        "oldPassword": oldPassword,
        "newPassword": password,
        "confirmPassword": confirmPassword
      });
      if (response.statusCode == 200) {
        return ServiceResponse(success: true, message: "success");
      }
      return ServiceResponse(success: false, message: "Something went wrong");
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          return ServiceResponse(
              success: false,
              message: e.response!.data['message'] ?? "Something went wrong");
        }
        return ServiceResponse(
            success: false,
            message: e.response!.data['message'] ?? "Something went wrong");
      } else {
        // Handle other types of errors
        return ServiceResponse(success: true, message: e.toString());
      }
    }
  }
}
