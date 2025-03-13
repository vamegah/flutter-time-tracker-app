import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../providers/task_provider.dart';
import '../providers/time_entry_provider.dart';
import '../screens/home_screen.dart';
import '../screens/project_management_screen.dart';
import '../screens/task_management_screen.dart';
import '../screens/time_entry_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;

  const MyApp({Key? key, required this.localStorage}): super(key:key);

  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider(localStorage)),
        ChangeNotifierProvider(create: (_) => ProjectProvider(localStorage)),
        ChangeNotifierProvider(create: (_) => TimeEntryProvider(localStorage)),
      ],
      child: MaterialApp(
        title: 'Time Tracker App',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/manage_tasks': (context) => TaskManagementScreen(),
          '/manage_projects': (context) => ProjectManagementScreen(),
          '/time_entry': (context) => TimeEntryScreen(),
        }
      )
    );
  }
}