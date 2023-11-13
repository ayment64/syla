//********************************** the code is not complete, the key for shared preferences is not completly correct and the code is not tested yet, but it should work. I will update it later ;) ********************************** import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:syla/models/user_model.dart';

class Api {
  final Dio dio = Dio();
  String? accessToken;

  Api() {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('token') != null) {
        options.headers['Authorization'] = 'bearer ${prefs.getString('token')}';
        return handler.next(options);
      }
    }, onError: (DioError error, handler) async {
      final prefs = await SharedPreferences.getInstance();

      if ((error.response?.statusCode == 401)) {
        if (prefs.getString('refresh') != null) {
          if (await refreshToken() != false) {
            return handler.resolve(await _retry(error.requestOptions));
          }
        }
      }
      return handler.next(error);
    }));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final refreshToken = prefs.getString('refresh');
      final response = await dio.post('url', data: {'refresh': refreshToken});
      if (response.statusCode == 200) {
        accessToken = response.data['access'];
        await prefs.setString('accessToken', accessToken!);

        return true;
      } else {
        // an error occurred, do something here

        return false;
      }
    } catch (e) {
      // an error occurred, do something here

      return false;
    }
  }
}

void setToken({required String token, required String refreshToken}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token);
  prefs.setString('refreshToken', refreshToken);
}

void setUser({required String user}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('user', user);
}

void clearUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('user');
}

void clearToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
  prefs.remove('refreshToken');
}

void clearAll() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

Future<User> getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return User.fromJson(json.decode(prefs.getString('user')!));
}
