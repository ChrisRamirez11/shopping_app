import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/provider/get_profile.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

const double inch = 72.0;
const double cm = inch / 2.54;

void getPDf(BuildContext context, Map<String, dynamic> orderMap) async {
  int orderId = orderMap['id'];
  List<dynamic> shoppingList = orderMap['products'];
  String total = orderMap['total'].toString();

  String userName = '', cellphone = '', direction = '';

  final pdf = pw.Document();

  final icon = pw.MemoryImage(
    (await rootBundle.load('assets/images/icon.png')).buffer.asUint8List(),
  );

  // Getting the user datas
  if (supabase.auth.currentSession != null) {
    final resp = await getProfile();
    userName = resp['fullName'];
    cellphone = resp['cellphone'];
    direction = resp['direction'];
  } else {
    return;
  }

  int itemsPerPage = 10;
  int totalProducts = shoppingList.length;

  for (int i = 0; i < totalProducts; i += itemsPerPage) {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Wrap(
                children: [
                  pw.Align(
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Image(icon, height: 100, width: 100),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.topLeft,
                    child: pw.Text('WHIM COLLECTIONS',
                        style: pw.TextStyle(
                            fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Text('Nombre del Cliente:',
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold)),
              pw.Text('${userName}', style: pw.TextStyle(fontSize: 15)),
              pw.Text('Direcciòn:',
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold)),
              pw.Text('${direction}', style: pw.TextStyle(fontSize: 15)),
              pw.Text('Telèfono de Contacto: ',
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold)),
              pw.Text('${cellphone}', style: pw.TextStyle(fontSize: 15)),

              pw.Divider(),

              pw.SizedBox(height: 20),
              pw.Text('Lista de la compra:',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              // Products Table
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  _buildTableHeader(),
                  ...shoppingList.skip(i).take(itemsPerPage).map((product) {
                    return _buildTableRow(product);
                  }).toList(),
                ],
              ),

              getFinalData(total, i, itemsPerPage, totalProducts)
            ],
          );
        },
      ),
    );
  }

  final output = await getDownloadsDirectory();
  final file = File("${output?.path}/$orderId.pdf");
  if (await file.exists()) {
    await OpenFile.open(file.path);
    return;
  }
  await file.writeAsBytes(await pdf.save());
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    action: SnackBarAction(
        label: 'Abrir', onPressed: () async => await OpenFile.open(file.path)),
    content: Text('Documento guardado en: \n${file.path}'),
  ));
}

pw.SpanningWidget getFinalData(
    String total, int i, itemsPerPage, totalProducts) {
  if (i + itemsPerPage >= totalProducts) {
    return pw.Column(
      children: [
        pw.SizedBox(height: 20),
        pw.Row(children: [
          pw.Expanded(child: pw.Container()),
          pw.Text('Total: \$${total}',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
        ])
      ],
    );
  } else {
    return pw.Container();
  }
}

pw.TableRow _buildTableHeader() {
  return pw.TableRow(children: [
    _buildTableCell('Cantidad', true),
    _buildTableCell('Producto', true),
    _buildTableCell('Precio', true),
  ]);
}

pw.TableRow _buildTableRow(Map<String, dynamic> product) {
  return pw.TableRow(children: [
    _buildTableCell(product['quantity'].toString()),
    _buildTableCell(product['name']),
    _buildTableCell('\$${product['price'].toString()}'),
  ]);
}

pw.Widget _buildTableCell(String text, [bool isHeader = false]) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8.0),
    child: pw.Text(
      text,
      style: isHeader ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null,
    ),
  );
}
