import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sleepys/widgets/dailystep.dart';

class Bloodpressure extends StatefulWidget {
  final String email;
  Bloodpressure({required this.email, Key? key}) : super(key: key);

  @override
  _BloodpressureState createState() => _BloodpressureState();
}

class _BloodpressureState extends State<Bloodpressure> {
  TextEditingController _upperPressureController = TextEditingController();
  TextEditingController _lowerPressureController = TextEditingController();

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
        builder: (context) => Dailystep(
          email: widget.email,
        ),
      ),
    );
  }

  Future<void> _saveBloodPressure() async {
    int upperPressure = int.tryParse(_upperPressureController.text) ?? 0;
    int lowerPressure = int.tryParse(_lowerPressureController.text) ?? 0;

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/save-blood-pressure/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': widget.email,
          'upperPressure': upperPressure,
          'lowerPressure': lowerPressure,
        }),
      );

      if (response.statusCode == 200) {
        print(
            'Blood pressure saved successfully: ${jsonDecode(response.body)}');
      } else {
        print('Failed to save blood pressure: ${response.body}');
        throw Exception('Failed to save blood pressure');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _saveAndNavigate() {
    _saveBloodPressure().then((_) {
      _navigateToSleepPage();
    }).catchError((error) {
      print('Error: $error');
    });
  }

  void _skipAndNavigate() {
    _navigateToSleepPage();
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
              'Saya ingin tahu tentang kamu,',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 5), // Add spacing between the texts
            Text(
              'Berapa tekanan darah kamu seminggu terakhir?',
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
                    controller: _upperPressureController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) => _saveAndNavigate(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF272E49),
                      hintText: 'Tekanan darah atas',
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
                      onPressed: () => _decrement(_upperPressureController),
                      icon: Icon(Icons.remove, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => _increment(_upperPressureController),
                      icon: Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20), // Add spacing between the text fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lowerPressureController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) => _saveAndNavigate(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF272E49),
                      hintText: 'Tekanan darah bawah',
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
                      onPressed: () => _decrement(_lowerPressureController),
                      icon: Icon(Icons.remove, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => _increment(_lowerPressureController),
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
                        onPressed: _saveAndNavigate,
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
                    SizedBox(height: 10), // Add spacing between the buttons
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
