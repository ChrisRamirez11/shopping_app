import 'package:flutter/material.dart';

class SelectedValue extends ChangeNotifier{
  String selectedValue = 'Plus';

  changeValue(String value){
    selectedValue = value;
    notifyListeners();
  }
}