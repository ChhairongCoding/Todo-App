import 'package:flutter/material.dart';
import 'package:todo_app/screens/check_auth_screen.dart';
import 'package:todo_app/screens/home_screen.dart';

void main() {
  runApp(Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff3550A1),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff3550A1),
          iconTheme: IconThemeData(color: Color(0xff8EA9FA), size: 30),
        ),
      ),
      initialRoute: "/",
      routes: {"/": (_) => CheckAuthScreen(), "/home": (_) => HomeScreen()},
    );
  }
}
