import 'package:flutter/material.dart';
import 'package:my_task_manager/app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? theme = preferences.getString("themeMode");
  theme ??= "system";
  runApp(TaskManager(userTheme: theme));
}
