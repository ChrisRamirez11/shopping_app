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

    return RefreshIndicator(
      onRefresh: () => idk(),
      child: StreamBuilder<List<Map<String, dynamic>>>(
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
      ),
    );
  }

  _createGridTile(BuildContext context, int index, data) {
    return GridTile(
        footer: GridTileBar(
          title: Text(
            data[index]['name'].toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            '${data[index]['price']}\$',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            width: 200,
            height: 40,
            child: Row(
              children: [
                SizedBox(
                  width: 130,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      data[index]['type'],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                IconButton(
                    onPressed: () {
                      _products.deleteProduct(context, data[index]['id']);
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset('assets/images/er.jpg')),
          SizedBox(
            height: 10,
          )
        ]));
  }
}
