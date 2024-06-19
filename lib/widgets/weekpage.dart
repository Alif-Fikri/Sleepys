import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../pages/home.dart';

class WeekPage extends StatefulWidget {
  @override
  _WeekPageState createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {
  bool _isBackButtonPressed = false;
  bool _isNextButtonPressed = false;
  DateTime startDate =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  void _previousWeek() {
    setState(() {
      startDate = startDate.subtract(Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      startDate = startDate.add(Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime endDate = startDate.add(Duration(days: 6));
    String year = DateFormat('yyyy').format(startDate);
    final sleepData = [4.0, 3.0, 10.0, 8.0, 7.0, 6.0, 2.0];
    final lineData = [21.00, 22.50, 21.40, 24.00, 22.40, 24.50, 25.10];
    final lineData1 = [09.00, 06.00, 07.00, 06.15, 07.10, 06.00, 09.00];

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Infoprofile(),
              SizedBox(height: 10),
              Text(
                year,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
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
                        _previousWeek();
                      });
                    },
                  ),
                  Text(
                    '${DateFormat('d MMM').format(startDate)} - ${DateFormat('d MMM').format(endDate)}',
                    style: TextStyle(
                      fontSize: 18,
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
                        _nextWeek();
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 250, // Provide a fixed height for GridView
                    child: SleepEntryGrid(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 250, bottom: 20),
                    child: Text(
                      'Durasi Tidur',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF272E49)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(30),
                      child: WeekBarChart(sleepData: sleepData),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 250, top: 10),
                    child: Text(
                      'Mulai Tidur',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF272E49)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(15),
                      child: SleepLineChart(data: lineData),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 250, top: 10),
                    child: Text(
                      'Bangun Tidur',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF272E49)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(10),
                      child: SleepLineChart1(data: lineData1),
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

class WeekBarChart extends StatelessWidget {
  final List<double> sleepData;

  WeekBarChart({required this.sleepData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: 200, // Define a fixed height for the chart
          child: BarChart(
            BarChartData(
              barGroups: _createBarGroups(),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return Text('Sen',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Urbanist'));
                        case 1:
                          return Text('Sel',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Urbanist'));
                        case 2:
                          return Text('Rab',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Urbanist'));
                        case 3:
                          return Text('Kam',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Urbanist'));
                        case 4:
                          return Text('Jum',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Urbanist'));
                        case 5:
                          return Text('Sab',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Urbanist'));
                        case 6:
                          return Text('Min',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Urbanist'));
                        default:
                          return Text('',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Urbanist'));
                      }
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}j',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Urbanist'));
                      }),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ), // Set to false to hide top titles
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ), // Set to false to hide right titles
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              barTouchData: BarTouchData(
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
            ),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _createBarGroups() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: sleepData[index],
            color: index == 3 ? Colors.red : Color(0xFF60354A),
            width: 35,
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

class SleepLineChart extends StatefulWidget {
  final List<double> data;

  SleepLineChart({required this.data});

  @override
  _SleepLineChartState createState() => _SleepLineChartState();
}

class _SleepLineChartState extends State<SleepLineChart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding for better spacing
      child: SizedBox(
        width: 300, // Adjust the width as needed
        height: 200, // Adjust the height as needed
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
                    String text;
                    switch (value.toInt()) {
                      case 0:
                        text = 'Sen';
                        break;
                      case 1:
                        text = 'Sel';
                        break;
                      case 2:
                        text = 'Rab';
                        break;
                      case 3:
                        text = 'Kam';
                        break;
                      case 4:
                        text = 'Jum';
                        break;
                      case 5:
                        text = 'Sab';
                        break;
                      case 6:
                        text = 'Min';
                        break;
                      default:
                        return Container();
                    }
                    return Text(text,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                        ));
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    String text;
                    switch (value.toInt()) {
                      case 20:
                        text = '20.00';
                        break;
                      case 21:
                        text = '21.00';
                        break;
                      case 22:
                        text = '22.00';
                        break;
                      case 23:
                        text = '23.00';
                        break;
                      case 24:
                        text = '24.00';
                        break;
                      case 25:
                        text = '01.00';
                        break;
                      default:
                        return Container();
                    }
                    return Text(text,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'Urbanist'));
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false), // Hide top titles
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false), // Hide right titles
              ),
            ),
            borderData: FlBorderData(
              show: false,
              border: Border.all(
                color: const Color(0xff37434d),
              ),
            ),
            minX: 0,
            maxX: 6,
            minY: 20, // Start from 20.00
            maxY: 25, // End at 25 (which is 01.00)
            lineBarsData: [
              LineChartBarData(
                spots: widget.data.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value);
                }).toList(),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SleepLineChart1 extends StatefulWidget {
  final List<double> data;

  SleepLineChart1({required this.data});

  @override
  _SleepLineChart1State createState() => _SleepLineChart1State();
}

class _SleepLineChart1State extends State<SleepLineChart1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding for better spacing
      child: SizedBox(
        width: 300, // Adjust the width as needed
        height: 200, // Adjust the height as needed
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
                    String text;
                    switch (value.toInt()) {
                      case 0:
                        text = 'Sen';
                        break;
                      case 1:
                        text = 'Sel';
                        break;
                      case 2:
                        text = 'Rab';
                        break;
                      case 3:
                        text = 'Kam';
                        break;
                      case 4:
                        text = 'Jum';
                        break;
                      case 5:
                        text = 'Sab';
                        break;
                      case 6:
                        text = 'Min';
                        break;
                      default:
                        return Container();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(text,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                          )),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    String text;
                    switch (value.toInt()) {
                      case 6:
                        text = '06:00';
                        break;
                      case 7:
                        text = '07:00';
                        break;
                      case 8:
                        text = '08:00';
                        break;
                      case 9:
                        text = '09:00';
                        break;
                      case 10:
                        text = '10:00';
                        break;
                      default:
                        return Container();
                    }
                    return Text(text,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'Urbanist'));
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false), // Hide top titles
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false), // Hide right titles
              ),
            ),
            borderData: FlBorderData(
              show: false,
              border: Border.all(
                color: const Color(0xff37434d),
              ),
            ),
            minX: 0,
            maxX: 6,
            minY: 6, // Start from 6.00
            maxY: 10, // End at 10.00
            lineBarsData: [
              LineChartBarData(
                spots: widget.data.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value);
                }).toList(),
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
    return Card(
      color: Color(0xFF272E49),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 20,
              child: Image.asset(
                imageAsset,
                height: 25,
                width: 25,
              ),
            ),
            Positioned(
              left: 30,
              top: 0,
              child: Text(
                content,
                style: TextStyle(color: Colors.white, fontFamily: 'Urbanist'),
              ),
            ),
            Positioned(
              left: 30,
              top: 15,
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'Urbanist'), // Reduced font size
              ),
            ), // Reduced spacing
            Positioned(
              left: 30,
              top: 33,
              child: Text(
                value,
                style: TextStyle(
                    fontSize: 14, // Reduced font size
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SleepEntryGrid extends StatelessWidget {
  final List<SleepEntry> sleepEntries = [
    SleepEntry(
      content: 'Average',
      title: 'Durasi tidur',
      value: '8 jam 2 menit',
      imageAsset: 'assets/images/clock.png',
    ),
    SleepEntry(
      content: 'Total',
      title: 'Durasi tidur',
      value: '60 jam 51 menit',
      imageAsset: 'assets/images/wakeup.png',
    ),
    SleepEntry(
      content: 'Average',
      title: 'Mulai tidur',
      value: '21:08',
      imageAsset: 'assets/images/bed.png',
    ),
    SleepEntry(
      content: 'Average',
      title: 'Bangun tidur',
      value: '06:30',
      imageAsset: 'assets/images/sun.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 5 / 3,
        ),
        itemCount: sleepEntries.length,
        itemBuilder: (context, index) {
          return GridTile(
            child: sleepEntries[index],
          );
        },
      ),
    );
  }
}
