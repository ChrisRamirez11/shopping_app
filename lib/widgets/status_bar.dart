import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:flutter/material.dart';

class ConectionAppBar extends StatefulWidget {
  const ConectionAppBar({super.key});

  @override
  State<ConectionAppBar> createState() => _ConectionAppBarState();
}

class _ConectionAppBarState extends State<ConectionAppBar> {
  @override
  Widget build(BuildContext context) {
    return ConnectionStatusBar(
     height : 25, // double: default height
     width : double.maxFinite, // double: default width
     color : const Color.fromARGB(255, 255, 255, 255), // Color: default background color
     lookUpAddress : 'google.com', // TODO:String: default site to look up for checking internet connection
     endOffset : const Offset(0.0, 0.0), // Offset: default animation finish point offset
     beginOffset : const Offset(0.0, -1.0), // Offset: default animation start point offset
     animationDuration : const Duration(milliseconds: 200), // Duration: default animation duration
     // Text: default text
     title : const Text(
       'Please check your internet connection',
       style: TextStyle(color: Colors.white, fontSize: 14),
     ),
);
  }
}