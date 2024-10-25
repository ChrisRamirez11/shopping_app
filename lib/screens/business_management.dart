import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/provider/products_provider_supabase.dart';
import 'package:app_tienda_comida/screens/no_stock/no_stock_products.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:flutter/material.dart';

import '../utils/theme.dart';

class BusinessManagement extends StatefulWidget {
  const BusinessManagement({super.key});

  @override
  State<BusinessManagement> createState() => _BusinessManagementState();
}

class _BusinessManagementState extends State<BusinessManagement> {
  String? selectedValue = 'Plus';

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
                getMassiveProductsChange(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para obtener productos sin stock
  getNoStockProducts(BuildContext context) {
    return Card(
      child: ListTile(
        title: getTexts(
            'Productos sin Stock', Theme.of(context).textTheme.bodyMedium),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NoStockProducts(),
        )),
      ),
    );
  }

  // Método para obtener cambio masivo de productos
  getMassiveProductsChange(BuildContext context) {
    return Card(
      child: ListTile(
        title: getTexts(
            'Cambio Masivo de Precio', Theme.of(context).textTheme.bodyMedium),
        onTap: () => showDialog(
          context: context,
          builder: (context) => getMassiveProductsChangeDialog(context),
        ),
      ),
    );
  }

  // Método para mostrar el diálogo de cambio masivo de precio
  getMassiveProductsChangeDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController _newPriceController = TextEditingController(text: '');
    return SimpleDialog(
      title: getTexts(
          'Cambio Masivo de Precio', Theme.of(context).textTheme.bodyMedium),
      children: [
        Container(
          width: size.width * 0.8,
          height: size.height * 0.2,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: DropdownButton<String>(
                      value: selectedValue,
                      items: getItems(),
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    style: Theme.of(context).textTheme.labelMedium,
                    controller: _newPriceController,
                    decoration: InputDecoration(
                        counterStyle: Theme.of(context).textTheme.labelMedium,
                        labelText: 'Valor',
                        labelStyle: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Cerrar diálogo
                child: getTexts(
                    'Cancelar', Theme.of(context).textTheme.labelMedium),
              ),
              Expanded(child: Container()),
              TextButton(
                onPressed: () {
                  if (!isNumeric(_newPriceController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Solo nùmeros')));
                    return;
                  }
                  massivePriceChange(
                      context, _newPriceController, selectedValue!);
                  Navigator.of(context).pop();
                },
                child: getTexts('Ok', Theme.of(context).textTheme.labelMedium),
              )
            ],
          ),
        )
      ],
    );
  }

  // Método para obtener los elementos del Dropdown

  List<DropdownMenuItem<String>> getItems() => <DropdownMenuItem<String>>[
        DropdownMenuItem(
          child: Text('+'),
          value: 'Plus',
        ),
        DropdownMenuItem(
          child: Text('*'),
          value: 'Times',
        ),
        DropdownMenuItem(
          child: Text('-'),
          value: 'Less',
        ),
        DropdownMenuItem(
          child: Text('/'),
          value: 'Divide',
        ),
      ];
}

//TODO ALERTA ANTES DE EMPEZAR HACER EL CAMBIO MASIVO Y FEEDBACK DE TERMINADO
Future<void> massivePriceChange(BuildContext context,
    TextEditingController _newPriceController, String selectedValue) async {
  final ProductsProviderSupabase productsProviderSupabase =
      ProductsProviderSupabase();
  List<Map<String, dynamic>> products =
      await productsProviderSupabase.getEveryProduct();
  for (var productMap in products) {
    Product product = Product.fromJson(productMap);
    switch (selectedValue) {
      case 'Plus':
        product.price += double.parse(_newPriceController.text);
      case 'Times':
        product.price *= double.parse(_newPriceController.text);

      case 'Less':
        product.price -= double.parse(_newPriceController.text);

      case 'Divide':
        product.price /= double.parse(_newPriceController.text);
    }
    productsProviderSupabase.updateProduct(context, product);
  }
}
