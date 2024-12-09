import 'package:flutter/material.dart';

class BottomNavBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updatedIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // Notify listeners to rebuild
  }
}
