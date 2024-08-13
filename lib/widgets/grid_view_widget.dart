import 'dart:convert';

import 'package:app_tienda_comida/provider/products_provider_supabase.dart';
import 'package:app_tienda_comida/widgets/bottom_sheet.dart';
import 'package:flutter/material.dart';

class GridViewWidget extends StatefulWidget {
  GridViewWidget({super.key});

  @override
  State<GridViewWidget> createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
  final _products = ProductsProviderSupabase();

  @override
  Widget build(BuildContext context) {
    var fetchData = _products.productsStream;

    Future _displayButtomSheet(BuildContext context) async {
      return showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(400, 40),
                  topRight: Radius.elliptical(400, 40))),
          builder: (context) => CustomizedBottomSheet());
    }

    Future<void> idk() {
      setState(() {
        fetchData = _products.productsStream;
      });
      return Future.value();
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: fetchData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data!;
        return GridView.builder(
          itemCount: data.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: GestureDetector(
                  onTap: () => _displayButtomSheet(context),
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
                style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
                color: Colors.white70,
                height: 90,
                width: 160,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Image(image: _loadImage(product))),
            Row(
              children: [
                SizedBox(
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
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(child: Container()),
                IconButton(
                    onPressed: () {
                      _products.deleteProduct(context, data[index]['id']);
                    },
                    icon: const Icon(Icons.add)),
              ],
            )
          ]),
        ));
  }

  _loadImage(product) {
    if (product['pic'].toString().isNotEmpty) {
      return MemoryImage(base64Decode(product['pic']));
    } else {
      return const AssetImage('assets/images/no-image.png');
    }
  }
}
