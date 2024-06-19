import 'package:flutter/material.dart';
import 'package:sleepys/widgets/sleeppage.dart';
import '../widgets/weekpage.dart';
import '../widgets/monthpage.dart';
import '../widgets/profilepage.dart';
import '../widgets/sleepprofile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    JurnalTidurPage(),
    SleepPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      body: _widgetOptions.elementAt(_selectedIndex),
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
          selectedLabelStyle:
              TextStyle(color: Color(0xFF627EAE), fontFamily: 'Urbanist'),
          unselectedLabelStyle:
              TextStyle(color: Color(0xFF627EAE), fontFamily: 'Urbanist'),
          selectedIconTheme: IconThemeData(color: Color(0xFFFFC754)),
          unselectedIconTheme: IconThemeData(color: Color(0xFF627EAE)),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class JurnalTidurPage extends StatefulWidget {
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
        centerTitle: true, // Adding shadow to the app bar
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
          DailyPage(),
          WeekPage(),
          MonthPage(),
        ],
      ),
    );
  }
}

class DailyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF20223F),
      child: ListView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        children: [
          Infoprofile(),
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

class Infoprofile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                'Untuk hasil analisa yang lebih baik, akurat, dan \nbermanfaat. Profil tidur hanya bisa diakses \nsetelah kamu melakukan pelacakan tidur paling \ntidak 30 hari.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Urbanist',
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 20,
                    width: 120,
                    margin: EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF009090),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SleepProfile()));
                      },
                      child: Text(
                        'Lihat profil tidur',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: 10,
                        ),
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
    return Card(
      color: Color(0xFF272E49),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(color: Colors.white, fontFamily: 'Urbanist'),
                ),
                SizedBox(
                    height: 50), // Memberi jarak agar tidak tertabrak oleh ikon
              ],
            ),
            Positioned(
              left: 50,
              top: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Durasi tidur',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Urbanist'),
                  ),
                  Text(
                    duration,
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Urbanist'),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 40,
              top: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Waktu tidur',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Urbanist'),
                  ),
                  Text(
                    time,
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Urbanist'),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 15,
              top: 38,
              child: Image.asset(
                'assets/images/clock.png',
                height: 25,
                width: 25,
              ),
            ),
            Positioned(
              right: 123,
              top: 38,
              child: Image.asset(
                'assets/images/wakeup.png',
                height: 25,
                width: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
