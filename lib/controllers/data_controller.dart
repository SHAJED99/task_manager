import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/models/task_status.dart';
import 'package:task_manager/models/user_data_model.dart';
import 'package:task_manager/services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tuple/tuple.dart';

class Data extends GetxController {
  late SharedPreferences _sharedPreferences;
  String? token;
  UserData userData = UserData();
  Map<TaskStatus, List<Task>> tasks = {
    TaskStatus.New: [],
    TaskStatus.Completed: [],
    TaskStatus.Canceled: [],
    TaskStatus.Progress: [],
  };

  Data() {
    _connectLocalDB();
  }

  _connectLocalDB() async {
    // Loading Data from Local db
    _sharedPreferences = await SharedPreferences.getInstance();
    token = _sharedPreferences.getString('token');
    userData.email = _sharedPreferences.getString('email');
    userData.firstName = _sharedPreferences.getString('firstName');
    userData.lastName = _sharedPreferences.getString('lastName');
    userData.mobile = _sharedPreferences.getString('mobile');
    userData.photo = _sharedPreferences.getString('photo');

    // Loading tasks and check if the token is valid or not
    if (token != null) await _errorHandle(() async => await loadTasks());

    update();
  }

  // Refrash data
  reloadData() async {
    if (token != null) await _errorHandle(() async => await loadTasks());
    update();
  }

  // This function load all tasks. It call api 4 times if no input (New, Completed, Canceled, Progress)
  loadTasks({TaskStatus? taskStatus}) async {
    if (taskStatus == null) {
      for (var i = 0; i < 4; i++) {
        List<Task> temp = await APIServices.getTask(taskStatus: TaskStatus.values[i], token: token ?? "");
        // Init tasks list
        tasks[TaskStatus.values[i]] = [];
        tasks[TaskStatus.values[i]]!.addAll(temp);
      }
    } else {
      List<Task> temp = await APIServices.getTask(taskStatus: taskStatus, token: token ?? "");
      // Init tasks list
      tasks[taskStatus] = [];
      tasks[taskStatus]!.addAll(temp);
    }
  }

  // This function handle error. If error code 401, it delete token from local data.
  _errorHandle(Function function) async {
    try {
      return await function();
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No internet connection");
    } catch (e) {
      if (e == 401) {
        token = null;
        Fluttertoast.showToast(msg: "Unauthorized user details");
        _sharedPreferences.clear();
      } else {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  loginRequest({required String email, required String password}) async {
    await _errorHandle(() async {
      Tuple2<String, UserData> values = await APIServices.login(email: email, password: password);
      token = values.item1;
      userData = values.item2;
    });
    if (token == null) return;
    Fluttertoast.showToast(msg: "Login successful");

    _sharedPreferences.setString('token', token!);
    _sharedPreferences.setString('email', userData.email ?? "");
    _sharedPreferences.setString('firstName', userData.firstName ?? "");
    _sharedPreferences.setString('lastName', userData.lastName ?? "");
    _sharedPreferences.setString('mobile', userData.mobile ?? "");
    _sharedPreferences.setString('photo', userData.photo ?? "");

    print(userData.photo);

    // Loading tasks and check if the token is valid or not
    await _errorHandle(() async => await loadTasks());

    update();
  }

  logoutRequest() {
    _sharedPreferences.clear();
    token = null;
    userData = UserData();
    update();
  }

  Future<bool> signupRequest({required UserData userData, required String password}) async {
    bool result = await _errorHandle(() async => await APIServices.signup(userData: userData, password: password));
    if (!result) {
      Fluttertoast.showToast(msg: "Faild to create new account");
    } else {
      Fluttertoast.showToast(msg: "Account has been created");
    }
    return result;
  }
}
