import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:sleepys/pages/namepage.dart';
import 'package:sleepys/pages/singup.dart';
import 'package:http/http.dart' as http;
import '../widgets/signupprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPages extends StatelessWidget {
  LoginPages({Key? key}) : super(key: key);

  Future<void> _login(BuildContext context) async {
    final signupForm = Provider.of<SignupFormProvider>(context, listen: false);
    final email = signupForm.email1;
    final password = signupForm.password1;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password harus diisi")),
      );
      return;
    }

    final url = Uri.parse('http://localhost:8000/login/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['access_token'];

      // Simpan token ke tempat penyimpanan yang sesuai (misalnya SharedPreferences)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful")),
      );
      // Navigate to NamePage on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Namepage()),
      );
    } else {
      final errorResponse = json.decode(response.body);
      final errorMessage = errorResponse['detail'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupForm = Provider.of<SignupFormProvider>(context);
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Allow the widget to resize when the keyboard appears
        backgroundColor: const Color(0xFF1E1D42),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 15, horizontal: screenSize.width * 0.1),
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
                          height: screenSize.width * 0.35,
                          width: screenSize.width * 0.35,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Text(
                          'Masuk menggunakan akun yang \nsudah kamu daftarkan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenSize.width * 0.05,
                            fontFamily: 'Urbanist',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenSize.height * 0.05),
                        Container(
                          height: screenSize.height * 0.07,
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF2D2C4E),
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                              ),
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.all(screenSize.width * 0.04),
                                child: Image.asset(
                                  'assets/images/email.png',
                                  height: screenSize.width * 0.06,
                                  width: screenSize.width * 0.06,
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
                              fontSize: screenSize.width * 0.04,
                            ),
                            onChanged: (value) {
                              signupForm.updateEmail1(value);
                            },
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                text: signupForm.email1,
                                selection: TextSelection.collapsed(
                                    offset: signupForm.email1.length),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        Container(
                          height: screenSize.height * 0.07,
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF2D2C4E),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                              ),
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.all(screenSize.width * 0.04),
                                child: Image.asset(
                                  'assets/images/lock.png',
                                  height: screenSize.width * 0.06,
                                  width: screenSize.width * 0.06,
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
                              fontSize: screenSize.width * 0.04,
                            ),
                            onChanged: (value) {
                              signupForm.updatePassword1(value);
                            },
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                text: signupForm.password1,
                                selection: TextSelection.collapsed(
                                    offset: signupForm.password1.length),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
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
                                fontSize: screenSize.width * 0.04,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.15),
                        ElevatedButton(
                          onPressed: () {
                            _login(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF009090),
                            padding: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            minimumSize:
                                Size(double.infinity, screenSize.height * 0.07),
                          ),
                          child: Text(
                            'Masuk',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              color: Colors.white,
                              fontSize: screenSize.width * 0.045,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        RichText(
                          text: TextSpan(
                            text: 'Belum memiliki akun? ',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: screenSize.width * 0.04,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Daftar sekarang',
                                  style: TextStyle(
                                    color: Color(0xFF00D0C0),
                                    fontFamily: 'Urbanist',
                                    fontSize: screenSize.width * 0.04,
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
        padding: const EdgeInsets.all(30),
        height: MediaQuery.of(context).viewInsets.bottom + 350,
        decoration: const BoxDecoration(
          color: Color(0xFF272E49),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(27),
            topRight: Radius.circular(27),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: screenWidth * 0.1,
              height: 4,
              color: const Color(0xFF009090),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Lupa Password?',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.06,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Instruksi untuk melakukan reset password akan dikirim melalui email yang kamu gunakan untuk mendaftar.',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: screenWidth * 0.04,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenWidth * 0.05),
            Container(
              height: screenWidth * 0.12,
              width: screenWidth * 0.85,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: Color(0xFF333333),
                    fontFamily: 'Urbanist',
                    fontSize: screenWidth * 0.04,
                  ),
                  prefixIcon: Container(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Image.asset('assets/images/email1.png'),
                    height: screenWidth * 0.08,
                    width: screenWidth * 0.08,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontFamily: 'Urbanist',
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.03),
            Container(
              height: screenWidth * 0.12,
              width: screenWidth * 0.85,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009090),
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Kirim',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
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