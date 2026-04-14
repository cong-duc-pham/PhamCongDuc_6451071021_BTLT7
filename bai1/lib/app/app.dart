import 'package:flutter/material.dart';
import 'routes.dart';
import '../common/styles/app_styles.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Danh Bạ - 6451071021',
      debugShowCheckedModeBanner: false,
      theme: AppStyles.theme,
      initialRoute: AppRoutes.userList,
      routes: AppRoutes.routes,
    );
  }
}