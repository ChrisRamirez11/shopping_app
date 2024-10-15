import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

const double inch = 72.0;
const double cm = inch / 2.54;

void getPDf(BuildContext context, Map<String, dynamic> OrderMap) async {
  //TODO EL OrderMap trae ya la lista de OrderedProducts asi que montar pdf de ahi
  int orderId = OrderMap['id'];
  final pdf = pw.Document();

  final icon = pw.MemoryImage(
    (await rootBundle.load('assets/images/icon.png')).buffer.asUint8List(),
  );

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Image(icon, height: 100, width: 100),
            ),
            pw.SizedBox(height: 40),
            pw.Text('Nombre del Cliente: Juan Pérez'),
            pw.SizedBox(height: 20),
            pw.Text('Lista de la compra:'),
            pw.Bullet(text: 'Producto 1 - Cantidad: 2 - Precio: \$20'),
            pw.Bullet(text: 'Producto 2 - Cantidad: 1 - Precio: \$10'),
            pw.Bullet(text: 'Producto 3 - Cantidad: 5 - Precio: \$50'),
            pw.SizedBox(height: 20),
            pw.Text('Total: \$80'),
          ],
        );
      },
    ),
  );

  final output = await getDownloadsDirectory();
  final file = File("${output?.path}/$orderId.pdf");
  await file.writeAsBytes(await pdf.save());
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Documento guardado en: \n${file.path}'),
  ));
}
