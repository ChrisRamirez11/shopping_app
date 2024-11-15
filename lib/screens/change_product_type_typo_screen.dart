import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/provider/product_list_provider.dart';
import 'package:app_tienda_comida/provider/product_type_value_provider.dart';
import 'package:app_tienda_comida/services/products_provider_supabase.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeProductTypeTyposScreen extends StatefulWidget {
  const ChangeProductTypeTyposScreen({super.key});

  @override
  State<ChangeProductTypeTyposScreen> createState() =>
      _ChangeProductTypeTyposScreenState();
}

class _ChangeProductTypeTyposScreenState
    extends State<ChangeProductTypeTyposScreen> {
  TextEditingController _newTypeName = TextEditingController();

  @override
  void dispose() {
    _newTypeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsListNotifier = Provider.of<ProductsListNotifier>(context);
    final productTypeValueProvider =
        Provider.of<ProductTypeValueProvider>(context);
    Size size = MediaQuery.sizeOf(context);
    _newTypeName.text = productTypeValueProvider.productTypeValueProvider;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: secondary,
          backgroundColor: primary,
        ),
        body: Container(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              getTypesMenuList(productsListNotifier, productTypeValueProvider),
              getButton(productTypeValueProvider),
              getTextFormField()
            ],
          ),
        ),
      ),
    );
  }

  getTypesMenuList(ProductsListNotifier productsListNotifier,
      ProductTypeValueProvider typeValueProvider) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Card(
        child: DropdownMenu(
          textStyle: Theme.of(context).textTheme.labelMedium,
          width: double.infinity,
          dropdownMenuEntries: getItems(productsListNotifier),
          initialSelection: productsListNotifier.productsListNotifier.first,
          onSelected: (value) => typeValueProvider.changeValue(value),
        ),
      ),
    );
  }

  List<DropdownMenuEntry> getItems(ProductsListNotifier productsListNotifier) {
    return productsListNotifier.productsListNotifier.map(
      (e) {
        return DropdownMenuEntry(value: e, label: e);
      },
    ).toList();
  }

  getButton(ProductTypeValueProvider typeValueProvider) {
    return ElevatedButton(
        onPressed: () async =>
            await changeProductTypeTypo(typeValueProvider, _newTypeName),
        child: Text('Cambiar'));
  }

  getTextFormField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        style: Theme.of(context).textTheme.labelLarge,
        controller: _newTypeName,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          labelText: 'Nombre y Apellido',
        ),
      ),
    );
  }

  changeProductTypeTypo(ProductTypeValueProvider typeValueProvider,
      TextEditingController text) async {
    ProductsProviderSupabase productsProviderSupabase =
        ProductsProviderSupabase();
    showUndismissibleDialog(context, 'Cambiando');
    try {
      List<Map<String, dynamic>> list =
          await productsProviderSupabase.getProductByType(
              context, typeValueProvider.productTypeValueProvider);
      for (var productMap in list) {
        Product product = Product.fromJson(productMap);
        product.type = text.text;
        await productsProviderSupabase.updateProduct(context, product);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Productos Actualizados al Nuevo Tipo \n Reinicie la aplicaciòn para ver los cambios')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ha ocurrido un error')));
    }
    Navigator.pop(context);
  }
}
