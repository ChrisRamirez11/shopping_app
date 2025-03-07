import 'package:app_tienda_comida/services/orders_provider_supabase.dart';
import 'package:app_tienda_comida/provider/product_list_provider.dart';
import 'package:app_tienda_comida/screens/orders_related/orders_simple_dialog.dart';
import 'package:app_tienda_comida/widgets/custom_future_builder.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:app_tienda_comida/widgets/custom_error_widget.dart';
import 'package:app_tienda_comida/widgets/custom_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/pdf.dart';

class UnattendedOrder extends StatefulWidget {
  const UnattendedOrder({super.key});

  @override
  State<UnattendedOrder> createState() => _UnattendedOrderState();
}

class _UnattendedOrderState extends State<UnattendedOrder> {
  @override
  Widget build(BuildContext context) {
    ProductsListNotifier productsListNotifier =
        Provider.of<ProductsListNotifier>(context);
    return Scaffold(
      body: FutureBuilder(
        future: limitTimeCheck(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return custom_loader_widget();
          } else if (snapshot.hasError) {
            return custom_error_widget();
          } else {
            List<Map<String, dynamic>>? orderMap = snapshot.data;
            return ListView.builder(
              itemCount: orderMap!.length,
              itemBuilder: (context, index) =>
                  getListTile(context, orderMap[index], productsListNotifier),
            );
          }
        },
      ),
    );
  }
}

getListTile(
    BuildContext context, Map<String, dynamic> orderMap, productsListNotifier) {
  DateTime date = DateTime.parse(orderMap['created_at']);
  if (orderMap['attended']) return Container();
  return Row(
    children: [
      Expanded(
          flex: 5,
          child: Card(
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
                            child: Text('Ha ocurrido un error'),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return snapshot.data!;
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
                          Expanded(flex: 1, child: Icon(Icons.calendar_month)),
                          Expanded(
                              flex: 2,
                              child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Text(
                                      '${date.day}/${date.month}/${date.year}'))),
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
      customFutureBuilder(
        child: Expanded(
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
                              productsListNotifier.loadList();
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
      )
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
