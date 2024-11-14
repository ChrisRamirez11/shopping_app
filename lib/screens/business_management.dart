import 'package:app_tienda_comida/screens/no_stock/no_stock_products.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:app_tienda_comida/widgets/massive_price_change_dialog.dart';
import 'package:flutter/material.dart';

import '../utils/theme.dart';

class BusinessManagement extends StatefulWidget {
  const BusinessManagement({super.key});

  @override
  State<BusinessManagement> createState() => _BusinessManagementState();
}

class _BusinessManagementState extends State<BusinessManagement> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Gestiòn del Negocio',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          foregroundColor: secondary,
          backgroundColor: primary,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                getNoStockProducts(context),
                MassivePriceChangeDialog()
              ],
            ),
          ),
        ),
      ),
    );
  }

  getNoStockProducts(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.production_quantity_limits),
        title: getTexts(
            'Productos Agotados', Theme.of(context).textTheme.bodyMedium),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NoStockProducts(),
        )),
      ),
    );
  }
}
