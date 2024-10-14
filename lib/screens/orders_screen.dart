import 'package:app_tienda_comida/provider/orders_provider_supabase.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          foregroundColor: secondary,
          backgroundColor: primary,
        ),
        body: FutureBuilder(
          future: getOrder(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              final data = snapshot.data;
              return ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) => getListTile(data[index]),
              );
            }
          },
        ));
  }

  getListTile(Map<String, dynamic> data) {
    return Card(
        child: SizedBox(
      height: 70,
      child: ListTile(
        title: Text('ID del Pedido:'),
        subtitle: Text('#${data['id'].toString()}'),
        trailing: IconButton(
            onPressed: () => getPDf(context, data['id']),
            icon: Icon(Icons.download)),
        isThreeLine: true,
      ),
    ));
  }
}
