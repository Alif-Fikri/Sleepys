import 'package:flutter/material.dart';
import 'package:sleepys/widgets/sleepprofile.dart'; // Pastikan Anda mengganti ini dengan path yang benar

class DailySleepProfile extends StatelessWidget {
  final String email;

  DailySleepProfile({required this.email});

  @override
  Widget build(BuildContext context) {
    double baseFontSize = MediaQuery.of(context).size.width * 0.035;
    double buttonFontSize = baseFontSize * 0.65;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Card(
        color: Color(0xFF272E49),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Untuk hasil analisa yang lebih baik, akurat, dan bermanfaat. Profil tidur harian hanya bisa diakses setelah kamu melakukan pelacakan tidur setiap hari.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: baseFontSize,
                  fontFamily: 'Urbanist',
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 33,
                    width: 130,
                    margin: EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF009090),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SleepProfile(
                            email: email,
                          ),
                        ));
                      },
                      child: Text(
                        'Lihat profil tidur harian',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: buttonFontSize,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeeklySleepProfile extends StatelessWidget {
  final String email;

  WeeklySleepProfile({required this.email});

  @override
  Widget build(BuildContext context) {
    double baseFontSize = MediaQuery.of(context).size.width * 0.035;
    double buttonFontSize = baseFontSize * 0.65;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Card(
        color: Color(0xFF272E49),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Untuk hasil analisa yang lebih baik, akurat, dan bermanfaat. Profil tidur mingguan hanya bisa diakses setelah kamu melakukan pelacakan tidur setiap minggu.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: baseFontSize,
                  fontFamily: 'Urbanist',
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 33,
                    width: 130,
                    margin: EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF009090),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SleepProfile(
                            email: email,
                          ),
                        ));
                      },
                      child: Text(
                        'Lihat profil tidur mingguan',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: buttonFontSize,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MonthlySleepProfile extends StatelessWidget {
  final String email;

  MonthlySleepProfile({required this.email});

  @override
  Widget build(BuildContext context) {
    double baseFontSize = MediaQuery.of(context).size.width * 0.035;
    double buttonFontSize = baseFontSize * 0.65;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Card(
        color: Color(0xFF272E49),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Untuk hasil analisa yang lebih baik, akurat, dan bermanfaat. Profil tidur bulanan hanya bisa diakses setelah kamu melakukan pelacakan tidur paling tidak selama 30 hari.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: baseFontSize,
                  fontFamily: 'Urbanist',
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 33,
                    width: 130,
                    margin: EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF009090),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SleepProfile(
                            email: email,
                          ),
                        ));
                      },
                      child: Text(
                        'Lihat profil tidur bulanan',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: buttonFontSize,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
