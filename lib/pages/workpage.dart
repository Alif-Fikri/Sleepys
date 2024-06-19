import 'package:flutter/material.dart';
import 'package:sleepys/pages/datepicker.dart';


class Workpage extends StatelessWidget {
  const Workpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Workpages(),
    );
  }
}

class Workpages extends StatelessWidget {
  Workpages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF20223F),
      ),
      backgroundColor: Color(0xFF20223F),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20), // Add horizontal padding
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align children to the start vertically
          crossAxisAlignment: CrossAxisAlignment
              .start, // Align children to the start horizontally
          children: [
            Text(
              'Sleepy Panda ingin mengenalmu!',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 5), // Add spacing between the texts
            Text(
              'Apa Pekerjaan anda sekarang?',
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
                  child: Container(
                    width: 350, // Make the TextField take the full width
                    height: 55,
                    child: TextField(
                      textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Datepicker(),
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF272E49),
                        hintText: 'Pekerjaan',
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
