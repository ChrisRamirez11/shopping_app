import 'package:app_tienda_comida/provider/orders_provider_supabase.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    String appBarTitle = 'Pedidos';
    return Scaffold(appBar: AppBar(
            title: Text(
              appBarTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            foregroundColor: secondary,
            backgroundColor: primary,),
      body: FutureBuilder(future: getOrder(context), builder: (context, snapshot) {
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }else{
          final data = snapshot.data;
          return ListView.builder(
            itemCount: data!.length,
            itemBuilder: (context, index) => getListTile(data[index]),);
        }
      },));
  }
  
  getListTile(Map<String, dynamic> data) {
    return ListTile(title: Text(data['id'].toString()),);
  }
}