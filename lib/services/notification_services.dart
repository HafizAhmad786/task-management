import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tgo_todo/services/firebase_services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    await requestExactAlarmPermission();

    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await localNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse response) {
      String? taskId = response.payload;
      if (taskId != null) {
        updateTask({
          'type': "Completed",
        }, taskId);
      }
    });
  }

  Future<void> requestExactAlarmPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      debugPrint('Permission granted!');
    } else {
      await Permission.notification.request();
    }
  }

  Future<void> scheduleNotification(
      {required int id, required String title, required String body, required DateTime scheduledDateTime, required String taskId}) async {
    if (scheduledDateTime.isBefore(DateTime.now())) {
      scheduledDateTime = DateTime.now().add(Duration(seconds: 10));
    }

    // Convert DateTime to TZDateTime for scheduling
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(scheduledDateTime, tz.local);

    // Ensure the scheduled time is still in the future
    if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await localNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id',
            'Your Channel Name',
            channelDescription: 'Your channel description',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: null,
        payload: taskId);
  }

  updateTask(Map<String, dynamic> update, String taskId) async {
    final firebaseService = FirebaseServices();
    await firebaseService.updateTask(update, taskId);
  }
}
