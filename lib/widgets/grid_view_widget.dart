import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/provider/carrito_provider.dart';
import 'package:app_tienda_comida/provider/products_provider_supabase.dart';
import 'package:app_tienda_comida/screens/add_product_screen.dart';
import 'package:app_tienda_comida/utils/cart_addition.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/screens/product_details_screen.dart';
import 'package:app_tienda_comida/widgets/custom_error_widget.dart';
import 'package:app_tienda_comida/widgets/custom_loader_widget.dart';
import 'package:app_tienda_comida/widgets/top_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../provider/product_list_provider.dart';

class GridViewWidget extends StatefulWidget {
  final String appBarTitle;
  const GridViewWidget({super.key, required this.appBarTitle});

  @override
  State<GridViewWidget> createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
  final _productsProvider = ProductsProviderSupabase();

  @override
  Widget build(BuildContext context) {
    var fetchData = _fetchDataSelector(widget.appBarTitle);
    final productListNotifier = Provider.of<ProductsListNotifier>(context);

    if (mounted) {
      return FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchData
              ? _productsProvider.productsStart(context)
              : _productsProvider.getProduct(context, widget.appBarTitle),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return custom_error_widget(productListNotifier);
            } else if (!snapshot.hasData) {
              return custom_loader_widget();
            } else {
              final data = snapshot.requireData;
              return GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      elevation: 10,
                      child: GestureDetector(
                        onLongPress: () => displayTopSheet(
                            context, data[index]), //TODO delete for user App
                        onTap: () {
                          Product product = Product.fromJson(data[index]);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(product: product),
                          ));
                        },
                        child: _createGridContainer(context, index, data),
                      ),
                    ),
                  );
                },
              );
            }
          });
    } else {
      return Text('ERROR INESPERADO');
    }
  }

  Future displayTopSheet(BuildContext context, productMap) async {
    Product product = Product.fromJson(productMap);

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
}

_createGridContainer(BuildContext context, int index, data) {
  //TODO NULL VALUES ERROR

  CartProvider cartProvider = Provider.of<CartProvider>(context);
  final Product product = Product.fromJson(data[index]);

  return Container(
    height: double.maxFinite,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: second2,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 5),
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 8,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: double.maxFinite,
                  width: double.maxFinite,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Hero(
                      tag: '${product.id}',
                      child: _loadImage(product),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              product.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        Center(
          child: Divider(
            color: white,
            indent: 10,
            endIndent: 10,
            thickness: 0.5,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 20,
          width: double.infinity - 100,
          child: Text(
            '#${product.type}',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: greenCustom),
          ),
        ),
        Expanded(
          flex: 4,
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 90,
                      child: Text(
                        '\$${product.price.toString()}',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(child: Container()),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 1, bottom: 5),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 11),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: primary,
                    ),
                    child: IconButton(
                      color: white,
                      onPressed: () {
                        cartAddition(context, product, cartProvider);
                      },
                      icon: const Icon(
                        Icons.add_shopping_cart_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 3,
        )
      ],
    ),
  );
}

_loadImage(Product product) {
  if (product.pic.isNotEmpty) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      cacheManager: null,
      imageUrl: product.pic,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  } else {
    return const Image(
      fit: BoxFit.cover,
      image: AssetImage('assets/images/no-image.png'),
    );
  }
}

_fetchDataSelector(String appBarTitle) {
  if (appBarTitle.contains('Inicio')) {
    return true;
  } else {
    return false;
  }
}
