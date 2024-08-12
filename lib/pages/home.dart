import 'package:flutter/material.dart';
import 'package:sleepys/widgets/bloodpressure.dart';
import 'package:sleepys/widgets/card_sleepprofile.dart';
import 'package:sleepys/widgets/sleeppage.dart';
import '../widgets/weekpage.dart';
import '../widgets/monthpage.dart';
import '../widgets/profilepage.dart';
import '../widgets/sleepprofile.dart';

class HomePage extends StatefulWidget {
  final String userEmail;

  HomePage({required this.userEmail});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    // Initialize the _widgetOptions list with the pages you want to display for each tab
    _widgetOptions = <Widget>[
      JurnalTidurPage(email: widget.userEmail), // Page for Jurnal Tidur
      Bloodpressure(email: widget.userEmail), // Page for Blood Pressure
      ProfilePage(email: widget.userEmail), // Page for Profile
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      // Display the selected page
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/book.png')),
              label: 'Jurnal Tidur',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/sleep.png')),
              label: 'Sleep',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/profile.png')),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          backgroundColor: Color(0xFF272E49),
          selectedItemColor: Colors.white,
          unselectedItemColor: Color(0xFF627EAE),
          selectedLabelStyle: TextStyle(
            color: Color(0xFF627EAE),
            fontFamily: 'Urbanist',
          ),
          unselectedLabelStyle: TextStyle(
            color: Color(0xFF627EAE),
            fontFamily: 'Urbanist',
          ),
          selectedIconTheme: IconThemeData(color: Color(0xFFFFC754)),
          unselectedIconTheme: IconThemeData(color: Color(0xFF627EAE)),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class JurnalTidurPage extends StatefulWidget {
  final String email;

  JurnalTidurPage({required this.email});

  @override
  _JurnalTidurPageState createState() => _JurnalTidurPageState();
}

class _JurnalTidurPageState extends State<JurnalTidurPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF20223F),
        title: Text(
          'Jurnal Tidur',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Urbanist',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Color(0xFF20223F),
                width: 0,
              ))),
              child: TabBar(
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                labelColor: Colors.white,
                labelStyle: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 15,
                ),
                unselectedLabelColor: Color(0xFFFBFBFB),
                unselectedLabelStyle:
                    TextStyle(fontFamily: 'Urbanist', fontSize: 15),
                tabs: [
                  Tab(
                    text: 'Daily',
                  ),
                  Tab(text: 'Week'),
                  Tab(text: 'Month'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DailyPage(email: widget.email), // Corrected email reference
          WeekPage(email: widget.email), // Corrected email reference
          MonthPage(email: widget.email), // Corrected email reference
        ],
      ),
    );
  }
}

class DailyPage extends StatelessWidget {
  final String email;

  DailyPage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF20223F),
      child: ListView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        children: [
          DailySleepProfile(email: email),
          SleepEntry(
            date: "14 Agustus 2023",
            duration: "7 jam 11 menit",
            time: "21:30 - 06:10",
          ),
          SleepEntry(
            date: "14 Agustus 2023",
            duration: "7 jam 15 menit",
            time: "22:00 - 06:15",
          ),
          // Add more SleepEntry widgets here...
        ],
      ),
    );
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

    // Adjust sizes based on screen width
    final double imageHeight = screenWidth * 0.05; // 5% of screen width
    final double imageWidth = screenWidth * 0.05; // 5% of screen width
    final double fontSizeTitle = screenWidth * 0.03; // 3% of screen width
    final double fontSizeValue = screenWidth * 0.025; // 2.5% of screen width
    final double imageTop = screenWidth * 0.065; // 6.5% of screen width
    final double imageLeft = screenWidth * 0.035; // 3.5% of screen width
    final double imageRight = screenWidth * 0.26;
    final double contentTop = screenWidth * 0.05; // 5% of screen width
    final double contentRight = screenWidth * 0.10; // 10% of screen width

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
                  height: screenWidth * 0.1, // Adjust height proportionally
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

