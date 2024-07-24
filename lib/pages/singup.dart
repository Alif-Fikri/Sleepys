import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sleepys/pages/namepage.dart';
import '../widgets/signupprovider.dart';
import 'loginpage.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupFormProvider(),
      child: const MaterialApp(
        home: Singups(),
      ),
    );
  }
}

class Singups extends StatelessWidget {
  const Singups({Key? key}) : super(key: key);

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

    final url = Uri.parse('http://localhost:8000/register/');
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

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup successful")),
      );
      // Navigate to NamePage on successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Namepage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupForm = Provider.of<SignupFormProvider>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1D42),
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
                        const Text(
                          'Daftar menggunakan email yang\n valid',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontFamily: 'Urbanist',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        Container(
                          height: 50,
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF2D2C4E),
                              hintText: 'Email',
                              hintStyle: const TextStyle(
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
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
                        const SizedBox(height: 20),
                        Container(
                          height: 50,
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF2D2C4E),
                              hintText: 'Password',
                              hintStyle: const TextStyle(
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
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
                        const SizedBox(height: 20),
                        Container(
                          height: 50,
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF2D2C4E),
                              hintText: 'Confirm Password',
                              hintStyle: const TextStyle(
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
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
                        const SizedBox(height: 80),
                        ElevatedButton(
                          onPressed: () {
                            _signup(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF009090),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            text: 'Sudah memiliki akun? ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Masuk sekarang',
                                style: const TextStyle(
                                  color: Color(0xFF00D0C0),
                                  fontFamily: 'Urbanist',
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
