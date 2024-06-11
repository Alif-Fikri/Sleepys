import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(singup());
}

class singup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1D42),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 300,
                    ),
                    Image.asset(
                      'assets/images/sleepypanda.png', // Ensure this path is correct
                      height: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Daftar menggunakan email yang \nvalid',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontFamily: 'Urbanist'),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: 350,
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF2D2C4E),
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Urbanist'),
                                prefixIcon: Container(
                                  padding: EdgeInsets.all(16),
                                  child: Image.asset('assets/images/email.png'),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Urbanist'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: 350,
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF2D2C4E),
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Urbanist'),
                                prefixIcon: Container(
                                    padding: EdgeInsets.all(15),
                                    child: Image.asset(
                                      "assets/images/lock.png",
                                    )),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Urbanist'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: 350,
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF2D2C4E),
                                hintText: 'Confirm Password',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Urbanist'),
                                prefixIcon: Container(
                                  padding: EdgeInsets.all(15),
                                  child: Image.asset('assets/images/lock.png'),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Urbanist'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Container(
                        height: 50,
                        width: 350,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF009090),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text('Daftar',
                              style: TextStyle(
                                  fontFamily: 'Urbanist', color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Sudah memiliki akun? ',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Urbanist'),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Masuk sekarang',
                              style: TextStyle(
                                  color: Color(0xFF00D0C0),
                                  fontFamily: 'Urbanist'),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print("test");
                                }
                                ),
                        ],
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
