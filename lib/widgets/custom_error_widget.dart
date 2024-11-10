import 'package:flutter/material.dart';

Widget custom_error_widget() {
  return Container(
    decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black26)]),
    width: double.infinity,
    height: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.all(50),
            child: Image.asset('assets/des/error.png')),
        // IconButton(
        //   style: ButtonStyle(
        //       shape: WidgetStatePropertyAll(RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10)))),
        //   icon: Icon(Icons.refresh),
        //   onPressed: () {
        //     provider.loadList();
        //   },
        // )
        Text('Ha ocurrido un error\nIntentelo mas tarde')
      ],
    ),
  );
}
