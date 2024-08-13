import 'package:app_tienda_comida/provider/products_provider_supabase.dart';
import 'package:app_tienda_comida/widgets/bottom_sheet.dart';
import 'package:app_tienda_comida/widgets/topModalSheet.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

class GridViewWidget extends StatefulWidget {
  GridViewWidget({super.key});

  @override
  State<GridViewWidget> createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
  final _products = ProductsProviderSupabase().products;

  @override
  Widget build(BuildContext context) {
  
    Future _showTopModal(BuildContext context) async {
   return showTopModalSheet<String?>(
      context,
      CustomizedTopShet(productName: 'Platanito Frito', onEdit: (){} , onDelete: (){}),
      backgroundColor: Colors.white,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
    );

  }

    Future _displayButtomSheet(BuildContext context) async {
      return showModalBottomSheet(
       scrollControlDisabledMaxHeightRatio: MediaQuery.of(context).size.height*0.7,
          context: context,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(400, 40),
                  topRight: Radius.elliptical(400, 40))),
          builder: (context) => CustomizedBottomSheet());
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _products,
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
                  onLongPress: () => _showTopModal(context),
                  child: Container(
                      margin: EdgeInsets.all(10),
                      child: _createGridTile(context, index, data)),
                ),
              ),
            );
          },
        );
      },
    );
  }

  _createGridTile(BuildContext context, int index, data) {
    return GridTile(
        footer: GridTileBar(
          title: Text(
            data[index]['name'].toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Text(
            data[index]['price'].toString() + '\$',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        child: Container(
          child: Column(
            children: [
              Text(
                data[index]['type'],
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                  padding: EdgeInsets.only(top: 15),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset('assets/images/er.jpg'))
            ],
          ),
        ));
  }
}
