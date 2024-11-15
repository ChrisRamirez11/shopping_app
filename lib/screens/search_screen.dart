import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/services/products_provider_supabase.dart';
import 'package:app_tienda_comida/screens/add_product_screen.dart';
import 'package:app_tienda_comida/utils/is_admin.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/screens/product_details_screen.dart';
import 'package:app_tienda_comida/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

import '../provider/theme_provider.dart';
import '../widgets/top_modal_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>>? _results;
  String _input = '';

  void _onSearchFieldChanged(String value) async {
    setState(() {
      _input = value;
    });

    if (_input.isNotEmpty) {
      final results = await searchProducts(_input);
      setState(() {
        _results = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool theme = Provider.of<ThemeProvider>(context).themeData;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: secondary,
          backgroundColor: primary,
          title: TextField(
            style: Theme.of(context).textTheme.labelMedium,
            onChanged: _onSearchFieldChanged,
            decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.labelMedium,
                labelText: 'Buscar',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _results?.length ?? 0,
                itemBuilder: (context, index) {
                  final product = Product.fromJson(_results![index]);
                  return getListTile(product, theme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  searchProducts(String input) async {
    try {
      final response =
          await supabase.from('products').select().ilike('name', '%$input%');
      return response;
    } catch (e) {
      if (mounted) {
        return 'Ha ocurrido un error, revise su conexiòn a internet';
      }
    }
  }

  Widget getListTile(Product product, bool theme) {
    return Card(
      color: theme ? second2 : null,
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: Center(
          child: ListTile(
              leading: Hero(
                tag: '${product.id}',
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: _loadImage(product),
                ),
              ),
              title: Text(
                product.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                '#${product.type}',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: theme ? greenCustom : Colors.green.shade900),
                overflow: TextOverflow.ellipsis,
              ),
              onLongPress: () async {
                await AuthService().isAdmin()
                    ? displayTopSheet(context, product)
                    : null;
              },
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ));
              }),
        ),
      ),
    );
  }

  Future displayTopSheet(BuildContext context, Product product) async {
    ProductsProviderSupabase _productsProvider = ProductsProviderSupabase();
    return showTopModalSheet(
        context,
        CustomizedTopShet(
            productName: product.name,
            onDelete: () {
              _productsProvider.deleteProduct(context, product);
              Navigator.of(context).pop();
            },
            onEdit: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => AddProductScreen(
                  product: product,
                ),
              ));
            }));
  }

  _loadImage(product) {
    if (product.pic.isNotEmpty) {
      return CustomImageWidget(imageUrl: product.pic);
    } else {
      return const Image(
        image: AssetImage('assets/images/no-image.png'),
      );
    }
  }
}
