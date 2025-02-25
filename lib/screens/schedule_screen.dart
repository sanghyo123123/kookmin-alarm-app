import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kookmin_alarm_app/services/notification_service.dart';

class ScheduleScreen extends StatefulWidget {
  final String busNumber;

  const ScheduleScreen({Key? key, required this.busNumber}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Map<String, List<String>> _busSchedules = {};
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = true;

  String _selectedDayType = '평일'; // "평일" 또는 "휴일" 선택 상태
  String? _selectedTurn;
  List<String> _selectedTimes = [];

  @override
  void initState() {
    super.initState();
    _notificationService.init();
    _loadBusSchedules();
  }

  // JSON 파일에서 버스 시간표 데이터를 불러오는 함수
  Future<void> _loadBusSchedules() async {
    try {
      final String response = await rootBundle.loadString('assets/busTimetable.json');
      final Map<String, dynamic> data = json.decode(response);

      final busData = data[widget.busNumber];
      if (busData == null) {
        print('버스 번호에 해당하는 데이터가 없습니다.');
        setState(() {
          _busSchedules = {};
          _isLoading = false;
        });
        return;
      }

      _updateSchedulesByDayType(busData);

    } catch (e) {
      print('데이터 로드 중 오류 발생: $e');
      setState(() {
        _busSchedules = {};
        _isLoading = false;
      });
    }
  }

  // "평일"/"휴일"에 따라 데이터 업데이트
  void _updateSchedulesByDayType(Map<String, dynamic> busData) {
    final daySchedules = busData[_selectedDayType];
    if (daySchedules == null) {
      print('$_selectedDayType 데이터가 없습니다.');
      setState(() {
        _busSchedules = {};
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _busSchedules = Map<String, List<String>>.from(
        daySchedules.map((key, value) => MapEntry(key, List<String>.from(value))),
      );
      _isLoading = false;
    });
  }

  // 선택된 순번의 모든 출발 시간에 대해 알람을 설정하고 시간을 화면에 표시
  void _setAlarmsAndShowTimes(String turn, List<String> times) {
    for (var time in times) {
      _notificationService.scheduleBusAlarm(
        widget.busNumber,
        turn,
        time,
      );
    }
    setState(() {
      _selectedTurn = turn;
      _selectedTimes = times;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$_selectedDayType - $turn 순번의 모든 출발 시간에 대한 알람이 설정되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.busNumber}번 버스 순번 선택')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _busSchedules.isEmpty
              ? const Center(child: Text('데이터를 불러올 수 없습니다.'))
              : Column(
                  children: [
                    // 평일/휴일 선택 버튼
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ToggleButtons(
                        isSelected: [_selectedDayType == '평일', _selectedDayType == '휴일'],
                        onPressed: (index) {
                          setState(() {
                            _selectedDayType = index == 0 ? '평일' : '휴일';
                            _isLoading = true;
                            _selectedTurn = null;
                            _selectedTimes = [];
                          });
                          _loadBusSchedules(); // 선택 변경 시 데이터 다시 로드
                        },
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('평일', style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('휴일', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _busSchedules.keys.length,
                        itemBuilder: (context, index) {
                          final turn = _busSchedules.keys.elementAt(index);
                          final times = _busSchedules[turn] ?? [];

                          return ListTile(
                            leading: const Icon(Icons.directions_bus),
                            title: Text('$turn 순번 (출발 ${times.length}회)'),
                            subtitle: Text('모든 출발 시간 5분 전에 알람이 설정됩니다.'),
                            onTap: () {
                              _setAlarmsAndShowTimes(turn, times);
                            },
                          );
                        },
                      ),
                    ),
                    if (_selectedTurn != null && _selectedTimes.isNotEmpty) ...[
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$_selectedDayType - $_selectedTurn 순번의 출발 시간',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _selectedTimes.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.access_time),
                              title: Text('출발 시간: ${_selectedTimes[index]}'),
                            );
                          },
                        ),
                      ),
                    ]
                  ],
                ),
    );
  }
}
