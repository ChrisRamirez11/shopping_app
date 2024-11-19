import 'package:flutter/material.dart';

Widget customLoaderWidget() {
  return Center( // Centra todo el contenido en la pantalla
    child: Container(
      decoration: const BoxDecoration(boxShadow: [BoxShadow(color: Colors.black26)]),
      width: 300, 
      height: 300, 
      child: SingleChildScrollView( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20), 
              constraints: const BoxConstraints(
                maxHeight:300, 
                maxWidth: 300, 
              ),
              child: Image.asset('assets/images/loading.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: 20), 
            const CircularProgressIndicator(),
          ],
        ),
      ),
    ),
  );
}