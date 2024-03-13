import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:todo_app/task_list.dart';
import 'core/models/priority_model.dart';
import 'core/models/task_model.dart';
import 'core/widgets/priority_provider.dart';
import 'core/widgets/task_provider.dart';

late final tasksBox;
late final priorityBox;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationManager().initNotification();
  NotificationManager notificationManager = NotificationManager();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(TaskAdapter());
  tasksBox = await Hive.openBox<Task>('Tasks');
  List<Task> tasks = tasksBox.values.toList();
  await notificationManager.schedulePeriodicNotification(tasks);
  Hive.registerAdapter(PriorityAdapter());
  priorityBox = await Hive.openBox<Pref>('Priorities');
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TaskProvider()),
          ChangeNotifierProvider(create: (context) => PriorityProvider()),
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: GetMaterialApp(
        title: 'Todo List App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const  Color(0xFFbf32bf)),
          useMaterial3: true,
        ),
        home: const TaskList(),
      ),
    );
  }
}
