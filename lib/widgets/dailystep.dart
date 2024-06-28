import 'package:flutter/material.dart';
import 'package:sleepys/widgets/sleeppage.dart';
import 'package:sleepys/widgets/bloodpressure.dart';

class Dailystep extends StatefulWidget {
  Dailystep({super.key});

  @override
  _DailystepState createState() => _DailystepState();
}

class _DailystepState extends State<Dailystep> {
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
        builder: (context) => SleepPage(),
      ),
    );
  }

  void _saveAndNavigate() {
    // Add your save logic here
    _navigateToSleepPage();
  }

  void _NextAndNavigate() {
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
              'Berapa Jumlah langkah hari ini?',
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
                    onSubmitted: (value) => _navigateToSleepPage(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF272E49),
                      hintText: 'Jumlah langkah ',
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
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 350,
                      child: ElevatedButton(
                        onPressed: _NextAndNavigate,
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
