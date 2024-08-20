import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sleepys/widgets/card_sleepprofile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MonthPage extends StatefulWidget {
  final String email;

  MonthPage({required this.email});

  @override
  _MonthPageState createState() => _MonthPageState();
}

Future<Map<String, dynamic>> fetchMonthlyData(
    String email, String startDate, String endDate) async {
  // Extracting month and year from the startDate for the query parameters
  DateTime startDateTime = DateTime.parse(startDate);
  String month = startDateTime.month
      .toString()
      .padLeft(2, '0'); // Ensure month is two digits
  String year = startDateTime.year.toString();

  // Constructing the URL with the required month and year parameters
  final url = Uri.parse(
      'http://localhost:8000/get-monthly-sleep-data/$email?start_date=$startDate&end_date=$endDate&month=$month&year=$year');

  final response = await http.get(url);

  print('Request URL: $url');
  print('Response Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
        'Failed to load sleep data: ${response.statusCode} - ${response.reasonPhrase}');
  }
}

class _MonthPageState extends State<MonthPage> {
  bool _isBackButtonPressed = false;
  bool _isNextButtonPressed = false;
  DateTime startDate =
      DateTime.now().subtract(Duration(days: DateTime.now().day - 1));
  Map<String, dynamic> monthlyData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    setState(() {
      isLoading = true; // Set loading to true before fetching data
    });

    try {
      DateTime endDate = DateTime(startDate.year, startDate.month + 1, 0);
      String startDateStr = DateFormat('yyyy-MM-dd').format(startDate);
      String endDateStr = DateFormat('yyyy-MM-dd').format(endDate);

      Map<String, dynamic> data =
          await fetchMonthlyData(widget.email, startDateStr, endDateStr);
      setState(() {
        monthlyData = data;
      });
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false; // Ensure loading is false after fetching
      });
    }
  }

  void _previousMonth() {
    setState(() {
      startDate = DateTime(startDate.year, startDate.month - 1, 1);
      _fetchData();
    });
  }

  void _nextMonth() {
    setState(() {
      startDate = DateTime(startDate.year, startDate.month + 1, 1);
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime endDate = DateTime(startDate.year, startDate.month + 1, 0);
    String year = DateFormat('yyyy').format(startDate);
    double baseFontSize = MediaQuery.of(context).size.width * 0.04;
    final dateFormat = DateFormat('MMMM', 'id');

    // Generate sleep data
    final sleepData = (monthlyData.containsKey('weekly_sleep_durations') &&
            monthlyData['weekly_sleep_durations'] is List)
        ? List<double>.generate(
            4,
            (index) => (monthlyData['weekly_sleep_durations'][index] ?? 0.0)
                .toDouble())
        : List<double>.filled(4, 0.0);

    final sleepStartTimes =
        (monthlyData.containsKey('weekly_sleep_start_times') &&
                monthlyData['weekly_sleep_start_times'] is Map)
            ? List<double?>.generate(4, (index) {
                List<dynamic>? times =
                    monthlyData['weekly_sleep_start_times'][index.toString()];
                if (times != null && times.isNotEmpty) {
                  String time = times[0] as String;
                  double hours = double.parse(time.split(":")[0]);
                  double minutes = double.parse(time.split(":")[1]) / 60;
                  return hours + minutes;
                } else {
                  return null; // Return null if there's no data
                }
              })
            : List<double?>.filled(
                4, null); // Use List<double?> for nullable values

    final wakeUpTimes = (monthlyData.containsKey('weekly_wake_times') &&
            monthlyData['weekly_wake_times'] is Map)
        ? List<double?>.generate(4, (index) {
            List<dynamic>? times =
                monthlyData['weekly_wake_times'][index.toString()];
            if (times != null && times.isNotEmpty) {
              String time = times[0] as String;
              double hours = double.parse(time.split(":")[0]);
              double minutes = double.parse(time.split(":")[1]) / 60;
              return hours + minutes;
            } else {
              return null; // Return null if there's no data
            }
          })
        : List<double?>.filled(
            4, null); // Use List<double?> for nullable values

    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFF20223F),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MonthlySleepProfile(
                email: widget.email,
                hasSleepData: monthlyData
                    .isNotEmpty, // Determine if the user has sleep data
              ),
              SizedBox(height: 10),
              Text(
                year,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: baseFontSize,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/back.png',
                      height: 35,
                      width: 35,
                      color: _isBackButtonPressed ? Colors.white : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isBackButtonPressed = !_isBackButtonPressed;
                        _isNextButtonPressed =
                            false; // Reset other button state
                        _previousMonth();
                      });
                    },
                  ),
                  Text(
                    dateFormat.format(startDate),
                    style: TextStyle(
                      fontSize: baseFontSize,
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/next.png',
                      height: 35,
                      width: 35,
                      color: _isNextButtonPressed ? Colors.white : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isNextButtonPressed = !_isNextButtonPressed;
                        _isBackButtonPressed =
                            false; // Reset other button state
                        _nextMonth();
                      });
                    },
                  ),
                ],
              ),
              monthlyData.isNotEmpty
                  ? SleepEntryGrid(monthlyData: monthlyData)
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Belum ada catatan tidur untuk minggu ini.',
                        style: TextStyle(
                          fontSize: baseFontSize,
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(right: 200, bottom: 20),
                child: Text(
                  'Durasi Tidur',
                  style: TextStyle(
                    fontSize: baseFontSize,
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF272E49)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(15),
                  child: monthlyData.isNotEmpty
                      ? MonthBarChart(
                          sleepData: sleepData,
                          startDate: startDate,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Belum ada catatan tidur untuk minggu ini.',
                            style: TextStyle(
                              fontSize: baseFontSize,
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(right: 200, top: 10),
                child: Text(
                  'Mulai Tidur',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: baseFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF272E49)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(15),
                  child: monthlyData.isNotEmpty
                      ? MonthLineChart(
                          data: sleepStartTimes,
                          startDate: startDate,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Belum ada catatan tidur untuk minggu ini.',
                            style: TextStyle(
                              fontSize: baseFontSize,
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 200, top: 10),
                child: Text(
                  'Bangun Tidur',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: baseFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF272E49)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(15),
                  child: monthlyData.isNotEmpty
                      ? MonthLineChart1(
                          data: wakeUpTimes,
                          startDate: startDate,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Belum ada catatan tidur untuk minggu ini.',
                            style: TextStyle(
                              fontSize: baseFontSize,
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

class SleepEntry extends StatelessWidget {
  final String title;
  final String value;
  final String content;
  final String imageAsset;

  SleepEntry({
    required this.title,
    required this.value,
    required this.content,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust sizes based on screen width
    final double imageHeight = screenWidth * 0.06; // 6% of screen width
    final double imageWidth = screenWidth * 0.06; // 6% of screen width
    final double fontSizeContent = screenWidth * 0.035; // 3.5% of screen width
    final double fontSizeTitle = screenWidth * 0.03; // 3% of screen width
    final double fontSizeValue = screenWidth * 0.03; // 3% of screen width

    final double imageTop = screenWidth * 0.05; // 5% of screen width
    final double imageLeft = screenWidth * 0.025; // 2.5% of screen width
    final double contentLeft = screenWidth * 0.1; // 10% of screen width
    final double contentTop = screenWidth * 0.0125; // 1.25% of screen width
    final double titleTop = screenWidth * 0.05; // 5% of screen width
    final double valueTop = screenWidth * 0.0875; // 8.75% of screen width

    return Card(
      color: Color(0xFF272E49),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.025), // 2.5% of screen width
        child: Stack(
          children: [
            Positioned(
              left: imageLeft,
              top: imageTop,
              child: Image.asset(
                imageAsset,
                height: imageHeight,
                width: imageWidth,
              ),
            ),
            Positioned(
              left: contentLeft,
              top: contentTop,
              child: Text(
                content,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontSize: fontSizeContent,
                ),
              ),
            ),
            Positioned(
              left: contentLeft,
              top: titleTop,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: fontSizeTitle,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
            Positioned(
              left: contentLeft,
              top: valueTop,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: fontSizeValue,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SleepEntryGrid extends StatelessWidget {
  final Map<String, dynamic> monthlyData;

  SleepEntryGrid({required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxItemWidth = constraints.maxWidth / 2 - 10;
        double itemHeight = maxItemWidth * 0.55;

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: maxItemWidth,
                childAspectRatio: maxItemWidth / itemHeight,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return SleepEntry(
                      content: 'Average',
                      title: 'Durasi tidur',
                      value: monthlyData['avg_duration'] ?? 'N/A',
                      imageAsset: 'assets/images/clock.png',
                    );
                  case 1:
                    return SleepEntry(
                      content: 'Total',
                      title: 'Durasi tidur',
                      value: monthlyData['total_duration'] ?? 'N/A',
                      imageAsset: 'assets/images/wakeup.png',
                    );
                  case 2:
                    return SleepEntry(
                      content: 'Average',
                      title: 'Mulai tidur',
                      value: monthlyData['avg_sleep_time'] ?? 'N/A',
                      imageAsset: 'assets/images/bed.png',
                    );
                  case 3:
                    return SleepEntry(
                      content: 'Average',
                      title: 'Bangun tidur',
                      value: monthlyData['avg_wake_time'] ?? 'N/A',
                      imageAsset: 'assets/images/sun.png',
                    );
                  default:
                    return SizedBox.shrink();
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class MonthBarChart extends StatefulWidget {
  final List<double> sleepData;
  final DateTime startDate;

  MonthBarChart({required this.sleepData, required this.startDate});

  @override
  _MonthBarChartState createState() => _MonthBarChartState();
}

class _MonthBarChartState extends State<MonthBarChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double chartWidth = constraints.maxWidth * 0.9;
        double chartHeight = constraints.maxHeight * 0.5;
        double barWidth =
            chartWidth / (4 * 1.5); // 4 minggu dengan jarak antar bar

        if (constraints.maxHeight.isInfinite) {
          chartHeight = 200;
        }

        double fontSize = MediaQuery.of(context).size.width * 0.02;

        double minY = 40.0;
        double maxY = 90.0;

        return Center(
          child: SizedBox(
            width: chartWidth,
            height: chartHeight,
            child: BarChart(
              BarChartData(
                barGroups: _createBarGroups(barWidth),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        String weekText = 'Week ${value.toInt() + 1}';
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(weekText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: fontSize)),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10, // Menampilkan setiap interval 5 jam
                      getTitlesWidget: (value, meta) {
                        if (value < 40 || value > 90) return Container();

                        String hourText = '${value.toInt()}j';
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(hourText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: fontSize)),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                barTouchData: BarTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (response != null && response.spot != null) {
                        touchedIndex = response.spot!.touchedBarGroupIndex;
                      } else {
                        touchedIndex = -1;
                      }
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: EdgeInsets.all(5),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()}j',
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                minY: minY, // Set minY ke 40j
                maxY: maxY, // Set maxY ke 65j
              ),
            ),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _createBarGroups(double barWidth) {
    return List.generate(4, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: widget.sleepData[index],
            color: index == touchedIndex
                ? Colors.red
                : Color(0xFF60354A), // Mengubah warna saat disentuh
            width: barWidth,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ],
      );
    });
  }
}

class MonthLineChart extends StatefulWidget {
  final List<double?>
      data; // Nullable double untuk mengindikasikan ketiadaan data
  final DateTime startDate; // Tambahkan startDate

  MonthLineChart({required this.data, required this.startDate});

  @override
  _MonthLineChartState createState() => _MonthLineChartState();
}

class _MonthLineChartState extends State<MonthLineChart> {
  @override
  Widget build(BuildContext context) {
    print("Line Chart Data: ${widget.data}"); // Debug print

    // Rentang waktu tetap: dari jam 20:00 hingga 01:00 (keesokan harinya)
    final double minY = 20.0; // 20:00 (8 PM)
    final double maxY =
        25.0; // 25:00 yang berarti 01:00 (1 AM keesokan harinya)

    return LayoutBuilder(
      builder: (context, constraints) {
        double chartWidth =
            constraints.maxWidth * 0.9; // 90% dari lebar yang tersedia
        double chartHeight =
            constraints.maxHeight * 0.5; // 50% dari tinggi yang tersedia

        if (constraints.maxHeight.isInfinite) {
          chartHeight = 200;
        }

        double fontSize = MediaQuery.of(context).size.width * 0.02;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: chartWidth,
            height: chartHeight,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: false,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          String weekText = '';
                          if (value == 0) {
                            weekText = 'Week 1';
                          } else if (value == 1) {
                            weekText = 'Week 2';
                          } else if (value == 2) {
                            weekText = 'Week 3';
                          } else if (value == 3) {
                            weekText = 'Week 4';
                          }

                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0), // Adjust this value as needed
                            child: Text(
                              weekText,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: fontSize,
                              ),
                            ),
                          );
                        }),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 1, // Interval dalam 1 jam
                      getTitlesWidget: (value, meta) {
                        int hours = value.toInt();
                        int minutes = ((value - hours) * 60).toInt();

                        // Konversi 24-25 ke 00-01 untuk visualisasi
                        if (hours >= 24) {
                          hours -= 24;
                        }

                        String text =
                            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(text,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: fontSize,
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                  border: Border.all(
                    color: const Color(0xff37434d),
                  ),
                ),
                minX: 0,
                maxX:
                    3, // Ubah maxX menjadi 3 untuk menampilkan 4 minggu (0, 1, 2, 3)
                minY: minY, // Dari 20:00 (8 PM)
                maxY: maxY, // Hingga 25:00 (01:00 keesokan harinya)
                lineBarsData: [
                  LineChartBarData(
                    spots: _createSpots(), // Generate spots berdasarkan data
                    isCurved: false,
                    color: Color(0xFFFF5999),
                    barWidth: 2,
                    isStrokeCapRound: false,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (FlSpot spot, double xPercentage,
                          LineChartBarData bar, int index) {
                        return FlDotCirclePainter(
                          radius: 2,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Color.fromARGB(255, 255, 255, 255),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                    preventCurveOverShooting: true,
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        int hours = spot.y.toInt();
                        int minutes = ((spot.y - hours) * 60).toInt();

                        // Konversi 24-25 ke 00-01 untuk visualisasi
                        if (hours >= 24) {
                          hours -= 24;
                        }

                        String timeText =
                            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

                        return LineTooltipItem(
                          '$timeText\n',
                          const TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<FlSpot> _createSpots() {
    double minY = 20.0; // 20:00 (8 PM)
    double maxY = 25.0; // 25:00 yang berarti 01:00 (1 AM keesokan harinya)

    List<FlSpot> spots = [];

    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i] != null) {
        double yValue = widget.data[i]!;
        if (yValue < 6) {
          yValue += 24; // Tambahkan 24 jika waktu setelah tengah malam
        }

        // Debug output untuk memeriksa nilai y
        print('Hari ke-$i (index $i): yValue = $yValue');

        if (yValue >= minY && yValue <= maxY) {
          spots.add(FlSpot(i.toDouble(), yValue));
        }
      }
    }

    // Menangani kasus ketika hanya ada satu titik di dalam rentang
    if (spots.length == 1) {
      spots.add(FlSpot(spots[0].x + 0.1, spots[0].y));
    }

    return spots;
  }
}

class MonthLineChart1 extends StatefulWidget {
  final List<double?> data;
  final DateTime startDate;

  MonthLineChart1({required this.data, required this.startDate});

  @override
  _MonthLineChart1State createState() => _MonthLineChart1State();
}

class _MonthLineChart1State extends State<MonthLineChart1> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double chartWidth = constraints.maxWidth * 0.9; // 90% of available width
      double chartHeight =
          constraints.maxHeight * 0.5; // 50% of available height

      if (constraints.maxHeight.isInfinite) {
        chartHeight = 200;
      }

      double fontSize = MediaQuery.of(context).size.width * 0.02;

      // Set minY and maxY to match the range from 06:00 to 12:00
      double minY = 6.0;
      double maxY = 12.0;

      // Generate the list of hours based on minY and maxY with a 1-hour interval
      List<double> yAxisLabels = [];
      for (double i = minY; i <= maxY; i += 1) {
        yAxisLabels.add(i);
      }

      return Padding(
        padding: const EdgeInsets.all(16), // Add padding for better spacing
        child: SizedBox(
          width: chartWidth, // Adjust the width as needed
          height: chartHeight, // Adjust the height as needed
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: false,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        String weekText = '';
                        if (value == 0) {
                          weekText = 'Week 1';
                        } else if (value == 1) {
                          weekText = 'Week 2';
                        } else if (value == 2) {
                          weekText = 'Week 3';
                        } else if (value == 3) {
                          weekText = 'Week 4';
                        }

                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0), // Adjust this value as needed
                          child: Text(
                            weekText,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: fontSize,
                            ),
                          ),
                        );
                      }),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 1, // Show every hour
                    getTitlesWidget: (value, meta) {
                      if (!yAxisLabels.contains(value)) return Container();

                      String hourText =
                          '${value.toInt().toString().padLeft(2, '0')}:00';
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(hourText,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: fontSize,
                              )),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false), // Hide top titles
                ),
                rightTitles: AxisTitles(
                  sideTitles:
                      SideTitles(showTitles: false), // Hide right titles
                ),
              ),
              borderData: FlBorderData(
                show: false,
                border: Border.all(
                  color: const Color(0xff37434d),
                ),
              ),
              minX: 0,
              maxX: 3, // 4 weeks (Week 0, Week 1, Week 2, Week 3)
              minY: minY, // Set minY to 06:00
              maxY: maxY, // Set maxY to 12:00
              lineBarsData: [
                LineChartBarData(
                  spots: _createSpots(),
                  isCurved: false,
                  color: Color(0xFFFFC754),
                  barWidth: 2,
                  isStrokeCapRound: false,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (FlSpot spot, double xPercentage,
                        LineChartBarData bar, int index) {
                      return FlDotCirclePainter(
                        radius: 2,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Color.fromARGB(255, 255, 255, 255),
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: false,
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      int hours = spot.y.toInt();
                      int minutes = ((spot.y - hours) * 60).toInt();

                      String timeText =
                          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

                      return LineTooltipItem(
                        '$timeText\n',
                        const TextStyle(
                          color: Color(0xFFFFC754),
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  List<FlSpot> _createSpots() {
    List<FlSpot> spots = [];

    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i] != null) {
        double yValue = widget.data[i]!;

        // Adjust yValue to fit within the 06:00 to 12:00 range
        if (yValue >= 0 && yValue < 6) {
          yValue += 24; // Shift times between 00:00 and 06:00 to after 24:00
        } else if (yValue > 12 && yValue < 24) {
          yValue -=
              24; // Shift times between 12:00 and 24:00 back to the 0-12 range
        }

        print(
            'Week $i: Adjusted yValue = $yValue'); // Debugging: see the yValue after adjustment
        spots.add(FlSpot(i.toDouble(), yValue));
      }
    }

    return spots;
  }
}
