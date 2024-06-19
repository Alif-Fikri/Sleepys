import 'package:flutter/material.dart';
import 'package:sleepys/pages/datepicker.dart';
import 'package:sleepys/pages/namepage.dart';
import 'package:sleepys/pages/workpage.dart';

class Genderpage extends StatelessWidget {
  final String name;

  const Genderpage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Genderpages(name: name),
    );
  }
}

class Genderpages extends StatefulWidget {
  final String name;

  const Genderpages({super.key, required this.name});

  @override
  _GenderpagesState createState() => _GenderpagesState();
}

class _GenderpagesState extends State<Genderpages> {
  Color borderColor1 = Colors.transparent;
  Color borderColor2 = Colors.transparent;

  void _onTap(int index) {
    setState(() {
      if (index == 1) {
        borderColor1 = borderColor1 == Colors.transparent
            ? Color(0xFF009090)
            : Colors.transparent;
        borderColor2 = Colors.transparent;
      } else {
        borderColor2 = borderColor2 == Colors.transparent
            ? Color(0xFF009090)
            : Colors.transparent;
        borderColor1 = Colors.transparent;
      }
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Workpage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF20223F),
      ),
      backgroundColor: Color(0xFF20223F),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi ${widget.name}!',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Pilih gender kamu, agar kami bisa mengenal kamu lebih baik.',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _onTap(1),
                        child: Container(
                          width: 350,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF272E49),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: borderColor1, width: 2),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Image.asset('assets/images/person2.png'),
                              ),
                              Text(
                                'Perempuan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => _onTap(2),
                        child: Container(
                          width: 350,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF272E49),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: borderColor2, width: 2),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Image.asset('assets/images/person1.png'),
                              ),
                              Text(
                                'Pria',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
