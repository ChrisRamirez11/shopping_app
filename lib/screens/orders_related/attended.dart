import 'package:app_tienda_comida/provider/orders_provider_supabase.dart';
import 'package:app_tienda_comida/screens/orders_related/orders_simple_dialog.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/widgets/loader.dart';
import 'package:flutter/material.dart';

import '../../utils/pdf.dart';

class AttendedOrder extends StatelessWidget {
  const AttendedOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: limitTimeCheck(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loader();
          } else {
            List<Map<String, dynamic>>? orderMap = snapshot.data;
            return ListView.builder(
              itemCount: orderMap!.length,
              itemBuilder: (context, index) =>
                  getListTile(context, orderMap[index]),
            );
          }
        },
      ),
    );
  }
}

getListTile(BuildContext context, Map<String, dynamic> orderMap) {
  DateTime date = DateTime.parse(orderMap['created_at']);
  if (!orderMap['attended']) return Container();

  return Card(
    child: SizedBox(
      height: 70,
      child: InkWell(
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
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long),
                  Text(
                    'ID: #${orderMap['id'].toString()}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30, child: VerticalDivider()),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month),
                  Text('${date.day}/${date.month}/${date.year}'),
                ],
              ),
            ),
            SizedBox(height: 30, child: VerticalDivider()),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () => getPDf(context, orderMap),
                icon: Icon(
                  Icons.open_in_new_outlined,
                  color: white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<List<Map<String, dynamic>>> limitTimeCheck() async {
  List<Map<String, dynamic>> orderMap =
      await OrdersProviderSupabase().getOrder();
  List<Map<String, dynamic>> newOrdersMap = [];

  for (var e in orderMap) {
    DateTime date = DateTime.parse(e['created_at']);
    DateTime limitDate = DateTime.now();
    final int limitDays = 14;
    if (limitDate.difference(date).inDays > limitDays && e['attended']) {
      await OrdersProviderSupabase().deleteOrder(e['id']);
    } else {
      newOrdersMap.add(e);
    }
  }

  return newOrdersMap;
}
