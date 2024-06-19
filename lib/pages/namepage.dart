import 'package:flutter/material.dart';
import '../pages/genderpage.dart';

class Namepage extends StatelessWidget {
  const Namepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Namepages(),
    );
  }
}

class Namepages extends StatelessWidget {
  Namepages({super.key});
  final TextEditingController _controller = TextEditingController();

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
              'Selamat datang di Sleepy Panda!',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 5), // Add spacing between the texts
            Text(
              'Kita kenalan dulu yuk! Siapa nama \nkamu?',
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
                      controller: _controller,
                      textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                        String name = _controller.text;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Genderpage(name: name),
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF272E49),
                        hintText: 'Name',
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
