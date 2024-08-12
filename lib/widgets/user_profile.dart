import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Userprofile extends StatefulWidget {
  final String email;

  const Userprofile({super.key, required this.email});

  @override
  _UserprofileState createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/user-profile?email=${widget.email}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          nameController.text = data['name'] ?? 'N/A';
          emailController.text = data['email'] ?? 'N/A';
          genderController.text = data['gender'] ?? 'N/A';

          // Convert date of birth to format dd/MM/yyyy
          if (data['date_of_birth'] != null) {
            DateTime dob = DateTime.parse(data['date_of_birth']);
            dobController.text = DateFormat('dd/MM/yyyy').format(dob);
          } else {
            dobController.text = 'N/A';
          }

          isLoading = false;
        });
      } else {
        print('Failed to load user data');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/user-profile/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': widget.email,
          'name': nameController.text,
          'gender': genderController.text,
          'date_of_birth': DateFormat('yyyy-MM-dd')
              .format(DateFormat('dd/MM/yyyy').parse(dobController.text)),
        }),
      );

      if (response.statusCode == 200) {
        print('User data updated successfully');
        Navigator.pop(context); // Navigate back to the previous screen
      } else {
        print('Failed to update user data');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF20223F),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: EdgeInsets.all(screenSize.width * 0.04),
                children: [
                  CircleAvatar(
                    radius: screenSize.width * 0.1,
                    backgroundColor: Colors.grey,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  buildProfileItem('assets/images/detil.png', 'Nama',
                      nameController, true, screenSize),
                  buildProfileItem('assets/images/email.png', 'Email',
                      emailController, true, screenSize),
                  buildProfileItem('assets/images/dob.png', 'Gender',
                      genderController, false, screenSize),
                  buildProfileItem('assets/images/calendar.png',
                      'date_of_birth', dobController, false, screenSize),
                  SizedBox(height: screenSize.height * 0.03),
                  Center(
                    child: SizedBox(
                      height: screenSize.height * 0.0625,
                      width: screenSize.width * 0.875,
                      child: ElevatedButton(
                        onPressed: () {
                          // Save action
                          updateUserData();
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
