import 'package:flutter/material.dart';
import 'dart:async';

class AlarmScreen extends StatefulWidget {
  final String wakeUpTime;

  AlarmScreen({required this.wakeUpTime});

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _currentTime = _formatDateTime(DateTime.now());
      });
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _stopAlarm() {
    // Implement alarm stop functionality here
    print("Alarm stopped");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20223F), // Background color from the image
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! < -10) {
            _stopAlarm();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 53, bottom: 250),
              child: Text(
                'Selamat tidur, Serena',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: Text(
                _currentTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                'Waktu bangun: ${widget.wakeUpTime}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Image.asset('assets/images/line.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.grey,
                  size: 32,
                ),
              ),
            ),
            Center(
              child: Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
                size: 32,
              ),
            ),
            Center(
              child: Text(
                'Geser ke atas untuk bangun',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
