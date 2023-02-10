import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/models/task_status_model.dart';
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

  static Future<void> statusChange({required Task task, required TaskStatus currentStatus, required String token}) async {
    String url = "/updateTaskStatus/${task.sId}/${currentStatus.name}";

    _header["token"] = token;
    try {
      final http.Response response = await http.get(
        Uri.parse("$_baseURL$url"),
        headers: _header,
      );
      if (response.statusCode != 200) throw response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

// Image Upload is not avaiable now
  // static Future<bool> updateProfile({
  //   File? file,
  //   UserData? userData,
  //   String? password,
  //   required String token,
  // }) async {
  //   bool isValid = false;
  //   String url = "/profileUpdate";
  //   _header["token"] = token;

  //   // Create a new multipart request
  //   var request = http.MultipartRequest('POST', Uri.parse("$_baseURL$url"));
  //   request.headers.addAll(_header);
  //   print("$_baseURL$url");

  //   // Add file
  //   if (file != null) {
  //     isValid = true;
  //     print("1");
  //     List<int> bytes = await file.readAsBytes();
  //     // Create a new multipart file from the image file
  //     var multipartFile = await http.MultipartFile.fromBytes(
  //       'photo',
  //       bytes,
  //       filename: "image.jpg",
  //     );
  //     // Add the multipart file to the request
  //     request.files.add(multipartFile);
  //   }

  //   // Add UserData
  //   if (userData != null) {
  //     for (MapEntry<String, dynamic> i in userData.toJson().entries) {
  //       if (i.value != null) {
  //         isValid = true;
  //         print(i.key);
  //         request.fields[i.key] = i.value;
  //       }
  //     }
  //   }

  //   // Add password
  //   print(password);
  //   if (password != null) {
  //     isValid = true;
  //     print("2");
  //     request.fields['password'] = password;
  //   }

  //   print(request.headers);
  //   print(request.fields);
  //   print(request.files);

  //   try {
  //     if (isValid) {
  //       final responseMetaData = await request.send();

  //       print(jsonDecode(await responseMetaData.stream.bytesToString()));

  //       if (responseMetaData.statusCode != 200) throw responseMetaData.statusCode;
  //       return jsonDecode(await responseMetaData.stream.bytesToString())['data']['acknowledged'];
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  static Future<bool> updateProfile({
    UserData? userData,
    String? password,
    required String token,
  }) async {
    String url = "/profileUpdate";
    bool isValid = false;

    Map<String, dynamic> requestBody = {};

    // Add UserData
    if (userData != null) {
      for (MapEntry<String, dynamic> i in userData.toJson().entries) {
        if (i.value != null) {
          isValid = true;

          requestBody[i.key] = i.value;
        }
      }
    }

    // Add password
    if (password != null) {
      isValid = true;

      requestBody['password'] = password;
    }

    try {
      if (isValid) {
        print(requestBody.toString());
        final http.Response response = await http.post(
          Uri.parse("$_baseURL$url"),
          headers: _header,
          body: jsonEncode(requestBody),
        );
        if (response.statusCode != 200) throw response.statusCode;

        print(jsonDecode(response.body));

        // return true is Response is success
        return jsonDecode(response.body)['status'] == "success" ? true : false;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
