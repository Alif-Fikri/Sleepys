import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileImageProvider extends ChangeNotifier {
  File? _image;

  File? get image => _image;

  Future<void> loadImage(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('${email}_profile_image');
    if (imagePath != null) {
      _image = File(imagePath);
      notifyListeners();
    }
  }

  void updateImage(File? newImage) {
    _image = newImage;
    notifyListeners();
  }
}
