import 'package:app_tienda_comida/widgets/bottom_sheet.dart';
import 'package:flutter/material.dart';

class GridViewWidget extends StatelessWidget {
  GridViewWidget({super.key});
  final List list = [
    'el pepe',
    'xd',
    'que mas',
    'seguir',
    'continuar',
    'una vez mas',
    'ultimo'
  ];

  @override
  Widget build(BuildContext context) {
    Future _displayButtomSheet(BuildContext context) async {
      return showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(400, 40),
                  topRight: Radius.elliptical(400, 40))),
          builder: (context) => CustomizedBottomSheet());
    }

    return GridView.builder(
      itemCount: list.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10,
            child: GestureDetector(
              onTap: () => _displayButtomSheet(context),
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: _createGridTile(context, index)),
            ),
          ),
        );
      },
    );
  }

  _createGridTile(BuildContext context, int index) {
    return GridTile(
        footer: GridTileBar(
          title: Text(
            list[index],
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Text(
            '\$150',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        child: Container(
          child: Column(
            children: [
              Text('Refrescos'),
              Container(
                  padding: EdgeInsets.only(top: 15),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset('assets/images/er.jpg'))
            ],
          ),
        ));
  }
}
