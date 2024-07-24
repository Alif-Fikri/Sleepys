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
    final dateFormat = DateFormat('d MMMM', 'id');
    double baseFontSize = MediaQuery.of(context).size.width * 0.04;

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
                        _previousWeek();
                      });
                    },
                  ),
                  Text(
                    '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
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
                        _nextWeek();
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
                  child: WeekBarChart(sleepData: sleepData),
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
                  child: SleepLineChart(data: lineData),
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
                  child: SleepLineChart1(data: lineData1),
                ),
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
        double chartWidth =
            constraints.maxWidth * 0.9; // 90% of available width
        double chartHeight =
            constraints.maxHeight * 0.5; // 50% of available height
        double barWidth = chartWidth / (6 * 1.5);

        if (constraints.maxHeight.isInfinite) {
          chartHeight = 200;
        }

        double fontSize = MediaQuery.of(context).size.width * 0.03;

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
                        switch (value.toInt()) {
                          case 0:
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Sen',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Urbanist',
                                      fontSize: fontSize)),
                            );
                          case 1:
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Sel',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Urbanist',
                                      fontSize: fontSize)),
                            );
                          case 2:
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Rab',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Urbanist',
                                      fontSize: fontSize)),
                            );
                          case 3:
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Kam',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Urbanist',
                                      fontSize: fontSize)),
                            );
                          case 4:
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Jum',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Urbanist',
                                      fontSize: fontSize)),
                            );
                          case 5:
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Sab',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Urbanist',
                                      fontSize: fontSize)),
                            );
                          case 6:
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Min',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Urbanist',
                                      fontSize: fontSize)),
                            );
                          default:
                            return Text('',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Urbanist'));
                        }
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          return FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('${value.toInt()}j',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Urbanist',
                                    fontSize: fontSize)),
                          );
                        }),
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
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _createBarGroups(double barWidth) {
    return List.generate(7, (index) {
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

class SleepLineChart extends StatefulWidget {
  final List<double> data;

  SleepLineChart({required this.data});

  @override
  _SleepLineChartState createState() => _SleepLineChartState();
}

class _SleepLineChartState extends State<SleepLineChart> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double chartWidth =
            constraints.maxWidth * 0.9; // 90% of available width
        double chartHeight =
            constraints.maxHeight * 0.5; // 50% of available height

        if (constraints.maxHeight.isInfinite) {
          chartHeight = 200;
        }

        double fontSize = MediaQuery.of(context).size.width * 0.03;

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
                        return FittedBox(
                          fit: BoxFit.scaleDown,
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
      },
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
    return LayoutBuilder(
      builder: (context, constraints) {
        double chartWidth =
            constraints.maxWidth * 0.9; // 90% of available width
        double chartHeight =
            constraints.maxHeight * 0.5; // 50% of available height

        if (constraints.maxHeight.isInfinite) {
          chartHeight = 200;
        }

        double fontSize = MediaQuery.of(context).size.width * 0.03;

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
                        return FittedBox(
                          fit: BoxFit.scaleDown,
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
                          default:
                            return Container();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 15), // Adjust padding as needed
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
      },
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
