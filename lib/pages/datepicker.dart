import 'package:flutter/material.dart';
import 'package:sleepys/pages/heightselection.dart';

class Datepicker extends StatelessWidget {
  const Datepicker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Datepickers(),
    );
  }
}

class Datepickers extends StatefulWidget {
  const Datepickers({super.key});

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
              'Terima kasih!',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Sekarang, kapan tanggal lahir mu?',
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
                                primary: Color(
                                    0xFF20223F), // Header background color
                                onPrimary: Colors.white, // Header text color
                                surface: Colors.white, // Background color
                                onSurface: Colors.black, // Text color
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
                        // Delay for 3 seconds before navigating to the next page
                        await Future.delayed(Duration(seconds: 3));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HeightSelection(),
                          ),
                        );
                      }
                    },
                    child: AbsorbPointer(
                      child: Container(
                        width: 350,
                        height: 55,
                        child: TextField(
                          controller: _controller,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF272E49),
                            hintText: 'DD / MM / YYYY',
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
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
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
    );
  }
}
