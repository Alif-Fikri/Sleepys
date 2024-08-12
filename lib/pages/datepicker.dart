import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/heightselection.dart';

class Datepicker extends StatelessWidget {
  final String name;
  final String email;
  final String gender;
  final String work;

  const Datepicker({
    super.key,
    required this.name,
    required this.email,
    required this.gender,
    required this.work,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Datepickers(
        name: name,
        email: email,
        gender: gender,
        work: work,
      ),
    );
  }
}

class Datepickers extends StatefulWidget {
  final String name;
  final String email;
  final String gender;
  final String work;

  const Datepickers({
    super.key,
    required this.name,
    required this.email,
    required this.gender,
    required this.work,
  });

  @override
  _DatepickersState createState() => _DatepickersState();
}

class _DatepickersState extends State<Datepickers> {
  DateTime selectedDate = DateTime.now(); // Default date
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text =
        "${selectedDate.day.toString().padLeft(2, '0')} / ${selectedDate.month.toString().padLeft(2, '0')} / ${selectedDate.year}";
  }

  Future<void> saveDateOfBirth(String dateofbirth) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/save-dob/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': widget.name,
          'email': widget.email,
          'gender': widget.gender,
          'work': widget.work,
          'date_of_birth': dateofbirth,
        }),
      );

      if (response.statusCode == 200) {
        print('Date of birth saved successfully: ${jsonDecode(response.body)}');
      } else {
        print('Failed to save date of birth: ${response.body}');
        throw Exception('Failed to save date of birth');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive sizing
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = deviceWidth * 0.06;
    final double subtitleFontSize = deviceWidth * 0.04;
    final double inputHeight = deviceWidth * 0.14;
    final double inputWidth = deviceWidth * 0.85;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF20223F),
        ),
        backgroundColor: const Color(0xFF20223F),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terima kasih!',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: titleFontSize,
                ),
              ),
              SizedBox(height: deviceWidth * 0.02),
              Text(
                'Sekarang, kapan tanggal lahir mu?',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: subtitleFontSize,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: deviceWidth * 0.25),
                    child: GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: const Color(0xFFFFFFFF),
                                  onPrimary: const Color(0xFF272E49),
                                  surface: const Color(0xFF272E49),
                                  onSurface: const Color(0xFFFFFFFF),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                            _controller.text =
                                "${picked.day.toString().padLeft(2, '0')} / ${picked.month.toString().padLeft(2, '0')} / ${picked.year}";
                          });
                          String formattedDate =
                              "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                          await saveDateOfBirth(formattedDate);
                          await Future.delayed(
                              const Duration(seconds: 2)); // Menunggu 2 detik
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HeightSelection(
                                name: widget.name,
                                email: widget.email,
                                gender: widget.gender,
                                work: widget.work,
                                date_of_birth: formattedDate,
                              ),
                            ),
                          );
                        }
                      },
                      child: AbsorbPointer(
                        child: Container(
                          width: inputWidth,
                          height: inputHeight,
                          decoration: BoxDecoration(
                            color: const Color(0xFF272E49),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: TextField(
                              controller: _controller,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: 'DD / MM / YYYY',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold,
                                fontSize: subtitleFontSize * 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
