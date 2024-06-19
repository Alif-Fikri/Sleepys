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
    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF20223F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Divider(
              color: Colors.grey,
            ),
            Infoprofile(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Card(
                color: Color(0xFF272E49),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Image.asset(
                        'assets/images/detil.png',
                        height: 25,
                        width: 25,
                      ),
                      title: Text('Detil profil',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      trailing: Image.asset(
                        'assets/images/next.png',
                        height: 35,
                        width: 35,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/details');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60, right: 20),
                      child: Divider(
                        color: Colors.grey,
                        height: 0,
                      ),
                    ),
                    ListTile(
                      leading: Image.asset(
                        'assets/images/terms.png',
                        height: 25,
                        width: 25,
                      ),
                      title: Text('Terms & Conditions',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      trailing: Image.asset(
                        'assets/images/next.png',
                        height: 35,
                        width: 35,
                      ),
                      onTap: () {
                        // Add action for "Terms & Conditions"
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60, right: 20),
                      child: Divider(
                        color: Colors.grey,
                        height: 0,
                      ),
                    ),
                    ListTile(
                      leading: Image.asset(
                        'assets/images/feedback.png',
                        height: 25,
                        width: 25,
                      ),
                      title: Text('Feedback',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      trailing: Image.asset(
                        'assets/images/next.png',
                        height: 35,
                        width: 35,
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
              height: 50,
              width: 360,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Logout',
                  style: TextStyle(
                      fontFamily: 'Urbanist',
                      color: Color(0xFF009090),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
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
    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF20223F),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
            ),
            SizedBox(height: 16),
            buildProfileItem(
                'assets/images/detil.png', 'Nama', nameController, true),
            buildProfileItem(
                'assets/images/email.png', 'Email', emailController, true),
            buildProfileItem(
                'assets/images/dob.png', 'Gender', genderController, false),
            buildProfileItem('assets/images/calendar.png', 'Date of birth',
                dobController, false),
            SizedBox(height: 24),
            Center(
              child: SizedBox(
                height: 50,
                width: 350,
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18,
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
      TextEditingController controller, bool showPencilIcon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Urbanist',
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 5),
            Container(
              width: 350, // Make the TextField take the full width
              height: 55,
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
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      imagePath,
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                  ),
                  suffixIcon: showPencilIcon
                      ? Padding(
                          padding: const EdgeInsets.all(19),
                          child: Image.asset(
                            'assets/images/edit.png',
                            height: 20,
                            width: 20,
                            color: Colors.white,
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
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
