import 'package:flutter/material.dart';

Widget loader() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(padding: EdgeInsets.all(50),
          child: Image.asset('assets/des/loading.png')),
        CircularProgressIndicator()
      ],
    ),
  );
}
