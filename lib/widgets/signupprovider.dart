import 'package:flutter/material.dart';

class SignupFormProvider extends ChangeNotifier {
  String _email = '';
  String _email1 = '';
  String _password = '';
  String _password1 = '';
  String _cpassword = '';

  String get email => _email;
  String get email1 => _email1;
  String get password => _password;
  String get password1 => _password1;
  String get cpassword => _cpassword;

  void updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void updatePassword(String password) {
    _password = password;
    notifyListeners();
  }

  void updatecPassword(String cpassword) {
    _cpassword = cpassword;
    notifyListeners();
  }

  void updateEmail1(String email1) {
    _email1 = email1;
    notifyListeners();
  }

  void updatePassword1(String password1) {
    _password1 = password1;
    notifyListeners();
  }
}
