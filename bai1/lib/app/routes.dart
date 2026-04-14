import 'package:flutter/material.dart';
import '../screens/users/user_screen.dart';

class AppRoutes {
  static const String userList = '/';

  static Map<String, WidgetBuilder> get routes => {
    userList: (_) => const UserScreen(),
  };
}
