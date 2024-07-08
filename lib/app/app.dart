import 'package:flutter/material.dart';
import 'package:my_task_manager/services/connectivity_checker.dart';
import 'package:my_task_manager/themes/app_theme.dart';
import 'package:my_task_manager/themes/theme_changer.dart';
import 'package:my_task_manager/utils/app_routes.dart';
import 'package:my_task_manager/utils/app_strings.dart';
import 'package:my_task_manager/viewModels/auth_view_model.dart';
import 'package:my_task_manager/viewModels/countdown_timer_view_model.dart';
import 'package:my_task_manager/viewModels/dashboard_view_model.dart';
import 'package:my_task_manager/viewModels/task_view_model.dart';
import 'package:my_task_manager/viewModels/user_view_model.dart';
import 'package:provider/provider.dart';

class TaskManager extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  final String userTheme;

  const TaskManager({super.key, required this.userTheme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ChangeNotifierProvider(create: (_) => CountdownTimerViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeChanger()),
        ChangeNotifierProvider(create: (_) => ConnectivityChecker()),
      ],
      child: Builder(builder: (context) {
        if (!context.read<ThemeChanger>().isAppLaunched) {
          loadUserTheme(userTheme, context);
        }
        context.read<ThemeChanger>().setIsAppLaunched = true;
        context.read<ConnectivityChecker>().initConnectivityChecker();
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splashScreen,
          onGenerateRoute: (routeSettings) {
            return AppRoutes.generateRoute(routeSettings);
          },
          themeMode: context.watch<ThemeChanger>().themeMode,
          theme: AppTheme.getLightTheme(),
          darkTheme: AppTheme.getDarkTheme(),
        );
      }),
    );
  }

  void loadUserTheme(String theme, BuildContext context) {
    switch (theme) {
      case AppStrings.darkMode:
        context.read<ThemeChanger>().setThemeModeSilent = ThemeMode.dark;

      case AppStrings.lightMode:
        context.read<ThemeChanger>().setThemeModeSilent = ThemeMode.light;

      case AppStrings.systemMode:
        context.read<ThemeChanger>().setThemeModeSilent = ThemeMode.system;
    }
  }
}
