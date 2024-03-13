import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/models/task_model.dart';


class NotificationManager {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('ic_launcher');

    DarwinInitializationSettings initializationIos =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationIos);
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  Future<void> simpleNotificationShow(Task task) async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'Channel_id',
      'Channel_title',
      priority: Priority.high,
      importance: Importance.max,
      icon: 'ic_launcher',
      channelShowBadge: true,
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails);

    DateTime duedate = task.dueDate;
    String date = duedate.toString();
    String notificationTitle = task.title;
    String notificationBody = 'Priority:${task.priority}\nDue Date:$date';

    await notificationsPlugin.show(
        0, notificationTitle, notificationBody, notificationDetails);
  }


  Future<void> schedulePeriodicNotification(List<Task> tasks) async {
    DateTime currentDate = DateTime.now();
    List<Task> todayTasks = tasks.where((task) {
      return task.dueDate.year == currentDate.year &&
          task.dueDate.month <= currentDate.month &&
          task.dueDate.day <= currentDate.day;
    }).toList();
    for(Task task in todayTasks){
      simpleNotificationShow(task);
      await Future.delayed(const Duration(seconds: 2
      ));
    }
  }
}