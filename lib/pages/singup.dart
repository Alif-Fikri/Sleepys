import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'loginpage.dart';
import '../widgets/signupprovider.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Singups(),
    );
  }
}

class Singups extends StatelessWidget {
  const Singups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupForm = Provider.of<SignupFormProvider>(context);

    return Scaffold(
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
                        'Masuk menggunakan akun yang \nsudah kamu daftarkan',
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
                          controller: TextEditingController(text: signupForm.email),
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
                          controller: TextEditingController(text: signupForm.password),
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
                            signupForm.updatecPassword(value);
                          },
                          controller: TextEditingController(text: signupForm.cpassword),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                          child: const Text(
                            'Lupa password?',
                            style: TextStyle(
                              color: Color(0xFF00D0C0),
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
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
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Loginpage(),
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
        height: 350,
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
              width: 50,
              height: 4,
              color: const Color(0xFF009090),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Lupa Password?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Instruksi untuk melakukan reset password akan \ndikirim melalui email yang kamu gunakan untuk \nmendaftar.',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              width: screenWidth * 0.85,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  hintStyle: const TextStyle(
                    color: Color(0xFF333333),
                    fontFamily: 'Urbanist',
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(16),
                    child: Image.asset('assets/images/email1.png'),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              width: screenWidth * 0.85,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009090),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    color: Colors.white,
                    fontSize: 18,
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
