import 'package:flutter/material.dart';

class SelectedValue extends ChangeNotifier {
  String _selectedValue = 'Plus';

  String get selectedValue => _selectedValue;

  changeValue(String value) {
    _selectedValue = value;
    notifyListeners();
  }
}
