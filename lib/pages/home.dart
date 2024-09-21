import 'package:flutter/material.dart';
import 'package:sleepys/pages/data_user/bloodpressure.dart';
import 'package:sleepys/widgets/dailypage.dart';
import 'weekchart/weekpage.dart';
import 'monthchart/monthpage.dart';
import '../widgets/profilepage.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  final String userEmail;

  HomePage({required this.userEmail});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  DateTime? _lastBackPressed;

  @override
  void initState() {
    super.initState();
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

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    // Check if the back button is pressed twice within 2 seconds
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > Duration(seconds: 2)) {
      _lastBackPressed = now;
      // Show a message to press again to exit
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return Future.value(false); // Don't exit the app yet
    }
    return Future.value(true); // Exit the app if pressed twice
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Attach the back button handler
      child: Scaffold(
        backgroundColor: Color(0xFF20223F),
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
