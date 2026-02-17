import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tgo_todo/components/k_buttons.dart';
import 'package:tgo_todo/components/svg_icon.dart';
import 'package:tgo_todo/model/task_model.dart';
import 'package:tgo_todo/provider/task_providerBase.dart';
import 'package:tgo_todo/services/firebase_services.dart';
import 'package:tgo_todo/services/notification_services.dart';
import 'package:tgo_todo/services/secure_storage.dart';
import 'package:tgo_todo/utills/constants/app_colors.dart';
import 'package:tgo_todo/utills/constants/assets_path.dart';
import 'package:tgo_todo/utills/constants/text_styles.dart';
import 'package:tgo_todo/utills/loader.dart';
import 'package:tgo_todo/widgets/home_widgets/custom_row.dart';
import 'package:tgo_todo/widgets/home_widgets/todo_sheet.dart';

class HomePageProvider extends ChangeNotifier implements TaskProviderBase {
  List<TaskModel> _tasks = [];
  final notificationService = NotificationServices();

  List<TaskModel> get allTask => _tasks;

  List<TaskModel> _filteredTasks = [];

  List<TaskModel> get filteredTasks => _filteredTasks;

  final formattedDate = DateFormat('EEE d MMMM yyyy').format(DateTime.now());
  final twentyHourTimes = [
    "09:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
    "12:00 PM",
    "12:30 PM",
    "01:00 PM",
    "01:30 PM",
    "02:00 PM",
    "02:30 PM",
    "03:00 PM",
    "03:30 PM",
    "04:00 PM",
    "04:30 PM",
    "05:00 PM",
    "05:30 PM",
    "06:00 PM",
  ];
  final twentyFourHourTimes = [
    "09:30",
    "10:00",
    "10:30",
    "11:00",
    "11:30",
    "12:00",
    "12:30",
    "13:00",
    "13:30",
    "14:00",
    "14:30",
    "15:00",
    "15:30",
    "16:00",
    "16:30",
    "17:00",
    "17:00",
    "17:30",
    "18:00",
  ];
  int _currentFormat = 0;

  int get format => _currentFormat;

  List<bool> get isSelected => [_currentFormat == 0, _currentFormat == 1];

  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  DateTime? get selectedDate => _selectedDate;

  DateTime get focusedDate => _focusedDate;

  String _taskId = "";
  String _title = "";

  String get title => _title;

  String _description = "";

  String get description => _description;

  Priority _priority = Priority.empty;

  Priority get priority => _priority;

  int _selectedIndex = -1;

  int get selectedIndex => _selectedIndex;

  String _time = "";

  String get time => _time;

  String _userId = "";

  String _taskType = "Todo";

  String get taskType => _taskType;

  getAllTasks(BuildContext context) async {
    showLoader();
    var firebaseServices = context.read<FirebaseServices>();
    var storage = context.read<SecureStorage>();
    _userId = await storage.getUserId();
    _tasks = await firebaseServices.getAllTask(_userId);
    _filteredTasks = _tasks;
    notifyListeners();
    hideLoader();
  }

  void filterTasks(String val) {
    if (val.isEmpty) {
      _filteredTasks = List.from(_tasks);
    } else {
      _filteredTasks = _tasks.where((task) => task.title!.toLowerCase().contains(val.toLowerCase())).toList();
    }
    notifyListeners();
  }

  selectedFormat(int index) async {
    _currentFormat = index;
    _time = "";
    notifyListeners();
  }

  currentIndex(int index) async {
    _selectedIndex = index;
    _time = "";
    notifyListeners();
  }

  confirmTime(int index) async {
    _time = _currentFormat == 1 ? twentyFourHourTimes[index] : twentyHourTimes[index];
    notifyListeners();
  }

  @override
  saveTask(BuildContext context, Map<String, dynamic> newTask) async {
    var firebaseServices = context.read<FirebaseServices>();
    _taskId = await firebaseServices.addNewTask(newTask);
  }

  @override
  updateTask(BuildContext context, TaskModel newTask, String taskId) async {
    var firebaseServices = context.read<FirebaseServices>();
    await firebaseServices.updateTask(newTask.toJson(), taskId);
  }

  void setPriority(Priority priority) {
    _priority = priority;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _focusedDate = date;
    notifyListeners();
  }

  @override
  addOrEditTask(BuildContext context, String title, String description, String taskId, {TaskModel? taskData}) async {
    _title = title;
    _description = description;
    Navigator.of(context).pop();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.white,
              title: Center(
                child: Text(
                  "Preview",
                  style: kTextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      showSvgIconWidget(iconPath: AppIcons.clipBoard, context: context),
                      Text(_title, style: kTextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Text(_description,
                      textAlign: TextAlign.center,
                      style: kTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColor.greyText,
                      )),
                  const Divider(),
                  const SizedBox(
                    height: 14,
                  ),
                  CustomRow(
                    icon: AppIcons.flag,
                    text: "Priority",
                    val: _priority.name,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomRow(
                    icon: AppIcons.dateIcon,
                    text: "Due Date",
                    val: DateFormat("dd MMM yyyy").format(_selectedDate),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomRow(
                    icon: AppIcons.alarmIcon,
                    text: "Time",
                    val: _time,
                  )
                ],
              ),
              actions: [
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: kTextButton(
                          btnText: "Back",
                          height: 44,
                          textColor: AppColor.lightPrimary,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                          borderColor: AppColor.lightPrimary),
                    ),
                    Expanded(
                      child: kTextButton(
                        btnText: "Save",
                        textColor: Colors.white,
                        height: 44,
                        onPressed: () async {
                          var newTask = TaskModel(
                              title: title,
                              description: description,
                              date: _selectedDate,
                              time: _time,
                              priority: _priority.name[0].toUpperCase() + _priority.name.substring(1),
                              userId: _userId,
                              type: _taskType);
                          if (taskId.isNotEmpty) {
                            int currentIndex = _tasks.indexWhere((task) => task.taskId == taskData!.taskId);
                            if (currentIndex != -1) {
                              newTask.taskId = taskId;
                              _tasks[currentIndex] = newTask;
                              notifyListeners();
                              _time = "";
                              _priority = Priority.empty;
                              await updateTask(context, newTask, taskId);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } else {
                              Fluttertoast.showToast(msg: "Task not found with taskId: ${taskData!.taskId}");
                            }
                          } else {
                            showLoader();
                            await saveTask(context, newTask.toJson());
                            hideLoader();
                            newTask.taskId = _taskId;
                            _tasks.add(newTask);
                            _time = "";
                            _priority = Priority.empty;
                            notifyListeners();
                            _taskId = "";
                            if (context.mounted) Navigator.pop(context);
                          }
                          DateTime scheduledDateTime = DateTime(
                            newTask.date!.year,
                            newTask.date!.month,
                            newTask.date!.day,
                            parseTimeToHour(newTask.time ?? ""),
                            parseTimeToMinute(newTask.time ?? ""),
                          );
                          await notificationService.scheduleNotification(
                              id: 1,
                              title: newTask.title ?? "",
                              body: newTask.description ?? "",
                              scheduledDateTime: scheduledDateTime,
                              taskId: newTask.taskId ?? "");
                        },
                        color: AppColor.lightPrimary,
                      ),
                    )
                  ],
                )
              ],
            ));
  }

  @override
  removeTask(BuildContext context, String taskId, int index) async {
    var firebase = context.read<FirebaseServices>();
    _tasks.removeAt(index);
    notifyListeners();
    await firebase.deleteTask(taskId);
  }

  int parseTimeToHour(String timeString) {
    try {
      final DateFormat format12 = DateFormat("h:mm a");
      final DateTime parsedDate = format12.parse(timeString);
      return parsedDate.hour;
    } catch (e) {
      final DateFormat format24 = DateFormat("HH:mm");
      final DateTime parsedDate = format24.parse(timeString);
      return parsedDate.hour;
    }
  }

  int parseTimeToMinute(String timeString) {
    try {
      final DateFormat format12 = DateFormat("h:mm a"); // 11:03 PM
      final DateTime parsedDate = format12.parse(timeString);
      return parsedDate.minute;
    } catch (e) {
      final DateFormat format24 = DateFormat("HH:mm"); // 23:03
      final DateTime parsedDate = format24.parse(timeString);
      return parsedDate.minute;
    }
  }

  @override
  addNewTask(BuildContext context, String taskName, {TaskModel? task}) async {
    _taskType = taskName;
    if (task != null && task.toJson().isNotEmpty) {
      _priority = _stringToPriority(task.priority);
      _time = task.time!;
      TodoSheet.todo(context: context, taskName: taskName, task: task, isCalender: false);
    } else {
      TodoSheet.todo(context: context, taskName: taskName, isCalender: false);
    }
  }

  Priority _stringToPriority(String? value) {
    switch (value?.toLowerCase()) {
      case 'high':
        return Priority.high;
      case 'medium':
        return Priority.medium;
      case 'low':
        return Priority.low;
      default:
        return Priority.empty;
    }
  }
}
