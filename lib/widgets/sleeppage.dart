import 'package:flutter/material.dart';
import '../pages/home.dart';
import 'alarmscreen.dart';

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  int selectedWakeUpHour = 7;
  int selectedSleepMinute = 30;

  List<Widget> generateMinutes() {
    return List<Widget>.generate(60, (int index) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (selectedSleepMinute == index)
            Container(
              width: 60,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFF0F2FF).withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          Center(
            child: Text(
              index.toString().padLeft(2, '0'),
              style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      );
    });
  }

  List<Widget> generateHours() {
    return List<Widget>.generate(24, (int index) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (selectedWakeUpHour == index)
            Container(
              width: 60,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFF0F2FF).withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          Center(
            child: Text(
              index.toString().padLeft(2, '0'),
              style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF20223F),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF272E49),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 75),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Pilih waktu bangun tidur mu',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 100,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 50,
                      perspective: 0.001,
                      diameterRatio: 2.0,
                      physics: FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedWakeUpHour = index;
                        });
                      },
                      childDelegate: ListWheelChildLoopingListDelegate(
                        children: generateHours(),
                      ),
                    ),
                  ),
                  Text(
                    ':',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  SizedBox(
                    height: 150,
                    width: 100,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 50,
                      perspective: 0.001,
                      diameterRatio: 2.0,
                      physics: FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedSleepMinute = index;
                        });
                      },
                      childDelegate: ListWheelChildLoopingListDelegate(
                        children: generateMinutes(),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 45),
                child: RichText(
                  text: TextSpan(
                      text: 'Waktu tidur ideal yang cukup adalah \nselama ',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          color: Colors.white),
                      children: [
                        TextSpan(
                            text: '8 jam',
                            style: TextStyle(
                                fontFamily: 'Urbanist', color: Colors.red))
                      ]),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 159),
                child: Container(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AlarmScreen(
                            wakeUpTime:
                                '${selectedWakeUpHour.toString().padLeft(2, '0')}:${selectedSleepMinute.toString().padLeft(2, '0')}',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Tidur sekarang',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00A8B5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text(
                  'Nanti saja',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
