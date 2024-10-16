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
          future: OrdersProviderSupabase().getOrder(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              final OrderMap = snapshot.data;
              return ListView.builder(
                itemCount: OrderMap!.length,
                itemBuilder: (context, index) => getListTile(OrderMap[index]),
              );
            }
          },
        ));
  }

  getListTile(Map<String, dynamic> OrderMap) {
    DateTime date = DateTime.parse(OrderMap['created_at']);
    return Card(
        child: SizedBox(
      height: 70,
      child: ListTile(
        leading: SizedBox(width: 100,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: #${OrderMap['id'].toString()}', style: Theme.of(context).textTheme.bodyMedium,),
            ],
          ),
        ),
        title: Text('Fecha:'),
        subtitle:Text('${date.day}/${date.month}/${date.year}') ,
        trailing: IconButton(
            onPressed: () => getPDf(context, OrderMap),
            icon: Icon(Icons.download)),
        isThreeLine: true,
        onTap: () {
          //TODO SHOW DIALOG
        },
      ),
    ));
  }
}
