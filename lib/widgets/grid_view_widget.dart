import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/provider/products_provider_supabase.dart';
import 'package:app_tienda_comida/screens/add_product_screen.dart';
import 'package:app_tienda_comida/utils/cart_addition.dart';
import 'package:app_tienda_comida/widgets/bottom_sheet.dart';
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
if(mounted){
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData
          ? _productsProvider.productsStart(context)
          : _productsProvider.getProduct(context, widget.appBarTitle),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return const Center(child: Text('Ha ocurrido un Error'),);
        }
        else if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        else{
        final data = snapshot.data!;
        return GridView.builder(
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                elevation: 10,
                child: GestureDetector(
                  onLongPress: () => displayTopSheet(context, data[index]), //TODO delete for user App
                  onTap: () {
                    Product product = Product.fromJson(data[index]);
                    displayButtomSheet(context, product);
                  },
                  child:
                      Container(child: _createGridTile(context, index, data)),
                ),
              ),
            );
          },
        );
      }
  });
}else{
  return Text('ERROR INESPERADO');
}
    }
  }

  _createGridTile(BuildContext context, int index, data) {
    final Product product = Product.fromJson(data[index]);
    return GridTile(
        header: GridTileBar(
          title: Center(
            child: Text(product.type,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(flex: 3,
              child: Container(
                  color: Colors.white70,
                  height: 70,
                  width: 140,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: _loadImage(product)),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          product.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          '\$${product.price.toString()}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(child: Container()),
                IconButton(
                    onPressed: () {
                      cartAddition(context, product);
                    },
                    icon: const Icon(Icons.add)),
              ],
            ), SizedBox(height: 5,)
          ]),
        ));
  }

  _loadImage(Product product) {
    if (product.pic.isNotEmpty) {
      return CachedNetworkImage(
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

