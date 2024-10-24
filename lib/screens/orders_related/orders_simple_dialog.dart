import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/provider/get_profile.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Widget> orderSimpleDialog(
    BuildContext context, Map<String, dynamic> orderMap) async {
  final theme = Theme.of(context).textTheme;
  Size size = MediaQuery.of(context).size;
  List<dynamic> productsListMap = orderMap['products'];
  return SimpleDialog(
    contentPadding: EdgeInsets.all(10),
    children: [
      await getDataIfAdmin(context),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(child: Text('Lista de la compra: ')),
      ),
      SizedBox(
          height: size.height * 0.40,
          width: size.width * 0.90,
          child: ListView.builder(
            itemCount: productsListMap.length,
            itemBuilder: (context, index) => ListTile(
                leading: getTexts('X${productsListMap[index]['quantity'].toString()}', theme.labelSmall),
                title: getTexts(productsListMap[index]['name'], theme.labelSmall),
                trailing: getTexts(productsListMap[index]['price'].toString(), theme.labelSmall)),
          )),
          SizedBox(height: 10,),
      Center(child: Text('Total: ${orderMap['total']}')),
          SizedBox(height: 10,),
    ],
  );
}

Future<Widget> getDataIfAdmin(BuildContext context) async {
  try {
    final userId = await supabase.auth.currentUser!.id;
    final resp =
        await supabase.from('roles').select().eq('user_id', userId).single();
    if (resp['role'].toString() == 'admin') {
      return adminWidget(context);
    } else {
      return Container();
    }
  } on AuthException catch (error) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    });
    return Center();
  } catch (e) {
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Ha ocurrido un error: Vuelva a cargar la pàgina. $e')));
      },
    );
    return Center();
  }
}

Future<Widget> adminWidget(BuildContext context) async {
  final theme = Theme.of(context).textTheme;
  final userMap = await getProfile(context);
  String cellphone = userMap['cellphone'].toString();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      getTexts('Nombre del Cliente:', theme.bodyMedium),
      getTexts('${userMap['fullName']}', theme.labelMedium),

      getTexts('Telèfono de Contacto:', theme.bodyMedium),
      Container(
        child: SelectableText(
            style: TextStyle(color: Colors.blue.shade400, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),
            '$cellphone', onTap: () {
          Clipboard.setData(ClipboardData(text: cellphone));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Teléfono copiado al portapapeles')),
          );
        }),
      ),
      getTexts('Direcciòn del Cliente:', theme.bodyMedium),
      getTexts('${userMap['direction']}', theme.labelMedium),
    ],
  );
}
