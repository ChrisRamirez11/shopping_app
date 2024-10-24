import 'package:app_tienda_comida/provider/orders_provider_supabase.dart';
import 'package:app_tienda_comida/screens/orders_related/orders_simple_dialog.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../utils/pdf.dart';

class UnattendedOrder extends StatelessWidget {
  const UnattendedOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: limitTimeCheck(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
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
  if (orderMap['attended']) return Container();
  return Row(
    children: [
      Expanded(
        flex: 5,
        child: Card(
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
        )),
      ),
      //TODO DELETE FOR USERS APP and also delete the above row
      Expanded(
        flex: 1,
        child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: getTexts(
                      'Atendido?', Theme.of(context).textTheme.bodyLarge),
                  children: [
                    Center(
                      child: getTexts('Marcar orden como atenida?',
                          Theme.of(context).textTheme.labelMedium),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: getTexts('Cancelar',
                              Theme.of(context).textTheme.labelSmall),
                        ),
                        Expanded(child: Container()),
                        TextButton(
                          onPressed: () async {
                            await OrdersProviderSupabase()
                                .updateOrder(context, orderMap['id']);
                            Navigator.pop(context);
                          },
                          child: getTexts(
                              'Ok', Theme.of(context).textTheme.labelSmall),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
            icon: Icon(
              size: 35,
              color: Colors.green,
              Icons.check_circle_outline,
            )),
      ),
    ],
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
