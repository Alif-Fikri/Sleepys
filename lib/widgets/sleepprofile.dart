import 'package:flutter/material.dart';
import '../pages/home.dart';

class SleepProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF20223F),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xFF20223F), // Set background color to dark blue
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sebelum melanjutkan..',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            InfoItem(
              text:
                  'Sleepy Panda bertujuan untuk memberikan edukasi dan informasi. Sleepy Panda \nberusaha untuk memberikan pemahaman \nlebih tentang pola tidur kamu. Tetapi, \nSleepy Panda bukanlah alat diagnostik \natau pengganti konsultasi dengan dokter.',
            ),
            InfoItem(
              text:
                  'Profil tidur yang disediakan oleh Sleepy \nPanda berdasarkan data tidur yang kamu \nberikan, dan bertujuan untuk memberikan \nrekomendasi terkait pola tidur atau potensi \nkesehatan.',
            ),
            InfoItem(
              text:
                  'Kami selalu menyarankan untuk \nberkonsultasi dengan dokter atau ahli tidur \njika mengalami masalah tidur yang serius \natau berkelanjutan.',
            ),
            InfoItem(
              text: 'Hasil profil tidur dapat berubah seiring \nwaktu.',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Center(
                  child: Container(
                    height: 50,
                    width: 350,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SleepProfileA()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00A99D), // Button color
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Ya, saya mengerti',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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

class InfoItem extends StatelessWidget {
  final String text;

  InfoItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/ceklis.png',
            width: 20,
            height: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: 'Urbanist'),
            ),
          ),
        ],
      ),
    );
  }
}

class SleepProfileA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      appBar: AppBar(
        backgroundColor: Color(0xFF20223F),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 40, left: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Profil Tidur Kamu',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 36,
            ),
            Container(
              height: 650,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF272E49),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/baik.png',
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(width: 10),
                      Text('Baik',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: RichText(
                        text: TextSpan(
                            text: 'Selamat, kamu memiliki profil tidur \nyang ',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: 15),
                            children: [
                          TextSpan(
                              text: 'baik',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: '!',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: 15),
                          )
                        ])),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Kamu dapat tidur dengan nyenyak \ndan tanpa atau dengan sedikit \ngangguan.',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Durasi tidur kamu memadai dan \nberkualitas. Profil tidur baik \nmengindikasikan kesehatan fisik dan \nmental yang stabil.',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text('Saran untuk kamu,',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Urbanist')),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InfoBaik(
                        text: 'Tetap jaga rutinitas tidur yang \nkonsisten.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InfoBaik(
                        text:
                            'Memastikan lingkungan tidur mu \nnyaman, gelap, sejuk, dan tenang.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InfoBaik(
                        text:
                            'Hindari penggunaan smartphone atau \nkomputer di tempat tidur.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InfoBaik(
                        text:
                            'Lakukan aktivitas fisik/olahraga secara \nteratur.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InfoBaik(
                        text:
                            'Mengatur pola makan yang tepat, \nhindari makan besar sebelum tidur.'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45),
              child: Center(
                child: Container(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SleepProfileB()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF009090),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Kembali ke Jurnal Tidur',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold)),
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

class InfoBaik extends StatelessWidget {
  final String text;

  InfoBaik({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/ceklis.png',
            width: 20,
            height: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: 'Urbanist'),
            ),
          ),
        ],
      ),
    );
  }
}

class SleepProfileB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      appBar: AppBar(
        backgroundColor: Color(0xFF20223F),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 40, left: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Profil Tidur Kamu',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 36,
            ),
            Container(
              height: 650,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF272E49),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/gangguan.png',
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(width: 10),
                      RichText(
                          text: TextSpan(
                              text: 'Potensi gangguan: ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Urbanist'),
                              children: [
                            TextSpan(
                                text: 'Sleep Apnea',
                                style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic))
                          ])),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: RichText(
                        text: TextSpan(
                            text: 'Kamu berpotensi memiliki gangguan:\n',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: 15),
                            children: [
                          TextSpan(
                              text: 'Sleep apnea',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic)),
                        ])),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Sleep apnea merupakan salah satu \nkondisi serius terhadap masalah tidur.',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Segera konsultasikan dengan dokter \natau ahli tidur agar kamu \nmendapatkan bantuan profesional.',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text('Saran untuk kamu,',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Urbanist')),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InfoApnea(
                        text:
                            'Segera konsultasikan dengan dokter \nuntuk diagnosis yang tepat.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InfoApnea(
                        text:
                            'Hindari alkohol, dan merokok, serta \nmempertimbangkan untuk tidur dalam \nposisi yang lebih baik, seperti tidur \nmiring'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InfoApnea(
                        text:
                            'Lakukan olahraga secara teratur, dan \nmenjaga pola makan yang seimbang.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InfoApnea(
                        text:
                            'Terus lakukan evaluasi dan \npemantauan berkala dengan dokter \natau ahli tidur untuk memastikan \nperubahan gaya hidup.'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45),
              child: Center(
                child: Container(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SleepProfileC()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF009090),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Kembali ke Jurnal Tidur',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold)),
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

class InfoApnea extends StatelessWidget {
  final String text;

  InfoApnea({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/ceklis.png',
            width: 20,
            height: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: 'Urbanist'),
            ),
          ),
        ],
      ),
    );
  }
}

class SleepProfileC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      appBar: AppBar(
        backgroundColor: Color(0xFF20223F),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 40, left: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Profil Tidur Kamu',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 36,
            ),
            Container(
              height: 650,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF272E49),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/gangguan.png',
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(width: 10),
                      RichText(
                          text: TextSpan(
                              text: 'Potensi gangguan: ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Urbanist'),
                              children: [
                            TextSpan(
                                text: 'Insomnia',
                                style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic))
                          ])),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: RichText(
                        text: TextSpan(
                            text: 'Kamu berpotensi memiliki gangguan:\n',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: 15),
                            children: [
                          TextSpan(
                              text: 'Insomnia',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic)),
                        ])),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Insomnia merupakan gangguan tidur \nyang melibatkan kesulitan tidur atau \nsering terbangun di tengah malam.',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Segera konsultasikan dengan dokter \natau ahli tidur agar kamu \nmendapatkan bantuan profesional.',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text('Saran untuk kamu,',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Urbanist')),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InfoInsomnia(
                        text:
                            'Mengatur rutinitas tidur yang konsisten. \nMenerapkan jadwal tidur yang tepat, \ndan hindari tidur siang yang berlebihan.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InfoInsomnia(
                        text:
                            'Menghindari kafein, alkohol, dan \nmakanan berat beberapa jam sebelum \ntidur.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InfoInsomnia(
                        text:
                            'Melakukan aktivitas yang \nmenenangkan seperti membaca buku, \natau meditasi.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InfoInsomnia(
                        text:
                            'Jika berlanjut, lakukan konsultasi \ndengan dokter untuk mencari \npenyebab dan pengobatan yang \nsesuai.'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45),
              child: Center(
                child: Container(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF009090),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Kembali ke Jurnal Tidur',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold)),
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

class InfoInsomnia extends StatelessWidget {
  final String text;

  InfoInsomnia({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/ceklis.png',
            width: 20,
            height: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: 'Urbanist'),
            ),
          ),
        ],
      ),
    );
  }
}
