import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (kIsWeb) {
      print('웹 환경에서는 알림을 지원하지 않습니다.');
      return;
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings);

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  }

  // 알람 설정 (음성/진동 옵션 추가)
  Future<void> scheduleBusAlarm(String busNumber, String turn, String departureTime,
      {bool isVibration = false, String? customSound}) async {
    if (kIsWeb) {
      print('웹 환경에서는 알림을 지원하지 않습니다.');
      return;
    }

    final DateTime now = DateTime.now();
    final DateTime departureDateTime = DateFormat('HH:mm').parse(departureTime);
    final DateTime alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      departureDateTime.hour,
      departureDateTime.minute,
    ).subtract(const Duration(minutes: 5));

    if (alarmDateTime.isBefore(now)) {
      print('알람 시간이 현재 시간보다 이전입니다.');
      return;
    }

    final tz.TZDateTime tzAlarmDateTime = tz.TZDateTime.from(alarmDateTime, tz.local);

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Bus Alarm',
      channelDescription: '버스 출발 알람 채널',
      importance: Importance.high,
      priority: Priority.high,
      playSound: !isVibration,
      sound: customSound != null
          ? RawResourceAndroidNotificationSound(customSound)
          : null,
      vibrationPattern: isVibration ? Int64List.fromList([0, 1000, 500, 1000]) : null,
    );

    final NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      0,
      '버스 $busNumber 출발 알람',
      '$turn 순번의 버스 출발 5분 전입니다.',
      tzAlarmDateTime,
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print('알람 설정 완료: $tzAlarmDateTime');
  }

  // 모든 알람 취소 기능 추가
  Future<void> cancelAllAlarms() async {
    await _notificationsPlugin.cancelAll();
    print('모든 알람이 취소되었습니다.');
  }
}
