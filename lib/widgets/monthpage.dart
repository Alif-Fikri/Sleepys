import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../pages/home.dart';

class MonthPage extends StatefulWidget {
  @override
  _MonthPageState createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  bool _isBackButtonPressed = false;
  bool _isNextButtonPressed = false;
  DateTime startDate =
      DateTime.now().subtract(Duration(days: DateTime.now().day - 1));

  void _previousMonth() {
    setState(() {
      startDate = DateTime(startDate.year, startDate.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      startDate = DateTime(startDate.year, startDate.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime endDate = DateTime(startDate.year, startDate.month + 1, 0);
    String year = DateFormat('yyyy').format(startDate);
    final sleepData = [62.0, 54.0, 60.0, 65.0];
    final lineData = [20.20, 23.10, 22.40, 24.50, 25.10];
    final lineData1 = [06.00, 07.45, 06.00, 08.30];
    double baseFontSize = MediaQuery.of(context).size.width * 0.04;
    final dateFormat = DateFormat('MMMM', 'id');

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
              SleepEntryGrid(),
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
                  child: MonthBarChart(sleepData: sleepData),
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
                  child: MonthLineChart(data: lineData),
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
                  child: MonthLineChart1(data: lineData1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MonthBarChart extends StatelessWidget {
  final List<double> sleepData;

  MonthBarChart({required this.sleepData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double chartWidth =
            constraints.maxWidth * 0.9; // 90% of available width
        double chartHeight =
            constraints.maxHeight * 0.5; // 50% of available height
        double barWidth = chartWidth / (4 * 1.5);
        double fontSize = MediaQuery.of(context).size.width * 0.03;

        if (constraints.maxHeight.isInfinite) {
          chartHeight = 200;
        }

        return SizedBox(
          width: constraints.maxWidth,
          height: chartHeight, // Use calculated chartHeight
          child: BarChart(
            BarChartData(
              barGroups: _createBarGroups(barWidth),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return Text('Week 1',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize:
                                      fontSize)); // Use calculated fontSize
                        case 1:
                          return Text('Week 2',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: fontSize));
                        case 2:
                          return Text('Week 3',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: fontSize));
                        case 3:
                          return Text('Week 4',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: fontSize));
                        default:
                          return Text('',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: fontSize));
                      }
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 40:
                          return Text(
                            '40j',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: fontSize *
                                  0.8, // Adjust for better readability
                            ),
                            textAlign: TextAlign.center,
                          );
                        case 45:
                          return Text(
                            '45j',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: fontSize * 0.8,
                            ),
                            textAlign: TextAlign.center,
                          );
                        case 50:
                          return Text(
                            '50j',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: fontSize * 0.8,
                            ),
                            textAlign: TextAlign.center,
                          );
                        case 55:
                          return Text(
                            '55j',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: fontSize * 0.8,
                            ),
                            textAlign: TextAlign.center,
                          );
                        case 60:
                          return Text(
                            '60j',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: fontSize * 0.8,
                            ),
                            textAlign: TextAlign.center,
                          );
                        case 65:
                          return Text(
                            '65j',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: fontSize * 0.8,
                            ),
                            textAlign: TextAlign.center,
                          );
                        default:
                          return Container();
                      }
                    },
                    reservedSize:
                        40, // Ensure there's enough space for the text
                  ),
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
                        fontSize: fontSize, // Use calculated fontSize
                      ),
                    );
                  },
                ),
              ),
              maxY: 65, // Set slightly higher to ensure space for the top label
              minY:
                  35, // Set slightly lower to ensure space for the bottom label
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
            toY: sleepData[index],
            color: index == 3 ? Colors.red : Color(0xFF60354A),
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
  final List<double> data;

  MonthLineChart({required this.data});

  @override
  _MonthLineChartState createState() => _MonthLineChartState();
}

class _MonthLineChartState extends State<MonthLineChart> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double chartWidth =
            constraints.maxWidth * 0.9; // 90% of available width
        double chartHeight =
            constraints.maxHeight * 0.5; // 50% of available height
        double fontSize = MediaQuery.of(context).size.width * 0.03;

        if (constraints.maxHeight.isInfinite) {
          chartHeight = 200;
        }

        return Padding(
          padding: const EdgeInsets.all(16.0), // Add padding for better spacing
          child: SizedBox(
            width: chartWidth, // Use calculated chartWidth
            height: chartHeight, // Use calculated chartHeight
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
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        String text;
                        switch (value.toInt()) {
                          case 0:
                            text = 'Week 1';
                            break;
                          case 1:
                            text = 'Week 2';
                            break;
                          case 2:
                            text = 'Week 3';
                            break;
                          case 3:
                            text = 'Week 4';
                            break;
                          default:
                            return Container();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 30), // Add padding to the top
                          child: Text(
                            text,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: fontSize, // Use calculated fontSize
                            ),
                          ),
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
                        return Text(
                          text,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                            fontSize:
                                fontSize * 0.8, // Adjust for better readability
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles:
                        SideTitles(showTitles: false), // Hide top titles
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
                maxX: 4, // Change maxX to 3 to show 4 weeks (0, 1, 2, 3)
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
      },
    );
  }
}

class MonthLineChart1 extends StatefulWidget {
  final List<double> data;

  MonthLineChart1({required this.data});

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
      double fontSize = MediaQuery.of(context).size.width * 0.03;

      if (constraints.maxHeight.isInfinite) {
        chartHeight = 200;
      }

      return Padding(
        padding: const EdgeInsets.all(16.0), // Add padding for better spacing
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
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      String text;
                      switch (value.toInt()) {
                        case 0:
                          text = 'Week 1';
                          break;
                        case 1:
                          text = 'Week 2';
                          break;
                        case 2:
                          text = 'Week 3';
                          break;
                        case 3:
                          text = 'Week 4';
                          break;
                        default:
                          return Container();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 30), // Add padding to the top
                        child: Text(text,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: fontSize,
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
                        case 11:
                          text = '11:00';
                          break;
                        default:
                          return Container();
                      }
                      return Text(text,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize * 0.8,
                              fontFamily: 'Urbanist'));
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
              maxX: 4,
              minY: 6, // Start from 20.00
              maxY: 11, // End at 25 (which is 01.00)
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
    });
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
      value: '240 jam 51 menit',
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
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxItemWidth =
            constraints.maxWidth / 2 - 10; // 2 items per row with spacing
        double itemHeight =
            maxItemWidth * 0.55; // Adjust the aspect ratio as needed

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
              itemCount: sleepEntries.length,
              itemBuilder: (context, index) {
                return sleepEntries[index];
              },
            ),
          ),
        );
      },
    );
  }
}
