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
    return Scaffold(
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
              final OrderMap = snapshot.data;
              return ListView.builder(
                itemCount: OrderMap!.length,
                itemBuilder: (context, index) => getListTile(OrderMap[index]),
              );
            }
          },
        ));
  }

  getListTile(Map<String, dynamic> orderMap) {
    DateTime date = DateTime.parse(orderMap['created_at']);
    return Card(
        child: SizedBox(
      height: 70,
      child: ListTile(
        leading: SizedBox(width: 100,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: #${orderMap['id'].toString()}', style: Theme.of(context).textTheme.bodyMedium,),
            ],
          ),
        ),
        title: Text('Fecha:'),
        subtitle:Text('${date.day}/${date.month}/${date.year}') ,
        trailing: IconButton(
            onPressed: () => getPDf(context, orderMap),
            icon: Icon(Icons.download)),
        isThreeLine: true,
        onTap: () {
          showDialog(context: context, builder: (context) => FutureBuilder(future: ordersSimpleDialog(context, orderMap), builder: (context, snapshot) {
            if(snapshot.hasError){
          return const Center(child: Text('Ha ocurrido un Error'),);
        }
        else if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        else{
          return snapshot.requireData;
        }
          },),);
        },
      ),
    ));
  }
}
