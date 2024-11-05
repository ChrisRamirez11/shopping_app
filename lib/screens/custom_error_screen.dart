import 'package:app_tienda_comida/screens/home_screen.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomErrorScreen extends StatelessWidget {
  final String errorMsg;
  CustomErrorScreen({required this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          getColumn(context),
        ],
      ),
    ));
  }

  getColumn(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Container(
              height: 200,
              width: MediaQuery.sizeOf(context).width * 0.7,
              child: Image.asset(
                'assets/des/error.png',
                fit: BoxFit.fill,
              )),
          Spacer(),
          Text(
            'ERROR',
            style: TextStyle(fontSize: 30, color: white),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.4,
              width: MediaQuery.sizeOf(context).width,
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(errorMsg,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        )),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
          ElevatedButton(
              style: ButtonStyle(
                  elevation: WidgetStatePropertyAll(10),
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 50)),
                  backgroundColor: WidgetStatePropertyAll(primary)),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text('Menù Principal',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFCE3D5))),
              )),
          Spacer()
        ],
      ),
    );
  }
}
