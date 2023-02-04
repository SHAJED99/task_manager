import 'package:task_manager/models/user_data_model.dart';

class ResponseData {
  String status = "unauthorized";
  String? token;
  UserData? userData;

  // ResponseData({this.status, this.token, this.userData});

  ResponseData.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? "unauthorized";
    token = json['token'];
    userData = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    if (userData != null) {
      data['data'] = userData!.toJson();
    }
    return data;
  }
}
