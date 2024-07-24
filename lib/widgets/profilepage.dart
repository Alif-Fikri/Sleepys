import 'package:flutter/material.dart';
import '../pages/home.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = ProfileMainPage();
            break;
          case '/details':
            page = Userprofile();
            break;
          default:
            page = ProfileMainPage();
        }
        return MaterialPageRoute(builder: (_) => page);
      },
    );
  }
}

class ProfileMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF20223F),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          children: [
            CircleAvatar(
              radius: screenSize.width * 0.1,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: screenSize.width * 0.1,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            Divider(
              color: Colors.grey,
            ),
            Infoprofile(screenSize: screenSize),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenSize.height * 0.01,
                  horizontal: screenSize.width * 0.05),
              child: Card(
                color: Color(0xFF272E49),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenSize.width * 0.025),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Image.asset(
                        'assets/images/detil.png',
                        height: screenSize.width * 0.06,
                        width: screenSize.width * 0.06,
                      ),
                      title: Text('Detil profil',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.bold)),
                      trailing: Image.asset(
                        'assets/images/next.png',
                        height: screenSize.width * 0.08,
                        width: screenSize.width * 0.08,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/details');
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.15),
                      child: Divider(
                        color: Colors.grey,
                        height: 0,
                      ),
                    ),
                    ListTile(
                      leading: Image.asset(
                        'assets/images/terms.png',
                        height: screenSize.width * 0.06,
                        width: screenSize.width * 0.06,
                      ),
                      title: Text('Terms & Conditions',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.bold)),
                      trailing: Image.asset(
                        'assets/images/next.png',
                        height: screenSize.width * 0.08,
                        width: screenSize.width * 0.08,
                      ),
                      onTap: () {
                        // Add action for "Terms & Conditions"
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.15),
                      child: Divider(
                        color: Colors.grey,
                        height: 0,
                      ),
                    ),
                    ListTile(
                      leading: Image.asset(
                        'assets/images/feedback.png',
                        height: screenSize.width * 0.06,
                        width: screenSize.width * 0.06,
                      ),
                      title: Text('Feedback',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.bold)),
                      trailing: Image.asset(
                        'assets/images/next.png',
                        height: screenSize.width * 0.08,
                        width: screenSize.width * 0.08,
                      ),
                      onTap: () {
                        // Add action for "Feedback"
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: screenSize.height * 0.0625,
              width: screenSize.width * 0.8,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Logout',
                  style: TextStyle(
                      fontFamily: 'Urbanist',
                      color: Color(0xFF009090),
                      fontSize: screenSize.width * 0.05,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(screenSize.width * 0.025),
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

class Infoprofile extends StatelessWidget {
  final Size screenSize;

  Infoprofile({required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Your Infoprofile widget implementation here
      ],
    );
  }
}

class Userprofile extends StatelessWidget {
  const Userprofile({super.key});

  @override
  Widget build(BuildContext context) {
    return Detilprofile();
  }
}

class Detilprofile extends StatelessWidget {
  final TextEditingController nameController =
      TextEditingController(text: 'Ariane');
  final TextEditingController emailController =
      TextEditingController(text: 'ariane@mail.com');
  final TextEditingController genderController =
      TextEditingController(text: 'Female');
  final TextEditingController dobController =
      TextEditingController(text: '30 May 1994');

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF20223F),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(screenSize.width * 0.04),
          children: [
            CircleAvatar(
              radius: screenSize.width * 0.1,
              backgroundColor: Colors.grey,
            ),
            SizedBox(height: screenSize.height * 0.02),
            buildProfileItem('assets/images/detil.png', 'Nama', nameController,
                true, screenSize),
            buildProfileItem('assets/images/email.png', 'Email',
                emailController, true, screenSize),
            buildProfileItem('assets/images/dob.png', 'Gender',
                genderController, false, screenSize),
            buildProfileItem('assets/images/calendar.png', 'Date of birth',
                dobController, false, screenSize),
            SizedBox(height: screenSize.height * 0.03),
            Center(
              child: SizedBox(
                height: screenSize.height * 0.0625,
                width: screenSize.width * 0.875,
                child: ElevatedButton(
                  onPressed: () {
                    // Save action
                    print('Name: ${nameController.text}');
                    print('Email: ${emailController.text}');
                    print('Gender: ${genderController.text}');
                    print('DOB: ${dobController.text}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00ADB5),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(screenSize.width * 0.05),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.045,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget buildProfileItem(String imagePath, String label,
      TextEditingController controller, bool showPencilIcon, Size screenSize) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Urbanist',
                color: Colors.white,
                fontSize: screenSize.width * 0.035,
              ),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Container(
              width: screenSize.width *
                  0.875, // Make the TextField take the full width
              height: screenSize.height * 0.06875,
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {},
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF272E49),
                  hintText: label,
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(screenSize.width * 0.03),
                    child: Image.asset(
                      imagePath,
                      width: screenSize.width * 0.06,
                      height: screenSize.width * 0.06,
                      color: Colors.white,
                    ),
                  ),
                  suffixIcon: showPencilIcon
                      ? Padding(
                          padding: EdgeInsets.all(screenSize.width * 0.035),
                          child: Image.asset(
                            'assets/images/edit.png',
                            height: screenSize.width * 0.05,
                            width: screenSize.width * 0.05,
                            color: Colors.white,
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(screenSize.width * 0.025),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
