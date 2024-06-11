import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'singup.dart';
import '../widgets/signupprovider.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPages(),
    );
  }
}

class LoginPages extends StatelessWidget {
LoginPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupForm = Provider.of<SignupFormProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xFF1E1D42),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/sleepypanda.png',
                        height: 170,
                        width: 170,
                      ),
                      Text(
                        'Masuk menggunakan akun yang \nsudah kamu daftarkan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontFamily: 'Urbanist',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40),
                      Container(
                        height: 50,
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF2D2C4E),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Image.asset(
                                'assets/images/email.png',
                              ),
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
                          onChanged: (value) {
                            signupForm.updateEmail1(value);
                          },
                          controller: TextEditingController(text: signupForm.email1),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 50,
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF2D2C4E),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Image.asset(
                                'assets/images/lock.png',
                              ),
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
                          onChanged: (value) {
                            signupForm.updatePassword1(value);
                          },
                          controller: TextEditingController(text: signupForm.password1),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return ForgotPasswordBottomSheet();
                              },
                            );
                          },
                          child: Text(
                            'Lupa password?',
                            style: TextStyle(
                              color: Color(0xFF00D0C0),
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 130),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF009090),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          'Masuk',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: 'Belum memiliki akun? ',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Daftar sekarang',
                                style: TextStyle(
                                  color: Color(0xFF00D0C0),
                                  fontFamily: 'Urbanist',
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => Signup(),
                                    ));
                                  }),
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
      ),
    );
  }
}

class ForgotPasswordBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(30),
        height: 350,
        decoration: BoxDecoration(
          color: Color(0xFF272E49),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(27),
            topRight: Radius.circular(27),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 4,
              color: Color(0xFF009090),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Lupa Password?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Instruksi untuk melakukan reset password akan \ndikirim melalui email yang kamu gunakan untuk \nmendaftar.',
              style: TextStyle(
                  fontFamily: 'Urbanist', fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: screenWidth * 0.85,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  hintStyle: TextStyle(
                      color: Color(0xFF333333), fontFamily: 'Urbanist'),
                  prefixIcon: Container(
                    padding: EdgeInsets.all(16),
                    child: Image.asset('assets/images/email1.png'),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style:
                    TextStyle(color: Color(0xFF333333), fontFamily: 'Urbanist'),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: screenWidth * 0.85,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF009090),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                      fontFamily: 'Urbanist',
                      color: Colors.white,
                      fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
