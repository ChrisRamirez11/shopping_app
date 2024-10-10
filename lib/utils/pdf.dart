import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PDFPage extends StatelessWidget {
  static const double inch = 72.0;
  static const double cm = inch / 2.54;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('PDF Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
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
              final file = File("${output?.path}/example.pdf");
              await file.writeAsBytes(await pdf.save());
              log(file.path);
            },
            child: Text('Generar PDF'),
          ),
        ),
      );
  }
}

