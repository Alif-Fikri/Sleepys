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
    var screenSize = MediaQuery.of(context).size;

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
              padding: EdgeInsets.only(
                top: screenSize.height * 0.030, // Responsive top padding
                bottom: screenSize.height * 0.20, // Responsive bottom padding
              ),
              child: Text(
                'Selamat tidur, Serena',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.06, // Responsive font size
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
            Center(
              child: Text(
                _currentTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.12, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                'Waktu bangun: ${widget.wakeUpTime}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.045, // Responsive font size
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.10),
              child: Image.asset('assets/images/line.png'),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.10),
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.grey,
                  size: screenSize.width * 0.08, // Responsive icon size
                ),
              ),
            ),
            Center(
              child: Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
                size: screenSize.width * 0.08, // Responsive icon size
              ),
            ),
            Center(
              child: Text(
                'Geser ke atas untuk bangun',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: screenSize.width * 0.035, // Responsive font size
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
