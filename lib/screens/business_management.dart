import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/provider/business_magement_selectedValue.dart';
import 'package:app_tienda_comida/provider/products_provider_supabase.dart';
import 'package:app_tienda_comida/provider/theme_provider.dart';
import 'package:app_tienda_comida/screens/no_stock/no_stock_products.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';

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
        leading: Icon(Icons.production_quantity_limits),
        title: getTexts(
            'Productos Agotados', Theme.of(context).textTheme.bodyMedium),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NoStockProducts(),
        )),
      ),
    );
  }

  getMassiveProductsChange(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.price_change),
        title: getTexts(
            'Cambio Masivo de Precio', Theme.of(context).textTheme.bodyMedium),
        onTap: () => showDialog(
          context: context,
          builder: (context) => getMassiveProductsChangeDialog(context),
        ),
      ),
    );
  }

  getMassiveProductsChangeDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController _newPriceController = TextEditingController(text: '');
    SelectedValue valueProvider = provider.Provider.of<SelectedValue>(context);
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    var selectedValue = valueProvider.selectedValue;
    return SimpleDialog(
      backgroundColor: theme.themeData ? second2 : secondary,
      title: Center(
        child: getTexts(
            'Cambio Masivo de Precio', Theme.of(context).textTheme.bodyMedium),
      ),
      children: [
        Container(
          width: size.width * 0.8,
          height: size.height * 0.15,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    padding: EdgeInsets.all(1),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primary)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primary)),
                        isDense: true,
                        contentPadding: EdgeInsets.all(4)),
                    isExpanded: true,
                    value: selectedValue,
                    items: getItems(),
                    onChanged: (value) {
                      valueProvider.changeValue(value!);
                    },
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    style: Theme.of(context).textTheme.labelMedium,
                    controller: _newPriceController,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 0.5,
                                color: theme.themeData
                                    ? Colors.grey.shade50
                                    : tertiary)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 0.5,
                                color: theme.themeData
                                    ? Colors.grey.shade50
                                    : tertiary)),
                        isDense: true,
                        counterStyle: Theme.of(context).textTheme.labelMedium,
                        labelText: 'Inserte un Valor',
                        labelStyle: Theme.of(context).textTheme.labelMedium),
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
                  style: TextButton.styleFrom(
                      fixedSize: Size(10, 5),
                      backgroundColor: Colors.grey.shade700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () => Navigator.of(context).pop(),
                  child: FittedBox(
                    child: getTexts(
                        'Cancelar', Theme.of(context).textTheme.labelMedium),
                  )),
              Expanded(child: Container()),
              TextButton(
                  style: TextButton.styleFrom(
                      fixedSize: Size(10, 5),
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    if (!isNumeric(_newPriceController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Solo números')),
                      );
                      return;
                    }

                    await massivePriceChange(
                        context, _newPriceController, selectedValue);
                    Navigator.pop(context);
                  },
                  child: FittedBox(
                    child:
                        getTexts('Ok', Theme.of(context).textTheme.labelSmall),
                  ))
            ],
          ),
        )
      ],
    );
  }

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

Future<void> massivePriceChange(BuildContext context,
    TextEditingController _newPriceController, String selectedValue) async {
  final ProductsProviderSupabase productsProviderSupabase =
      ProductsProviderSupabase();
  showMassiveChangeDialog(context);

  try {
    List<Map<String, dynamic>> products =
        await productsProviderSupabase.getEveryProduct();

    for (var productMap in products) {
      Product product = Product.fromJson(productMap);
      switch (selectedValue) {
        case 'Plus':
          product.price += double.parse(_newPriceController.text);
          break;
        case 'Times':
          product.price *= double.parse(_newPriceController.text);
          break;
        case 'Less':
          product.price -= double.parse(_newPriceController.text);
          break;
        case 'Divide':
          product.price /= double.parse(_newPriceController.text);
          break;
      }
      await productsProviderSupabase.updateProduct(context, product);
    }
    Navigator.of(context).pop();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al actualizar precios: $e')),
    );
  }
}

void showMassiveChangeDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Actualizando precios..."),
          ],
        ),
      );
    },
  );
}
