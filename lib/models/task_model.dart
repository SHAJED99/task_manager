import 'package:task_manager/models/task_status_model.dart';

class Task {
  String? sId;
  String? title;
  String? description;
  TaskStatus status = TaskStatus.Other;
  String? createdDate;

  Task({this.sId, this.title, this.description, this.status = TaskStatus.Other, this.createdDate});

  Task.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];

    if (json['status'] == TaskStatus.New.name) status = TaskStatus.New;
    if (json['status'] == TaskStatus.Completed.name) status = TaskStatus.Completed;
    if (json['status'] == TaskStatus.Canceled.name) status = TaskStatus.Canceled;
    if (json['status'] == TaskStatus.Progress.name) status = TaskStatus.Progress;

    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    data['status'] = status.name;
    data['createdDate'] = createdDate;
    return data;
  }
}
