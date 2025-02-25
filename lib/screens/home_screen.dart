import 'package:flutter/material.dart';
import 'package:kookmin_alarm_app/screens/schedule_screen.dart';
import 'package:kookmin_alarm_app/services/notification_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key); // const 제거

  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kookmin Alarm')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScheduleScreen(busNumber: '705'), // const 제거
                  ),
                );
              },
              child: const Text('705번 버스 시간표'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScheduleScreen(busNumber: '707'), // const 제거
                  ),
                );
              },
              child: const Text('707번 버스 시간표'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _notificationService.cancelAllAlarms();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('모든 알람이 취소되었습니다.')),
                );
              },
              child: const Text('모든 알람 취소'),
            ),
          ],
        ),
      ),
    );
  }
}
