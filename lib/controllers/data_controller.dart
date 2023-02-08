import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/models/task_status_model.dart';
import 'package:task_manager/models/user_data_model.dart';
import 'package:task_manager/services/api_service.dart';
import 'package:tuple/tuple.dart';

class Data extends GetxController {
  late SharedPreferences _sharedPreferences;
  String? token;
  UserData userData = UserData();
  String _password = "";
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
    // showSnack("Message", "Loading data");
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
      showSnack("Error!", "No internet connection");
    } catch (e) {
      if (e == 401) {
        token = null;
        showSnack("Error!", "Unauthorized user details");
        _sharedPreferences.clear();
      } else {
        showSnack("Error!", e.toString());
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
    showSnack("Success", "Login successful");
    _password = password;
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
      showSnack("Error!", "Faild to create new account");
    } else {
      showSnack("Success", "Account has been created");
    }
    return result;
  }

  Future<bool> createTask({required String title, required String description, TaskStatus status = TaskStatus.New}) async {
    bool result = await _errorHandle(() async => await APIServices.createTask(title: title, description: description, status: status, token: token ?? ""));
    showSnack("Message", "Requesting");
    if (!result) {
      showSnack("Error!", "Faild to create new task");
    } else {
      showSnack("Success", "new task has been created");
      await _errorHandle(() async => await loadTasks(taskStatus: status));
      update();
    }
    return result;
  }

  Future<void> statusChange({required Task task, TaskStatus? currentStatus}) async {
    if (token == null) return;
    if (task.status == currentStatus) return;

    // Status change
    if (currentStatus != null) await _errorHandle(() async => await APIServices.statusChange(task: task, currentStatus: currentStatus, token: token ?? ""));

    // Delete task (Move task to TaskStatus.Other)
    if (currentStatus == null) await _errorHandle(() async => await APIServices.statusChange(task: task, currentStatus: TaskStatus.Other, token: token ?? ""));

    showSnack("Success", currentStatus == null ? "Task delete successful" : "Status update successful");
    await _errorHandle(() async => await loadTasks(taskStatus: task.status));
    if (currentStatus != null) await _errorHandle(() async => await loadTasks(taskStatus: currentStatus));
    update();
  }

  Future<bool> updateProfile({UserData? ud, String? password, File? file}) async {
    if (token == null) return false;

    if (await _errorHandle(() async => await APIServices.updateProfile(userData: ud, password: password, token: token ?? "", file: file))) {
      showSnack("Success", "Profile update successful");
      // Re-Login
      await loginRequest(email: ud!.email ?? userData.email ?? "", password: password ?? _password);
      return true;
    } else {
      showSnack("Error", "Update profile is not avaiable at this time");
      return false;
    }
  }

  void showSnack(String title, String message) {
    // Get.snackbar(
    //   title,
    //   message,
    //   snackPosition: SnackPosition.BOTTOM,
    //   margin: const EdgeInsets.all(defaultPadding / 2),
    //   padding: const EdgeInsets.all(defaultPadding / 2),
    // );

    Fluttertoast.showToast(msg: "$title: $message");
  }
}
