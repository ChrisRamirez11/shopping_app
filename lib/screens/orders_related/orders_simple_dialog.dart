import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/theme.dart';

Future<Widget> orderSimpleDialog(
    BuildContext context, Map<String, dynamic> orderMap) async {
  final theme = Theme.of(context).textTheme;
  Size size = MediaQuery.of(context).size;
  List<dynamic> productsListMap = orderMap['products'];
  return SimpleDialog(
    contentPadding: EdgeInsets.all(10),
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: getTexts('Pedido #${orderMap['id']}',
              Theme.of(context).textTheme.bodyMedium),
        ),
      ),
      await clientData(context, orderMap),
      Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
          children: [
            Icon(
              Icons.receipt_long,
              color: primary,
            ),
            Text(
              ' Lista de la compra: ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      SizedBox(
          height: size.height * 0.40,
          width: size.width * 0.90,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 10),
            itemCount: productsListMap.length,
            itemBuilder: (context, index) => ListTile(
                leading: getTexts(
                    'X${productsListMap[index]['quantity'].toString()}',
                    theme.labelSmall),
                title:
                    getTexts(productsListMap[index]['name'], theme.labelSmall),
                trailing: getTexts(productsListMap[index]['price'].toString(),
                    theme.labelSmall)),
          )),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.price_check,
            color: greenCustom,
          ),
          Text(
            'Total: ${orderMap['total']}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}

Future<Widget> clientData(
    BuildContext context, Map<String, dynamic> orderMap) async {
  final themeCust = Theme.of(context).textTheme;
  final userMap = await _getProfile(orderMap);
  String cellphone = userMap['cellphone'].toString();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(Icons.assignment_ind),
          getTexts('Cliente: ', themeCust.bodySmall),
          Expanded(
              flex: 1,
              child: Tooltip(
                  message: '${userMap['fullName']}',
                  child: getTexts(
                      '${userMap['fullName']}',
                      themeCust.labelSmall!
                          .copyWith(overflow: TextOverflow.ellipsis))))
        ],
      ),
      Row(
        children: [
          Icon(Icons.phone),
          FittedBox(
            child: getTexts('Telèfono: ', themeCust.bodySmall),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: SelectableText(
                  style: TextStyle(
                      fontSize: themeCust.labelMedium!.fontSize,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.underline),
                  '$cellphone', onTap: () {
                Clipboard.setData(ClipboardData(text: cellphone));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Teléfono copiado al portapapeles')),
                );
              }),
            ),
          )
        ],
      ),
      Row(
        children: [
          Icon(Icons.apartment),
          getTexts('Direcciòn: ', themeCust.bodySmall),
          Expanded(
              flex: 1,
              child: Tooltip(
                  message: '${userMap['direction']}',
                  child: getTexts(
                      '${userMap['direction']}',
                      themeCust.labelSmall!
                          .copyWith(overflow: TextOverflow.ellipsis))))
        ],
      ),
    ],
  );
}

Future<Map<String, dynamic>> _getProfile(Map<String, dynamic> orderMap) async {
  try {
    final profile = await supabase
        .from('profiles')
        .select()
        .eq('id', orderMap['user_id'])
        .single();
    return profile;
  } on AuthException catch (error) {
    throw error.message;
  } catch (error) {
    throw 'Error inseperado ocurrido $error';
  }
}
