import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sleepys/widgets/sleeppage.dart';

class Dailystep extends StatefulWidget {
  final String email;
  Dailystep({required this.email, Key? key}) : super(key: key);

  @override
  _DailystepState createState() => _DailystepState();
}

class _DailystepState extends State<Dailystep> {
  TextEditingController _stepsController = TextEditingController();

  void _increment(TextEditingController controller) {
    setState(() {
      int currentValue = int.tryParse(controller.text) ?? 0;
      controller.text = (currentValue + 1).toString();
    });
  }

  void _decrement(TextEditingController controller) {
    setState(() {
      int currentValue = int.tryParse(controller.text) ?? 0;
      if (currentValue > 0) {
        controller.text = (currentValue - 1).toString();
      }
    });
  }

  void _navigateToSleepPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SleepPage(email: widget.email),
      ),
    );
  }

  Future<void> _saveDailySteps() async {
    int dailySteps = int.tryParse(_stepsController.text) ?? 0;

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/save-daily-steps/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': widget.email,
          'dailySteps': dailySteps,
        }),
      );

      if (response.statusCode == 200) {
        print('Daily steps saved successfully: ${jsonDecode(response.body)}');
      } else {
        print('Failed to save daily steps: ${response.body}');
        throw Exception('Failed to save daily steps');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _saveAndNavigate() {
    _saveDailySteps().then((_) {
      _navigateToSleepPage();
    }).catchError((error) {
      print('Error: $error');
    });
  }

  void _nextAndNavigate() {
    _saveDailySteps().then((_) {
      _navigateToSleepPage();
    }).catchError((error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF20223F),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xFF20223F),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saya ingin tau tentang kamu,',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 5), // Add spacing between the texts
            Text(
              'Berapa jumlah langkah hari ini?',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(
                height: 20), // Add spacing between the texts and text fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _stepsController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) => _nextAndNavigate(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF272E49),
                      hintText: 'Jumlah langkah',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _decrement(_stepsController),
                      icon: Icon(Icons.remove, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => _increment(_stepsController),
                      icon: Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 350,
                      child: ElevatedButton(
                        onPressed: _nextAndNavigate,
                        child: Text('Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF009090), // Button color
                          textStyle: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16,
                          ),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
