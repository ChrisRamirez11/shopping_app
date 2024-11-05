import 'dart:developer';

import 'package:app_tienda_comida/main.dart';
import 'package:app_tienda_comida/models/producto.dart';
import 'package:app_tienda_comida/provider/products_provider_supabase.dart';
import 'package:app_tienda_comida/screens/add_product_screen.dart';
import 'package:app_tienda_comida/widgets/bottom_sheet.dart';
import 'package:app_tienda_comida/widgets/loader.dart';
import 'package:app_tienda_comida/widgets/top_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NoStockGridViewWidget extends StatefulWidget {
  final String appBarTitle;
  const NoStockGridViewWidget({super.key, required this.appBarTitle});

  @override
  State<NoStockGridViewWidget> createState() => _NoStockGridViewWidgetState();
}

class _NoStockGridViewWidgetState extends State<NoStockGridViewWidget> {
  final _productsProvider = ProductsProviderSupabase();

  @override
  Widget build(BuildContext context) {
    Future displayButtomSheet(BuildContext context, productMap) async {
      Product product = Product.fromJson(productMap);

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

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return loader();
        }
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
                  onLongPress: () => displayTopSheet(context, data[index]),
                  onTap: () {
                    displayButtomSheet(context, data[index]);
                  },
                  child:
                      Container(child: _createGridTile(context, index, data)),
                ),
              ),
            );
          },
        );
      },
    );
  }

  _createGridTile(BuildContext context, int index, data) {
    final product = data[index];
    return GridTile(
        header: GridTileBar(
          title: Center(
            child: Text(product['type'],
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
                  height: 90,
                  width: 160,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: _loadImage(product)),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          product['name'].toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      SizedBox(
                        width: 110,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          product['price'].toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),SizedBox(height: 5,)
          ]),
        ));
  }

  _loadImage(product) {
    if (product['pic'].toString().isNotEmpty) {
      return CachedNetworkImage(fit: BoxFit.cover,
        cacheManager: null,
        imageUrl: product['pic'],
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

  Future<List<Map<String, dynamic>>> fetchData() async {
    List<Map<String, dynamic>> list = [];
    List<Map<String, dynamic>> listToReturn = [];
    try {
      Future<List<Map<String, dynamic>>> response =
          supabase.from('products').select('*').eq('quantity', 0);
      list = await response.then(
        (value) => value.toList(),
      );
      for (var element in list) {
        if (element['availability'] == false) {
          listToReturn.add(element);
        }
      }
      return listToReturn;
    } on AuthException catch (error) {
      log(error.message);
      return listToReturn;
    } catch (error) {
      log('Ha ocurrido un error, vuelva a intentarlo. $error');
      return listToReturn;
    }
  }
}
