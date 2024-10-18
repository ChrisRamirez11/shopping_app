import 'package:flutter/material.dart';

Widget ordersSimpleDialog(BuildContext context, Map<String, dynamic> orderMap) {
  Size size = MediaQuery.of(context).size;
  List<dynamic> productsListMap = orderMap['products'];
  return SimpleDialog(
    contentPadding: EdgeInsets.all(10),
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(child: Text('Lista de la compra: ')),
      ),
      SizedBox(
          height: size.height * 0.60,
          width: size.width * 0.90,
          child: ListView.builder(
            itemCount: productsListMap.length,
            itemBuilder: (context, index) => ListTile(
              leading: Text(
                'X${productsListMap[index]['quantity'].toString()}',
              ),
              title: Text(productsListMap[index]['name']),
              trailing:Text(productsListMap[index]['price'].toString())
            ),
          )), 
        Center(child: Text('Total: ${orderMap['total']}'))
    ],
  );
}
