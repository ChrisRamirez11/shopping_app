import 'dart:developer';

import 'package:app_tienda_comida/provider/orders_provider_supabase.dart';
import 'package:app_tienda_comida/screens/orders_simple_dialog.dart';
import 'package:app_tienda_comida/utils/pdf.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    String appBarTitle = 'Pedidos';
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              appBarTitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            foregroundColor: secondary,
            backgroundColor: primary,
          ),
          body: FutureBuilder(
            future: OrdersProviderSupabase().getOrder(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<Map<String, dynamic>>? orderMap = snapshot.data;
                orderMap = limitTimeCheck(orderMap!);
                return ListView.builder(
                  itemCount: orderMap!.length,
                  itemBuilder: (context, index) => getListTile(orderMap![index]),
                );
              }
            },
          )),
    );
  }

  getListTile(Map<String, dynamic> orderMap) {
    DateTime date = DateTime.parse(orderMap['created_at']);
    return Card(
        child: SizedBox(
      height: 70,
      child: ListTile(
        leading: SizedBox(
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID: #${orderMap['id'].toString()}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        title: Text('Fecha:'),
        subtitle: Text('${date.day}/${date.month}/${date.year}'),
        trailing: IconButton(
            onPressed: () => getPDf(context, orderMap),
            icon: Icon(Icons.open_in_new_outlined)),
        isThreeLine: true,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => FutureBuilder(
              future: orderSimpleDialog(context, orderMap),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Ha ocurrido un Error'),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return snapshot.requireData;
                }
              },
            ),
          );
        },
      ),
    ));
  }
}

List<Map<String, dynamic>> limitTimeCheck(List<Map<String, dynamic>> orderMap) {
  List<Map<String, dynamic>> newOrdersMap = [];
  
  for (var e in orderMap) {
    DateTime date = DateTime.parse(e['created_at']);
    DateTime limitDate = DateTime.now();
    final int limitDays = 14;
    if (limitDate.difference(date).inDays > limitDays) {
      OrdersProviderSupabase().deleteOrder(e['id']);
    } else {
      newOrdersMap.add(e);
    }
  }
  
  return newOrdersMap;
}
