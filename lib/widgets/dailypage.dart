import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import the intl package
import 'package:sleepys/widgets/card_sleepprofile.dart';

class DailyPage extends StatefulWidget {
  final String email;

  DailyPage({required this.email});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  late Future<List<Map<String, dynamic>>> sleepDataFuture;

  @override
  void initState() {
    super.initState();
    sleepDataFuture = fetchSleepData();
  }

  Future<List<Map<String, dynamic>>> getSleepData(String email) async {
    final url = Uri.parse('http://localhost:8000/get-sleep-records/$email');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengambil data sleep');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSleepData() async {
    try {
      final sleepData = await getSleepData(widget.email);
      print('Data received from API: $sleepData');

      // Ensure there is only one sleep record per day by using a map
      final Map<String, Map<String, dynamic>> uniqueData = {};

      for (var record in sleepData) {
        String date = record['date'];

        // If the date already exists, compare the time and keep the latest
        if (uniqueData.containsKey(date)) {
          DateTime existingTime = parseTime(uniqueData[date]!['time']);
          DateTime newTime = parseTime(record['time']);

          if (newTime.isAfter(existingTime)) {
            uniqueData[date] = record; // Replace with the newer record
          }
        } else {
          uniqueData[date] = record; // Add new date entry
        }
      }

      return uniqueData.values
          .toList(); // Convert the map values back to a list
    } catch (e) {
      print('Error fetching sleep data: $e');
      rethrow;
    }
  }

  DateTime parseTime(String timeString) {
    try {
      // Assuming timeString format is '02:17 - 07:00'
      final startTimeString = timeString.split(' - ')[0]; // Get the start time
      return DateFormat('HH:mm').parse(startTimeString); // Parse to DateTime
    } catch (e) {
      print('Error parsing time: $e');
      return DateTime.now(); // Fallback in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF20223F),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: sleepDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return ListView(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              children: [
                DailySleepProfile(
                  email: widget.email,
                  hasSleepData: false,
                ),
                Center(
                  child: Text(
                    'Gagal mengambil data tidur.\nMohon periksa koneksi internet Anda atau coba lagi nanti.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;

            // Parse and sort data to display the most recent first
            data.sort((a, b) {
              DateTime dateA = parseDate(a['date']);
              DateTime dateB = parseDate(b['date']);
              return dateB.compareTo(dateA);
            });

            bool hasSleepData = data.isNotEmpty;

            return ListView(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              children: [
                DailySleepProfile(
                  email: widget.email,
                  hasSleepData: hasSleepData,
                ),
                ...data.map((record) => SleepEntry(
                      date: record['date'] ?? 'Tanggal tidak tersedia',
                      duration: record['duration'] ?? 'Durasi tidak tersedia',
                      time: record['time'] ?? 'Waktu tidak tersedia',
                    )),
              ],
            );
          } else {
            return ListView(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              children: [
                DailySleepProfile(
                  email: widget.email,
                  hasSleepData: false,
                ),
                Center(
                  child: Text(
                    'Tidak ada data tidur yang ditemukan.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  DateTime parseDate(String dateString) {
    // Parse the date using the intl package
    try {
      final DateFormat dateFormat = DateFormat('d MMMM yyyy'); // '26 July 2024'
      return dateFormat.parse(dateString);
    } catch (e) {
      print('Error parsing date: $e');
      return DateTime.now(); // Fallback in case of an error
    }
  }
}

class SleepEntry extends StatelessWidget {
  final String date;
  final String duration;
  final String time;

  SleepEntry({
    required this.date,
    required this.duration,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final double imageHeight = screenWidth * 0.05;
    final double imageWidth = screenWidth * 0.05;
    final double fontSizeTitle = screenWidth * 0.03;
    final double fontSizeValue = screenWidth * 0.025;
    final double imageTop = screenWidth * 0.065;
    final double imageLeft = screenWidth * 0.032;
    final double imageRight = screenWidth * 0.27;
    final double contentTop = screenWidth * 0.05;
    final double contentRight = screenWidth * 0.10;

    return Card(
      color: Color(0xFF272E49),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                    fontSize: fontSizeTitle,
                  ),
                ),
                SizedBox(
                  height: screenWidth * 0.1,
                ),
              ],
            ),
            Positioned(
              left: contentRight,
              top: contentTop,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Durasi tidur',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: fontSizeTitle,
                    ),
                  ),
                  Text(
                    duration,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: fontSizeValue,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: contentRight,
              top: contentTop,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Waktu tidur',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: fontSizeTitle,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: fontSizeValue,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: imageLeft,
              top: imageTop,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/clock.png',
                    height: imageHeight,
                    width: imageWidth,
                  ),
                ],
              ),
            ),
            Positioned(
              right: imageRight,
              top: imageTop,
              child: Image.asset(
                'assets/images/wakeup.png',
                height: imageHeight,
                width: imageWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
