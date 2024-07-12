import 'package:app_tienda_comida/utils/theme.dart';
import 'package:flutter/material.dart';

class OnHoverProvider extends ChangeNotifier{
  bool onHover = false;
  Color primarycolor =Colors.red[900]!;
  Color secundarycolor=  Colors.red;
setColor(bool newOnHover){
   onHover = newOnHover;
notifyListeners();
}






}