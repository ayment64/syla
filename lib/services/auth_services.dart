import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:syla/controller/authentication_controller/register_controller.dart';
import 'package:syla/shared/Interceptors/jwt_inerceptor.dart';
import '../shared/Contents/url_constants.dart';

class AuthServices {
  var dio = Dio();
  Future<LoginResponse> login(String email, String password) async {
    var url = '${dotenv.env['BACKEND_BASE_URL']}/$loginUrl';
    try {
      final response = await dio.post(
        url,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        setToken(
            token: response.data["data"]['access_token'],
            refreshToken: response.data["data"]['refresh_token']);
        setUser(user: json.encode(response.data["data"]['user']));
        return LoginResponse(
            success: true,
            message: "sccess",
            verified: response.data["data"]['user']['verified']);
      }
      return LoginResponse(
          success: false, verified: false, message: "Something went Wrong");
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          return LoginResponse(
              success: false,
              message: e.response!.data['message'] ?? "Something went wrong");
        } else {}
        return LoginResponse(
            success: false,
            message: e.response!.data['message'] ?? "Something went wrong");
      } else {
        return LoginResponse(success: true, message: e.toString());
      }
    }
  }

  Future<ServiceResponse> registerUser(RegistrationScheme user) async {
    var url = '${dotenv.env['BACKEND_BASE_URL']}/$registerUrl';
    try {
      final response = await dio.post(
        url,
        data: {
          'email': user.email,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'phoneNumber': user.phoneNumber,
          'password': user.password,
          'gender': "male"
        },
      );
      if (kDebugMode) {
        print(response);
        print(response.data);
      }
      if (response.statusCode == 200) {
        setToken(
            token: response.data["data"]['access_token'],
            refreshToken: response.data["data"]['refresh_token']);
        setUser(user: json.encode(response.data["data"]['user']));
        return ServiceResponse(message: "Success", success: true);
      }
      return ServiceResponse(success: false, message: "Something went Wrong");
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

  Future<bool> sendVerificatioSMSService(String phoneNumber) async {
    var url = '${dotenv.env['BACKEND_BASE_URL']}/$sendVerificationSMS';

    try {
      final response = await Api().dio.post(
        url,
        data: {
          'phoneNumber': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return false;
    }
  }

  Future<ServiceResponse> forgotPassword(String phoneNumber) async {
    var url = '${dotenv.env['BACKEND_BASE_URL']}/$forgotPasswordUrl';
    try {
      final response = await Dio().post(url, data: {
        "phoneNumber": phoneNumber,
      });
      if (response.statusCode == 200) {
        return ServiceResponse(message: "Success", success: true);
      }
      return ServiceResponse(message: "Something went wrong", success: false);
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

  Future<bool> sendVerificationCode(String verificationCode) async {
    var url = '${dotenv.env['BACKEND_BASE_URL']}/$verifyUser';
    var user = await getUser();
    try {
      final response = await Api().dio.post(
        url,
        data: {
          'verificationKey': verificationCode,
        },
      );

      if (response.statusCode == 200) {
        user.verified = true;
        var lm = json.encode(user.toJson());
        setUser(user: lm);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<ServiceResponse> resetPasswordService(
      {required String phoneNumber,
      required String verificationCode,
      required String password,
      required String confirmPassword}) async {
    var url = '${dotenv.env['BACKEND_BASE_URL']}/$resetPasswordUrl';
    try {
      final response = await Dio().post(url, data: {
        "phoneNumber": phoneNumber,
        "confirmPassword": confirmPassword,
        "password": password,
        "passwordResetCode": int.parse(verificationCode)
      });
      if (response.statusCode == 200) {
        return ServiceResponse(message: "Success", success: true);
      }
      return ServiceResponse(message: "Something went wrong", success: false);
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

class LoginResponse {
  bool success;
  String message;
  bool verified;
  LoginResponse({
    required this.success,
    required this.message,
    this.verified = false,
  });
}

class ServiceResponse {
  bool success;
  String message;
  ServiceResponse({
    required this.success,
    required this.message,
  });
}
