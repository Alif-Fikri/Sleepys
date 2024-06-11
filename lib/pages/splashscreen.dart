import 'package:flutter/material.dart';
import 'package:sleepys/pages/loginpage.dart';
import 'dart:async';
import 'package:sleepys/pages/singup.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();

    Timer( const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ScreenOpsi()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'assets/images/sleepypanda.png',
                height: 150,
                width: 150,
              ),
            ),
            FadeTransition(
              opacity: _animation,
              child: Text(
                'Sleepy Panda',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Urbanist',
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2.0, 2.0),
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenOpsi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/sleepypanda.png',
                height: 170,
                width: 170,
              ),
              Text(
                'Sleepy Panda',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Urbanist',
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2.0, 2.0),
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 230, bottom: 10),
                child: Text(
                  'Mulai dengan masuk atau \nmendaftar untuk melihat analisa \ntidur mu.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Urbanist'),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Loginpage(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF009090),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Masuk',
                    style: TextStyle(
                        height: 0,
                        fontFamily: 'Urbanist',
                        color: Colors.white,
                        fontSize: 17),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Signup(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Daftar',
                    style: TextStyle(
                        height: 0,
                        fontFamily: 'Urbanist',
                        color: Color(0xFF009090),
                        fontSize: 17),
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
