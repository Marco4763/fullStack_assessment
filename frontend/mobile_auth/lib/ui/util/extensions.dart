import 'package:flutter/material.dart';

extension SizeExtension on BuildContext {
  double get width {
    return MediaQuery.of(this).size.width;
  }

  double get height {
    return MediaQuery.of(this).size.height;
  }
}

extension NavigationExtension on BuildContext {
  void push(Widget page) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void pushReplacement(Widget page) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void get pop {
    Navigator.of(this).pop();
  }
}

extension StrintExtension on String {
  String get filename {
    if(contains('https://firebasestorage.googleapis.com/v0/b/assessment-89831.appspot.com/o/thumbnails%2F')){
      String filename = replaceFirst('https://firebasestorage.googleapis.com/v0/b/assessment-89831.appspot.com/o/thumbnails%2F', '');
      return filename.split('?alt').first;
    }
    return this;
  }
}
