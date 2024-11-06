import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/provider/products_provider_supabase.dart';
import 'package:app_tienda_comida/screens/add_product_screen.dart';
import 'package:app_tienda_comida/utils/cart_addition.dart';
import 'package:app_tienda_comida/utils/theme.dart';
import 'package:app_tienda_comida/widgets/bottom_sheet.dart';
import 'package:app_tienda_comida/widgets/loader.dart';
import 'package:app_tienda_comida/widgets/top_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

    Future displayButtomSheet(BuildContext context, Product product) async {
      return showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(400, 40),
                  topRight: Radius.elliptical(400, 40))),
          builder: (context) => CustomizedBottomSheet(product: product));
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

    if (mounted) {
      return FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchData
              ? _productsProvider.productsStart(context)
              : _productsProvider.getProduct(context, widget.appBarTitle),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Ha ocurrido un Error'),
              );
            } else if (!snapshot.hasData) {
              return loader();
            } else {
              final data = snapshot.data!;
              return GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal:  8.0),
                    child: Card(
                      elevation: 10,
                      child: GestureDetector(
                        onLongPress: () => displayTopSheet(
                            context, data[index]), //TODO delete for user App
                        onTap: () {
                          Product product = Product.fromJson(data[index]);
                          displayButtomSheet(context, product);
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
}

_createGridContainer(BuildContext context, int index, data) {
  final Product product = Product.fromJson(data[index]);
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: second2,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(5)),
                height: 140,
                width: 140,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: _loadImage(product),
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            product.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
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
        Expanded(
          flex: 2,
          child: Row(
            children: [
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        '#${product.type}',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: greenCustom),
                      ),
                    ),
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
              Padding(
                padding: const EdgeInsets.only(right: 6, bottom: 5),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primary,
                  ),
                  child: IconButton(
                    color: white,
                    onPressed: () {
                      cartAddition(context, product);
                    },
                    icon: const Icon(Icons.add_shopping_cart_outlined),
                  ),
                ),
              ),
            ],
          ),
        ),
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
