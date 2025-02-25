import 'package:flutter/material.dart';
import 'package:kookmin_alarm_app/screens/home_screen.dart';

void main() {
  runApp(const KookminAlarmApp());
}

class KookminAlarmApp extends StatelessWidget {
  const KookminAlarmApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kookmin Alarm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // const 제거
    );
  }
}
