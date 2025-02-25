import 'dart:convert';
import 'package:flutter/services.dart';

class BusTimetable {
  final String busNumber;
  final List<String> times;

  BusTimetable({required this.busNumber, required this.times});

  factory BusTimetable.fromJson(Map<String, dynamic> json) {
    return BusTimetable(
      busNumber: json['busNumber'],
      times: List<String>.from(json['times']),
    );
  }

  static Future<List<BusTimetable>> loadTimetable() async {
    final String response = await rootBundle.loadString('assets/busTimetable.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => BusTimetable.fromJson(json)).toList();
  }
}
