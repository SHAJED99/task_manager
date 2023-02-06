import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/models/task_status.dart';
import 'package:task_manager/models/user_data_model.dart';
import 'package:tuple/tuple.dart';

class APIServices {
  static const String _baseURL = "https://task.teamrabbil.com/api/v1";
  static final Map<String, String> _header = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  static Future<Tuple2<String, UserData>> login({required String email, required String password}) async {
    String url = "/login";
    try {
      final http.Response response = await http.post(
        Uri.parse("$_baseURL$url"),
        headers: _header,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode != 200) throw response.statusCode;
      var metaData = jsonDecode(response.body);
      return Tuple2(metaData['token'], UserData.fromJson(metaData['data']));
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Task>> getTask({required TaskStatus taskStatus, required String token}) async {
    String url = "/listTaskByStatus/";
    _header["token"] = token;
    try {
      final http.Response response = await http.get(
        Uri.parse("$_baseURL$url${taskStatus.name}"),
        headers: _header,
      );
      if (response.statusCode != 200) throw response.statusCode;

      List<Task> data = [];
      jsonDecode(response.body)['data'].forEach((v) {
        data.add(Task.fromJson(v));
      });

      return data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> signup({required UserData userData, required String password}) async {
    String url = "/registration";
    try {
      final http.Response response = await http.post(
        Uri.parse("$_baseURL$url"),
        headers: _header,
        body: jsonEncode({
          "email": userData.email,
          "firstName": userData.firstName,
          "lastName": userData.lastName,
          "mobile": userData.mobile,
          "password": password,
          "photo": "",
        }),
      );
      if (response.statusCode != 200) throw response.statusCode;

      // return true is Response is success
      return jsonDecode(response.body)['status'] == "success" ? true : false;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> createTask({required String title, required String description, required TaskStatus status, required String token}) async {
    String url = "/createTask";
    _header["token"] = token;
    try {
      final http.Response response = await http.post(
        Uri.parse("$_baseURL$url"),
        headers: _header,
        body: jsonEncode({
          "title": title,
          "description": description,
          "status": status.name,
        }),
      );
      if (response.statusCode != 200) throw response.statusCode;

      // return true is Response is success
      return jsonDecode(response.body)['status'] == "success" ? true : false;
    } catch (e) {
      rethrow;
    }
  }
}
