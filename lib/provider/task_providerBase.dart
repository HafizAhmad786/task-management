import 'package:flutter/material.dart';
import 'package:tgo_todo/model/task_model.dart';

abstract class TaskProviderBase {
  Future<void> addNewTask(BuildContext context, String type, {TaskModel? task});
  Future<void> removeTask(BuildContext context, String taskId, int index);
  Future<void> updateTask(BuildContext context, TaskModel newTask, String taskId);
  Future<void> saveTask(BuildContext context, Map<String, dynamic> newTask);
  Future<void> addOrEditTask(BuildContext context, String title, String description, String taskId, {TaskModel? taskData});
}