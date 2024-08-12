import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'namepage.dart';
import 'loginpage.dart';
import '../widgets/signupprovider.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupFormProvider(),
      child: const MaterialApp(
        home: Signups(),
      ),
    );
  }
}

class Signups extends StatelessWidget {
  const Signups({Key? key}) : super(key: key);

  Future<void> _signup(BuildContext context) async {
    final signupForm = Provider.of<SignupFormProvider>(context, listen: false);
    final email = signupForm.email;
    final password = signupForm.password;
    final confirmPassword = signupForm.confirmPassword;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      final url = Uri.parse(
          'http://10.0.2.2:8000/register/'); // Use the correct IP for your setup
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

        if (token != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Signup successful")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Namepage(email: email),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error: Token not found")),
          );
        }
      } else {
        final errorResponse = json.decode(response.body);
        final errorMessage = errorResponse['detail'] ?? 'An error occurred';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
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
                        Text(
                          'Daftar menggunakan email yang\n valid',
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
                                    EdgeInsets.all(screenSize.width * 0.035),
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
                              signupForm.updateEmail(value);
                            },
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                text: signupForm.email,
                                selection: TextSelection.collapsed(
                                    offset: signupForm.email.length),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
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
                                    EdgeInsets.all(screenSize.width * 0.035),
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
                              signupForm.updatePassword(value);
                            },
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                text: signupForm.password,
                                selection: TextSelection.collapsed(
                                    offset: signupForm.password.length),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Container(
                          height: screenSize.height * 0.07,
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF2D2C4E),
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                              ),
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.all(screenSize.width * 0.035),
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
                              signupForm.updateConfirmPassword(value);
                            },
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                text: signupForm.confirmPassword,
                                selection: TextSelection.collapsed(
                                    offset: signupForm.confirmPassword.length),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.1),
                        ElevatedButton(
                          onPressed: () {
                            _signup(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF009090),
                            padding: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.01),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            minimumSize:
                                Size(double.infinity, screenSize.height * 0.07),
                          ),
                          child: Text(
                            'Daftar',
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
                            text: 'Sudah memiliki akun? ',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: screenSize.width * 0.04,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Masuk sekarang',
                                style: TextStyle(
                                  color: Color(0xFF00D0C0),
                                  fontFamily: 'Urbanist',
                                  fontSize: screenSize.width * 0.04,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => LoginPages(),
                                      ),
                                    );
                                  },
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
        ),
      ),
    );
  }
}
